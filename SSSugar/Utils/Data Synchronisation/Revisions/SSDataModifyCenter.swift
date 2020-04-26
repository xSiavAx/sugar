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
    
    public private(set) var revision: Int
    public let updateNotifier: SSUpdateNotifier
    public let applier: Applier
    public let adapter: Adapter
    
    private var schedules = [ScheduledBatch]()
    
    public init(revisionNumber: Int, updateNotifier mUpdateNotifier: SSUpdateNotifier, batchApplier mBatchApplier: Applier, adapter mAdaper: Adapter) {
        revision = revisionNumber
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
        guard revisions.first!.number == revision + 1 else { throw SSDmRevisionDispatcherError.revisionMissmatch }
        
        notify(revisions: revisions)
        revision = revisions.last!.number
        
        func adapt() {
            rescheduleBatches(with: revisions)
        }
        DispatchQueue.main.async(execute: adapt)
    }
    
    private func notify(revisions: [SSDmRevision<Change>]) {
        revisions.forEach {
            $0.changes.forEach {
                updateNotifier.notify(update: $0.toUpdate())
            }
        }
    }
    
    private func rescheduleBatches(with revisions: [Revision]) {
        if (!schedules.isEmpty) {
            func isIncluded(_ scheduled: ScheduledBatch) ->Bool {
                let error = adapter.adaptBatch(scheduled.batch, by: revisions)
                
                if (error != nil || scheduled.batch.requests.isEmpty) {
                    scheduled.error = Self.adaptToApplyError(error)
                    scheduled.finish()
                    return false
                }
                return true
            }
            schedules = schedules.filter(isIncluded(_:))
            if (!schedules.isEmpty) {
                schedule(schedules)
            }
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
        applier.applyBatches(schedules.map{ $0.batch }, revNumber: revision) { (error) in
            DispatchQueue.main.async {
                onApply(error: error)
            }
        }
    }
    
    private func finish(scheduled: ScheduledBatch) {
        if (scheduled.error == nil) {
            scheduled.batch.requests.forEach { updateNotifier.notify(update: $0.toUpdate()) }
        }
        scheduled.finish()
        if let index = schedules.firstIndex(where:{ $0 === scheduled }) {
            schedules.remove(at: index)
        } else {
            assert(false, "Batch not found")
        }
    }
}
