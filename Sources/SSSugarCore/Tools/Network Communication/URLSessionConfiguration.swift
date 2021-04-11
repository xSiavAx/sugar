import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSessionConfiguration {
    /// Session configuratuon to use within the app.
    ///
    /// Based on `ephemeral` session configuration that doesn't leave traces (doesn't stores cache etc.). Extended by adding app specific `User-Agent` value to headers of requests.
    /// - Returns: Common session Configuration.
    static func appDefault() -> URLSessionConfiguration {
        return URLSessionConfiguration.ephemeral
    }
    
    #if !os(Linux)
    /// Session configuratuon to use within the app for requests prefroms in background.
    ///
    /// Based on `background` session configuration that doesn't cancel request on app go to background and allows run start app (in background mode) on response arrives. Extended by adding app specific `User-Agent` value to headers of requests.
    /// - Returns: Background session Configuration.
    static func appBackground(withIdentifier: String) -> URLSessionConfiguration {
        let config = URLSessionConfiguration.background(withIdentifier: withIdentifier)
        
        config.shouldUseExtendedBackgroundIdleMode = true
        config.sessionSendsLaunchEvents = true
        
        return config
    }
    #endif
}
