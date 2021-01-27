import Foundation

/// Options that stores api call parameters usually specified for server (like base url and headers).
public struct SSApiCallOptions {
    public var baseURL: URL
    public var headers: [String : String]
    public var argsConverter: SSApiArgsConverting
    
    /// Content type of arguments sent to server
    public var contentType: SSApiContentType { argsConverter.contentType }
    
    /// Checks args not nil and proxies call to converter
    /// - Parameter args: Arguments to convert
    /// - Throws: Errors from converter
    /// - Returns: Result of converting args if it isn't nil or nil otherwise
    public func bodyFromArgs(_ args: [String : Any]?) throws -> Data? {
        if let mArgs = args {
            return try argsConverter.data(from: mArgs)
        }
        return nil
    }
    
    /// Tries convert passed data to arguments or return nil otherwise.
    /// - Parameter data: Data to convert.
    /// - Returns: Arguments if converting was successful.
    public func tryParseArgs(_ data: Data?) -> [String : Any]? {
        return try? argsConverter.args(from: data)
    }
}
