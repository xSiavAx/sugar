import Foundation

/// Errors may occur during requests Batch adaptation
/// * `cantAdapt` – one of Batch's requst cant be adapted
public enum SSDmBatchAdaptError: Error {
    /// One of Batch's requst cant be adapted
    case cantAdapt
}

/// Result of adaptation Modification (usually request) to Change
/// * `passed` - modification doesn't need adaptation.
/// * `adapted` - modification adapted to change.
/// * `canceled` - modification has canceled by change during adaptation.
/// * `invalid` - modification can't be adapted to change.
public enum SSDmToChangeAdaptResult {
    /// Modification doesn't need adaptation.
    case passed
    /// Modification adapted to change.
    case adapted
    /// Modification has canceled by change during adaptation.
    case canceled
    /// Modification can't be adapted to change.
    case invalid
}

/// Requitements to tool, that adapts requests Batches to changes.
///
/// In extension contains default implementation based on `strategies` property.
///
/// Requires some `SSDataModifying` as change and some `SSDataModifying` as request.
public protocol SSDmBatchAdapting {
    /// Adapting Revision's change Type
    associatedtype Change : SSDataModifying
    /// Adapting Batch's request Type
    associatedtype Request : SSDataModifying
    
    /// Adapting Batch Type
    typealias Batch = SSDmBatch<Request>
    /// Adapting Revision Type
    typealias Revision = SSDmRevision<Change>
    /// Adapting Strategy Type
    typealias Strategy = (Change, Request) -> SSDmToChangeAdaptResult
    /// Adapting Strategies Type
    typealias Strategies = [String : Strategy]
    
    /// Adaptation strategies
    var strategies: Strategies { get }
    
    /// Adapts passed batch by passed revision.
    /// - Parameters:
    ///   - batch: Batch to adpat.
    ///   - revision: Revision to adpat by.
    /// - Returns: Adaptation error if occur. (See `SSDmBatchAdaptError` for more info).
    ///
    /// # Default Implementation
    /// See `adaptBatch(_ batch: Batch, by revisions: [Revision]) -> SSDmBatchAdaptError?`
    func adaptBatch(_ batch: Batch, by revision: Revision) -> SSDmBatchAdaptError?
    
    /// Adapts passed batch by passed revisions sequence.
    /// - Parameters:
    ///   - batch: Batch to adpat.
    ///   - revisions: revisions sequence to adpat by.
    /// - Returns: Adaptation error if occur. (See `SSDmBatchAdaptError` for more info).///
    /// # Default Implementation
    /// For each revision and for each reviosion's change picks adaptaion strategy and applies to each request of Batch.
    /// Removes Request from Batch if adaptation result is `canceled`. Stops and throws `SSDmBatchAdaptError.cantAdapt` if adaptation result is `invalid`.
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

/// Class-helper that simplyfies adaptation strategies creating. See `SSUEBatchAdpater` for example.
///
/// Requires some `SSDataModifying` as Chnage and some `SSDataModifying` as Request.
public class SSDMAdaptStrategyBuilder<Change: SSDataModifying, Request: SSDataModifying> {
    /// Result adaptaion Strategy Type
    typealias Strategy = (Change, Request) -> SSDmToChangeAdaptResult
    /// Build Result Type – pair of title and strategy
    typealias Result = (title: String, adapt: Strategy)
    
    /// Class-helper/holder. Stores (as generic) Type of adapting items.
    class Adapting<Adapting> {
        /// Class-helper/holder. Stores (as generic) Type of items to adapts by.
        class To<ToChange: SSDmChange> {
            /// Creates adaptaion strategy using passed block for types defined by Generics. Strategy will return `passed` for all requests that can't by casted to `Adapting` Type.
            /// - Parameters:
            ///   - block: Block describes how to adapt modify of `Adapting` Type to modify of `ToChange` type.
            ///   - adapting: Block args. Modification to adapt.
            ///   - change: Block args. Modification to adapt by
            /// - Returns: Building result (title and strategy pair, see `Result`) with change's title as `title`.
            class func strategy(with block: @escaping (_ adapting: Adapting, _ change: ToChange) -> SSDmToChangeAdaptResult) -> Result {
                return AdaptingTo<Adapting, ToChange>.strategy(with: block)
            }
        }
    }
    
    /// Class-helper/holder. Stores (as generics) Type of adapting items and Type of items to adapts by.
    class AdaptingTo<Adapting, ToChange: SSDmChange> {
        /// Creates adaptaion strategy using passed block for types defined by Generics. Strategy will return `passed` for all requests that can't by casted to `Adapting` Type.
        /// - Parameters:
        ///   - block: Block describes how to adapt modify of `Adapting` Type to modify of `ToChange` type.
        ///   - adapting: Block args. Modification to adapt.
        ///   - change: Block args. Modification to adapt by.
        /// - Returns: Building result (title and strategy pair, see `Result`) with change's title as `title`.
        class func strategy(with block: @escaping (_ adapting: Adapting, _ change: ToChange) -> SSDmToChangeAdaptResult) -> Result {
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
