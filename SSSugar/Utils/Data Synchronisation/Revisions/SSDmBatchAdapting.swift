import Foundation

public enum SSDmBatchAdaptError: Error {
    case cantAdapt
}

public enum SSDmToChangeAdaptResult {
    case passed
    case adapted
    case canceled
    case invalid
}

public protocol SSDmBatchAdapting {
    associatedtype Change : SSDataModifying
    associatedtype Request : SSDataModifying
    
    typealias Batch = SSDmBatch<Request>
    typealias Revision = SSDmRevision<Change>
    typealias Strategy = (Change, Request) -> SSDmToChangeAdaptResult
    typealias Strategies = [String : Strategy]
    typealias Builder = SSDMAdaptStrategyBuilder<Change, Request>
    
    var strategies: Strategies { get }
    
    func adaptBatch(_ batch: Batch, by revision: Revision) -> SSDmBatchAdaptError?
    func adaptBatch(_ batch: Batch, by revisions: [Revision]) -> SSDmBatchAdaptError?
}

extension SSDmBatchAdapting {
    func adaptBatch(_ batch: Batch, by revision: Revision) -> SSDmBatchAdaptError? {
        adaptBatch(batch, by: [revision])
    }
    
    func adaptBatch(_ batch: Batch, by revisions: [Revision]) -> SSDmBatchAdaptError? {
        func adaptBatch(_ batch: Batch, by change: Change, using strategy: Strategy) throws {
            try batch.filterRequests {
                switch strategy(change, $0) {
                case .canceled:
                    return false
                case .adapted, .passed:
                    return true
                case .invalid:
                    throw SSDmBatchAdaptError.cantAdapt
                }
            }
        }
        func adapt() throws {
            try revisions.forEach {
                try $0.changes.forEach {
                    try adaptBatch(batch, by: $0, using: strategies[$0.title]!)
                }
            }
        }
        return SSTry.cast(job: adapt)
    }
}

public class SSDMAdaptStrategyBuilder<Change: SSDataModifying, Request: SSDataModifying> {
    typealias Strategy = (Change, Request) -> SSDmToChangeAdaptResult
    typealias Result = (title: String, adapt: Strategy)
    
    class Adapt<Adapting> {
        class To<ToChange: SSDmChange> {
            class func strategy(with block: @escaping (Adapting, ToChange) -> SSDmToChangeAdaptResult) -> Result {
                return Try<Adapting, ToChange>.strategy(with: block)
            }
        }
    }
    class Try<Adapting, ToChange: SSDmChange> {
        class func strategy(with block: @escaping (Adapting, ToChange) -> SSDmToChangeAdaptResult) -> Result {
            func adapt(_ change: Change, _ request: Request) -> SSDmToChangeAdaptResult {
                if let adapting = request as? Adapting {
                    return block(adapting, change as! ToChange)
                }
                return .passed
            }
            return (ToChange.title, adapt(_:_:))
        }
    }
}
