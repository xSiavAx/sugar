import Foundation

/// Content type predefined constants.
///
/// Now only `json` content type is defined, but there may appear new one in future.
///
public enum SSApiContentType: String {
    case json = "application/json"
    case js = "application/javascript"
    case ogg = "application/ogg"
    case pdf = "application/pdf"
    case zip = "application/zip"
    case gzip = "application/gzip"
    case xml = "application/xml"
    
    case gif = "image/gif"
    case jpeg = "image/jpeg"
    case pjpeg = "image/pjpeg"
    case png = "image/png"
    case tiff = "image/tiff"
    case webp = "image/webp"
    
    case cmd = "text/cmd"
    case css = "text/css"
    case csv = "text/csv"
    case html = "text/html"
    case textJS = "text/javascript"
    case plain = "text/plain"
    case php = "text/php"
    case textXml = "text/xml"
    
    case form = "application/x-www-form-urlencoded"
}

/// Requierements for tool that converting Api arguments and Communicator data.
public protocol SSApiArgsConverting {
    /// Remote Api Args shortcut
    typealias Args = SSRemoteApiModel.Args
    
    /// Content type of arguments sent to server
    var contentType: SSApiContentType { get }
    
    /// Converts passed arguments to data
    /// - Parameter args: arguments to convert
    /// - Returns: converted data.
    func data(from args: [String : Any]) throws -> Data
    
    /// Converts passed data to arguments.
    /// - Parameter data: data to convert
    /// - Returns: Converted arguments.
    /// - Throws: Implementation related errors.
    func args(from data: Data?) throws -> Args
}
