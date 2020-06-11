import Foundation

/// Errors may occur during Revisions Dispatching.
/// * `emptyRevisions` - passed revisions sequence is empty.
/// * `revisionMissmatch` - numbers of passed revisions don't corespond to stored data revision number.
public enum SSDmRevisionDispatcherError: Error {
    /// Passed revisions sequence is empty.
    case emptyRevisions
}

/// Requirements for Revisions dispatching utility
///
/// Requires some SSDataModifying as Revision's change type.
public protocol SSDmRevisionDispatcher {
    /// Revision's change type
    associatedtype Change : SSDataModifying
    /// Revision type
    typealias Revision = SSDmRevision<Change>
    
    /// Dispatch passed revisions
    /// - Parameters:
    ///   - revisions: Array of revisions to dispatch.
    ///   - onApply: Apply revisions handler.
    /// - Returns: Error might occur during dispatching.
    func dispatchRevisions(_ revisions: [Revision], onApply: (()->Void)?) -> SSDmRevisionDispatcherError?
    
    /// Dispatch passed revisions
    /// - Parameters:
    ///   - revisions: Array of revisions to dispatch.
    /// - Returns: Error might occur during dispatching.
    func dispatchRevisions(_ revisions: [Revision]) -> SSDmRevisionDispatcherError?
}

extension SSDmRevisionDispatcher {
    public func dispatchRevisions(_ revisions: [Revision]) -> SSDmRevisionDispatcherError? {
        dispatchRevisions(revisions, onApply: nil)
    }
}

/// Error may occur during requests dispatching.
///
/// * `invalidData` – modification(s) of requests doesn't conform to stored data.
public enum SSDmRequestDispatchError: Error {
    /// Modification(s) of requests doesn't fit stored data.
    case invalidData
}

/// Requirements for Requests dispatching tool.
///
/// Requires some SSDataModifying as Request.
public protocol SSDmRequestDispatcher {
    /// Dispatching request type
    associatedtype Request : SSDataModifying
    /// Finish handler type
    /// - Parameters:
    ///   - error: Error might occur during dispatching, passed to handler.
    typealias Handler = (_ error: SSDmRequestDispatchError?)->Void
    
    /// Dipsatches passed requests.
    /// - Parameters:
    ///   - requests: Array or requests to dispatch.
    ///   - handler: Finish handler.
    func dispatchReuqests(_ requests: [Request], handler: @escaping Handler)
}

/// Errors may occur during Requests apply
/// * `revisionMissmatch` - passed revision doesn't conforms to stored data's revision number.
/// * `invalidData` - one of request's modify doesn't fit stored data.
public enum SSDmBatchApplyError: Error {
    /// Passed revision doesn't conforms to stored data's revision number.
    case revisionMissmatch
    /// Modifies of some requests doesn't confrom to stored data.
    /// - indexes: Indexes of failed requests.
    case invalidData(indexes: [Int])
}

/// Requirements for Batch applying tool.
///
/// Requires some SSDataModifying as Batch's request.
public protocol SSDmBatchApplier {
    /// Batch's request type
    associatedtype Request : SSDataModifying
    /// Batch type
    typealias Batch = SSDmBatch<Request>
    /// Finish handler
    typealias Handler = (SSDmBatchApplyError?)->Void
    
    /// Applies passed batch depends on passed revision number
    /// - Parameters:
    ///   - batches: Batch of reqwuests to apply.
    ///   - revNumber: Revision number of data requests based on.
    ///   - handler: Finish handler.
    func applyBatches(_ batches: [Batch], revNumber: Int, handler: @escaping Handler)
}

/// Tool for updating interface with revision based modifies. Creates and sends notifications from revisions, controls revision number to avoid gaps and overlaps. Applies requests, then creates and sends updates on success, otherwise stores them to adapt and apply when new revisions arrive.
///
/// - Conforms to: SSDmRevisionDispatcher, SSDmRequestDispatcher (if Chnage and Request types are the same via coresponding utils).
///
/// Requires some `SSDataModifying` as Change, some `SSDataModifying` as Request, some `SSDmBatchApplier` as Batch Applier and `SSDmBatchAdapting` as Batch Adapter.
public class SSDataModifyCenter<Change: SSDataModifying, Request: SSDataModifying, Applier: SSDmBatchApplier, Adapter: SSDmBatchAdapting> {
    /// Modify Center batch of requests type
    typealias Batch = SSDmBatch<Request>
    
    /// Class helper/holder represents scheduled Batch. Stores batch, finish handler and optional error might occur during apply or adapt.
    private class ScheduledBatch {
        /// Batch of requests to dispatch
        var batch: Batch
        /// Finish handler
        var handler: SSDmRequestDispatcher.Handler
        /// Optional error occured during dispatching
        var error: SSDmRequestDispatchError?
        
        /// Creates new Schedule with passed batch and finish handler
        /// - Parameters:
        ///   - batch: Batch of requests
        ///   - handler: Finish handler
        init(batch mBatch: Batch, handler mHandler: @escaping SSDmRequestDispatcher.Handler) {
            batch = mBatch
            handler = mHandler
        }
        
        /// Calls finish handler
        func finish() {
            handler(error)
        }
    }
    
    /// Current data revision number. Used to detect are applying requests actual or not (should be adapted). Also used to guaranty applying requests have no gaps or overlaps.
    public private(set) var revNumber: Int
    /// Update center to send updates of dispatched modifications to interface.
    public let updateNotifier: SSUpdateNotifier
    /// Request applier
    public let applier: Applier
    /// Request adapter
    public let adapter: Adapter
    
    /// Scheduled batch of requests for apply
    private var schedules = [ScheduledBatch]()
    
    /// Creates new Data Modify Center with passed params
    /// - Parameters:
    ///   - revisionNumber: Initial revision number.
    ///   - updateNotifier: Update center.
    ///   - batchApplier: Requests applier.
    ///   - adaper: Requests adapter.
    public init(revisionNumber: Int, updateNotifier mUpdateNotifier: SSUpdateNotifier, batchApplier mBatchApplier: Applier, adapter mAdaper: Adapter) {
        revNumber = revisionNumber
        updateNotifier = mUpdateNotifier
        applier = mBatchApplier
        adapter = mAdaper
    }
    
    /// Asserts is main thread.
    private func ensureIsMain() {
        assert(OperationQueue.current == OperationQueue.main)
    }
}

extension SSDataModifyCenter: SSDmRevisionDispatcher where
    Request == Adapter.Request,
    Change == Adapter.Change,
    Request == Applier.Request
{
    /// Dispatch passed revisions. Checks 'em, checks revision number. Creates and post notifications. Then asynchronously (on apply) updates revision number, adapts and applies scheduled batches.
    /// - Parameters:
    ///   - revisions: Revisions to dispatch
    /// - Returns: Error might occur during dispatching.
    public func dispatchRevisions(_ revisions: [SSDmRevision<Change>], onApply: (() -> Void)?) -> SSDmRevisionDispatcherError? {
        guard !revisions.isEmpty else { return SSDmRevisionDispatcherError.emptyRevisions }
        
        notify(revisions: revisions, onApply: onApply)
        return nil
    }
    
    /// Creates and posts updates, then update revision number adapts and applies scheduled batches.
    /// - Parameter revisions: Revisions to process
    private func notify(revisions: [SSDmRevision<Change>], onApply: (() -> Void)? = nil) {
        func onNotify(revision: SSDmRevision<Change>) {
            guard revision.number == revNumber + 1 else {
                fatalError("Invalid revision number \(revisions.first!.number), but expected \(revNumber + 1)")
            }
            revNumber = revision.number
            adaptBatches(to: revision)
        }
        func onLastNotify(revision: SSDmRevision<Change>) {
            onNotify(revision: revision)
            reaplySchedules()
            onApply?()
        }
        func notify(revision: SSDmRevision<Change>, handler: @escaping ()->Void) {
            let updates = revision.changes.map { $0.toUpdate() }
            
            updateNotifier.notify(updates: updates, onApply: handler)
        }
        for i in (0..<revisions.count-1) {
            let revision = revisions[i]
            notify(revision: revision) { onNotify(revision: revision) }
        }
        notify(revision: revisions.last!) { onLastNotify(revision: revisions.last!) }
    }
    
    /// Adapts scheduled batches by passed revisions
    /// - Parameter revision: Revisions to adapt shcedlued batches by
    private func adaptBatches(to revision: SSDmRevision<Change>) {
        if (!schedules.isEmpty) {
            func isRemoved(_ scheduled: ScheduledBatch) -> Bool {
                let error = adapter.adaptBatch(scheduled.batch, by: revision)
                
                if (error != nil || scheduled.batch.requests.isEmpty) {
                    scheduled.error = Self.adaptToApplyError(error)
                    scheduled.finish()
                    return true
                }
                return false
            }
            schedules.removeAll(where: isRemoved(_:))
        }
    }
    
    /// Applies scheduled batches if exist
    private func reaplySchedules() {
        if (!schedules.isEmpty) {
            apply(schedules)
        }
    }
    
    /// Converts Adapting Error to Dispatching one
    /// - Parameter error: Adapting error to convert
    /// - Returns: Converted Dispatching error
    private class func adaptToApplyError(_ error: SSDmBatchAdaptError?) -> SSDmRequestDispatchError? {
        switch error {
        case .cantAdapt:
            return .invalidData
        case .none:
            return nil
        }
    }
}

extension SSDataModifyCenter: SSDmRequestDispatcher where Request == Applier.Request {
    /// Dispatches passed request. Creates and stores scheduled batches based on passed requests and tries apply em with current revision number.
    /// - Parameters:
    ///   - requests: Requests to dispatch
    ///   - handler: Finish handler
    public func dispatchReuqests(_ requests: [Request], handler: @escaping (SSDmRequestDispatchError?)->Void) {
        let scheduled = ScheduledBatch(batch: SSDmBatch(requests: requests), handler: handler)
        
        ensureIsMain()
        
        schedules.append(scheduled)
        apply([scheduled])
    }
    
    /// Tries apply passed schedules via `applier`. Calls finish handlers on success or onvalid data error. Does nothing on rev missmatch error, cuz stored scheduled batches will adapt and apply on new revisions arrive.
    /// - Parameter schedules: Schedules to apply.
    private func apply(_ schedules: [ScheduledBatch]) {
        func onApply(error: SSDmBatchApplyError?) {
            switch error {
            case .revisionMissmatch:
                break //New dispatch already scheduled on Request adapting
            case .invalidData(let indexes):
                schedules.forEach {
                    if (indexes.contains($1)) {
                        $0.error = .invalidData
                    }
                    finish(scheduled: $0)
                }
            case .none:
                schedules.forEach {
                    finish(scheduled: $0)
                }
            }
        }
        applier.applyBatches(schedules.map{ $0.batch }, revNumber: revNumber, handler: onApply(error:))
    }
    
    /// Finishes passed scheduled batch. Calls corresponding finish handler, removes it from stored schedules, creates and sends updates if no error occured.
    /// - Parameter scheduled: Scheduled batch to finish.
    private func finish(scheduled: ScheduledBatch) {
        func finish() {
            scheduled.finish()
            if let index = schedules.firstIndex(where:{ $0 === scheduled }) {
                schedules.remove(at: index)
            } else {
                assert(false, "Batch not found")
            }
        }
        if (scheduled.error == nil) {
            let updates = scheduled.batch.requests.map { $0.toUpdate() }
            updateNotifier.notify(updates: updates, onApply: finish)
        } else {
            DispatchQueue.main.async { finish() }
        }
    }
}
