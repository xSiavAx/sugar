import Foundation
#if os(Linux)
import FoundationNetworking
#endif

/// Class incapsulate certificate pinning logic.
/// Use it as URLSession delegate.
/// Object use certificates list passed to constructor (or list that return obtainer) to check server certificates corespond to one of them.
/// Fill free to inherit this class.
/// - Important: It's not possible to implements pinning as protocol extension or proxy due to optional attribute of protocol methods.
public class SSCertificatePinner: NSObject {
    /// Allowed certificates list
    private(set) var certificates : [SecCertificate]
    /// Certificates missmatch handler.
    public var onReject: (() -> Void)?
    
    public override init() {
        fatalError("Use init(certificates: [SecCertificate])")
    }
    
    /// Creates new pinner
    ///
    /// - Parameters:
    ///   - certificates: Allowed certificates list
    public init(certificates mCertificates: [SecCertificate]) {
        certificates = mCertificates
        super.init()
    }
    
    /// Creates new pinner
    ///
    /// - Parameters:
    ///   - obtainer: Obtainer that will provide list allowed certificates list
    convenience public init(obtainer: SSCertificatesObtainer) {
        self.init(certificates: obtainer.certificates())
    }
}

extension SSCertificatePinner: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let isServerAuthentication = challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
        
        if (isServerAuthentication && !certificatesValid(challenge: challenge)) {
            onReject?()
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
    
    //MARK: - private
    
    private func certificatesValid(challenge: URLAuthenticationChallenge) -> Bool {
        if let trust = challenge.protectionSpace.serverTrust {
            for index in 0..<SecTrustGetCertificateCount(trust) {
                if let certificate = SecTrustGetCertificateAtIndex(trust, index) {
                    if (certificates.contains(certificate)) {
                        return true
                    }
                }
            }
        }
        return false
    }
}
