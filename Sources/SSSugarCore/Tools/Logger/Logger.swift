import Foundation

public enum Verbosity: String {
    case debug
    case info
    case warning
    case error
    case critical
    case silent
}

public protocol Logger {
    func log(message: String, verbosity: Verbosity)
}

public extension Logger {
    func log(message: String) {
        log(message: message, verbosity: .debug)
    }
}
