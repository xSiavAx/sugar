import Foundation

/// Dummy logger which main purpose is making code compilable.
public final class CommandLineLogger: Logger {
    public init() {}
    
    public func log(message: String, verbosity: Verbosity) {
        print(verbosity.rawValue.uppercased() + ": " + message)
    }
}
