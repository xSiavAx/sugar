import Foundation

public class SSDmBatch<Request : SSDataModifying>: SSCopying {
    public private(set) var requests: [Request]
    
    public init(requests mRequests: [Request]) {
        requests = mRequests
    }
    
    public required convenience init(copy other: SSDmBatch) {
        self.init(requests: other.requests.map { $0.copy() })
    }
    
    public func filterRequests(using block: (Request) throws -> Bool) rethrows {
        try requests = requests.filter(block)
    }
}
