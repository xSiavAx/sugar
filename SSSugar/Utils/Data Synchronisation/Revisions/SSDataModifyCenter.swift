import Foundation

public enum SSDmRevisionDispatcherError: Error {
    case emptyRevisions
    case revisionMissmatch
}

public protocol SSDmRevisionDispatcher {
    associatedtype Change : SSDataModifying
    typealias Revision = SSDmRevision<Change>
    
    func dispatchRevisions(_ revisions: [Revision], handler: @escaping (SSDmRevisionDispatcherError?)->Void)
}

public enum SSDmRequestDispatchError: Error {
    case invalidData
}

public protocol SSDmRequestDispatcher {
    associatedtype Request : SSDataModifying
    typealias Handler = (SSDmRequestDispatchError?)->Void
    
    func dispatchReuqests(_ requests: [Request], handler: @escaping Handler)
}

public enum SSDmBatchApplyError: Error {
    case revisionMissmatch
    case invalidData(indexes: [Int])
}

public protocol SSDmBatchApplier {
    associatedtype Request : SSDataModifying
    typealias Batch = SSDmBatch<Request>
    typealias Handler = (SSDmBatchApplyError?)->Void
    
    func applyBatches(_ batches: [Batch], revNumber: Int, handler: @escaping Handler)
}

public class SSDataModifyCenter<Change: SSDataModifying, Request: SSDataModifying, Applier: SSDmBatchApplier, Adapter: SSDmBatchAdapting> {
    typealias Batch = SSDmBatch<Request>
    
    class ScheduledBatch {
        var batch: Batch
        var handler: Handler
        var error: SSDmRequestDispatchError?
        
        init(batch mBatch: Batch, handler mHandler: @escaping Handler) {
            batch = mBatch
            handler = mHandler
        }
        
        func finish() {
            handler(error)
        }
    }
    
    public private(set) var revNumber: Int
    public let updateNotifier: SSUpdateNotifier
    public let applier: Applier
    public let adapter: Adapter
    
    private var schedules = [ScheduledBatch]()
    
    public init(revisionNumber: Int, updateNotifier mUpdateNotifier: SSUpdateNotifier, batchApplier mBatchApplier: Applier, adapter mAdaper: Adapter) {
        revNumber = revisionNumber
        updateNotifier = mUpdateNotifier
        applier = mBatchApplier
        adapter = mAdaper
    }
    
    private func ensureIsMain() {
        assert(OperationQueue.current == OperationQueue.main)
    }
}

extension SSDataModifyCenter: SSDmRevisionDispatcher where
    Request == Adapter.Request,
    Change == Adapter.Change,
    Request == Applier.Request
{
    public func dispatchRevisions(_ revisions: [SSDmRevision<Change>], handler: @escaping (SSDmRevisionDispatcherError?) -> Void) {
        handler(SSTry.cast { try dispatchRevisions(revisions) })
    }
    
    private func dispatchRevisions(_ revisions: [SSDmRevision<Change>]) throws {
        guard !revisions.isEmpty else { throw SSDmRevisionDispatcherError.emptyRevisions }
        guard revisions.first!.number == revNumber + 1 else { throw SSDmRevisionDispatcherError.revisionMissmatch }
        
        notify(revisions: revisions)
        
        DispatchQueue.main.async(execute: rescheduleBatches)
    }
    
    private func notify(revisions: [SSDmRevision<Change>]) {
        revisions.forEach {(revision) in
            let updates = revision.changes.map { $0.toUpdate() }
            
            func onApply() {
                adaptBatches(to: revision)
                revNumber = revision.number
            }
            
            updateNotifier.notify(updates: updates, onApply: onApply)
        }
    }
    
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
    
    private func rescheduleBatches() {
        if (!schedules.isEmpty) {
            schedule(schedules)
        }
    }
    
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
    public func dispatchReuqests(_ requests: [Request], handler: @escaping (SSDmRequestDispatchError?)->Void) {
        let scheduled = ScheduledBatch(batch: SSDmBatch(requests: requests), handler: handler)
        
        ensureIsMain()
        
        schedules.append(scheduled)
        schedule([scheduled])
    }
    
    private func schedule(_ schedules: [ScheduledBatch]) {
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
