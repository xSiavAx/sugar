import Foundation

/// Methods providing version and build number
///
/// `Bundle` confroms to this protocol.
public protocol AppVersioning {
    var releaseVersion: String? {get}
    var buildVersion: String? {get}
}

extension Bundle: AppVersioning {
    public var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

