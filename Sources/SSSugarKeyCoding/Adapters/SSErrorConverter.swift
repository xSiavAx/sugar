import Foundation
import SSSugarCore

/// Tool-helpers simplify converting string to some Error.
///
/// Contains logic of creating some `Error` from `Any` input based on closure with `String` input (see `stringToError(input:build:)`.
///
/// Contains logic of creating `Adapter` for corresponding `KeyField` for converting `String` to some `Error`, with build closure and without it for `ApiErrorCreatable` errors, see `parser(build:)` and `parser()` methods.
///
public class SSErrorConverter<ErrorT: Error> {
    /// Creates error (`ErrorT`) based on input. Returns `nil` on imput is `nil`.
    /// - Parameters:
    ///   - build: Closure describes how to build `ErrorT` from `String`.
    ///   - string: `String` representation of `input`.
    /// - Returns: Error created via `build` closure or `nil`.
    /// - Important: Causes fatal error on input arguments has other type then `String`
    public static func stringToError(input: Any?, build: @escaping (_ string: String)->ErrorT?) -> ErrorT? {
        guard input != nil else { return nil }
        guard let error = input as? String else {
            return build("unexpected_error_type")
        }
        return build(error)
    }
    
    /// Creates read-only `Adapter` for `KeyField<ErrorT>`, thats returns `nil` on input is `nil`.
    /// - Parameters:
    ///   - build: Closure describes how to build `ErrorT` from `String`.
    ///   - string: `String` representation of `Adapter`'s `parsed` argument.
    /// - Returns: Created `Adapter`.
    /// - Important: Adapter's read causes fatal error on input arguments has other type then `String`
    public static func parser(build: @escaping (_ string: String)->ErrorT?) -> SSKeyField<ErrorT?>.Adapter {
        return SSKeyField<ErrorT?>.Adapter(onRead: {(storage, key, parsed) in
                                            stringToError(input: parsed, build: build)
        })
    }
}

extension SSErrorConverter where ErrorT: SSStringRepresentableError {
    /// Creates read-only `Adapter` for `KeyField<ErrorT>`, thats returns `nil` on input is `nil`.
    ///
    /// - Returns: Created `Adapter`.
    /// - Important: Adapter's read causes fatal error on input arguments has other type then `String`
    /// - Note: This method available only for `ApiErrorCreatable` erros. For other types see `readAdapter(build:)`
    ///
    /// `ApiErrorCreatable.from(string:)` is used as building closure.
    public static func parser() -> SSKeyField<ErrorT?>.Adapter {
        return parser() { ErrorT.from(string: $0) }
    }
}
