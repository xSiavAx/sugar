import Foundation

public enum NetworkApplicationError: Error {
    case transportFailure(URLError)
    case http(statusCode: Int, data: Any?)
}
