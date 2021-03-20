import Foundation

/// Requirements to object that able to obtain certificates
public protocol SSCertificatesObtainer {
    /// Generate certificates list.
    ///
    /// - Returns: Certificates list
    func certificates() -> [SecCertificate]
}

/// Certificate Obtainer implementation for certificates stored in Assets.
/// Pass certificate titles to constructor.
/// Certificates in Assets have to has 'der' extension
/// - Note: You may convert 'pem' to 'der' using next command:
/// `````
/// openssl x509 -outform der -in certificate.pem -out certificate.der
/// `````
public class SSAssetCertificateObtainer: SSCertificatesObtainer {
    /// Default certificate extension
    static private let certExtension = "der"
    /// Certificate titles
    private let allowedCertifcates : [String]
    
    /// Create new obtainer instance
    ///
    /// - Parameter certTitles: Certificates title list without extension to find in Assets
    public init(certTitles: [String]) {
        allowedCertifcates = certTitles
    }
    
    public func certificates() -> [SecCertificate] {
        return allowedCertifcates.compactMap {
            if let filePath = Bundle.main.path(forResource: $0, ofType:SSAssetCertificateObtainer.certExtension) {
                let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
                
                return SecCertificateCreateWithData(nil, data as CFData)!
            }
            return nil
        }
    }
}
