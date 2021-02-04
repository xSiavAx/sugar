import Foundation

/// Methods providing version and build number
///
/// `Bundle` confroms to this protocol.
public protocol SSAppVersioning {
    var releaseVersion: String? {get}
    var buildVersion: String? {get}
}

extension Bundle: SSAppVersioning {
    /// App version
    public var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// Build number
    public var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

