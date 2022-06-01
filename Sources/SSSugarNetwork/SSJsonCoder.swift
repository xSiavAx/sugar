import Foundation
import SSSugarCore

/// Json converter. Conforms to `ApiArgsConverting`.
///
/// Uses `JSONSerialization` for implementation.
///
public class SSJsonCoder: SSApiArgsConverting {
    public let contentType = SSApiContentType.json
    
    /// Json wrtiting oprions
    public static let defWritingOptions: JSONSerialization.WritingOptions = [.prettyPrinted] //Add .prettyPrinted here for debug purposes
    
    private var writingOptions: JSONSerialization.WritingOptions
    
    
    public init(writingOptions options: JSONSerialization.WritingOptions = defWritingOptions) {
        writingOptions = options
    }
    
    /// Json args converter errors
    public enum IError: Error {
        /// Invalid json
        case invalidFormat(Error)
    }
    
    /// Converts passed JSON arguments to data
    /// - Parameter args: JSON arguments to convert
    /// - Returns: converted data.
    /// - Throws: JSON serialization errors.
    public func data(from args: Args) throws -> Data {
        return try! JSONSerialization.data(withJSONObject: args, options: writingOptions) //NSINvalidArguments couldn't be caught
    }
    
    /// Converts passed data to JSON arguments.
    /// - Parameter data: data to convert
    /// - Returns: Converted arguments.
    /// - Throws: JSON serialization errors.
    public func args(from data: Data?) throws -> Args {
        do {
            if let mData = data {
                if let args = try JSONSerialization.jsonObject(with: mData) as? [String : Any] {
                    return args
                }
            }
            return [:]
        } catch {
            throw IError.invalidFormat(error)
        }
    }
}
