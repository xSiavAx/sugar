import Foundation

/// Represents seria of requests. Implements SSCopying.
///
/// Requires some SSDataModifying as Request.
public class SSDmBatch<Request : SSDataModifying>: SSCopying {
    /// Batch'es requests seria
    public private(set) var requests: [Request]
    
    /// Creates new Batch with passed requests
    /// - Parameter requests: Requests to create Batch with.
    public init(requests mRequests: [Request]) {
        requests = mRequests
    }
    
    /// Creates new Batch based on passed one.
    /// - Parameter other: Batch to create new one with.
    public required convenience init(copy other: SSDmBatch) {
        self.init(requests: other.requests.map { $0.copy() })
    }
    
    //MARK: - public
    
    /// Filters requests seria – leaving requests that satisfy given block.
    /// - Parameter block: Predicates to filter requests with.
    /// - Throws: Rethrows block exceptions.
    public func filterRequests(using block: (Request) throws -> Bool) rethrows {
        try requests = requests.filter(block)
    }
}
