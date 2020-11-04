import Foundation

/// Requirements for error taht may be created from `String`. Uses to simplify and unify error creating. See `ErrorConverter`.
public protocol SSStringRepresentableError: Error {
    /// Creates error based on passed string.
    /// - Parameter string: String value to build error based on.
    static func from(string: String) -> Self?
}
