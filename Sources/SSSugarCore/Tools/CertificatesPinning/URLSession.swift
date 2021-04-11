import Foundation
#if os(Linux)
import FoundationNetworking
#endif

extension URLSession {
    public convenience init(configuration: URLSessionConfiguration = URLSessionConfiguration.default, pinner: SSCertificatePinner, delegateQueue: OperationQueue? = nil) {
        self.init(configuration: configuration, delegate: pinner, delegateQueue: delegateQueue)
    }
}
