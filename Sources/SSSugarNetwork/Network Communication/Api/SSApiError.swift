import Foundation
import SSSugarCore

/// Requirements for ApiError component that may be represented as string. Uses to simplify and unify creating ApiError code (see `SSApiErrorConverter`, `MailApiErrorReader`...).
public protocol SSStringRepresentableApiErrorComponent: Error, RawRepresentable where RawValue == String {}

/// Errors may occur during performing Api calls.
///
/// # Generics:
/// * `Common` – type of error common for some calls set (usually grouped by server). Should conforms to `ApiCommonError`.
/// * `Specific` – type of error specific for concreate call.
///
/// # Conforms:
/// * `SSStringRepresentableError` on components conform to `StringRepresentableApiErrorComponent`.
///
public enum SSApiError<Common: Error, Specific: Error>: Error {
    /// Call error caused by Communication error or unexpected data. See `ApiCallError` form more info.
    case call(cause: ApiCallError)
    /// Calls set common error parsed from args
    case common(cause: Common)
    /// Call specific error parsed from args
    case specific(cause: Specific)
    
    /// Creates `ApiError` based on parsed from args error string value using passed closures.
    ///
    /// - Important: Never creates `.call` errors. Method should to create ApiError when `.call` cases has checked and has parsed from args error string val.
    ///
    /// - Parameters:
    ///   - string: Error string value parsed from arguments.
    ///   - onCommon: Closure that builds common error component based on parsed from args error string value if it matches one.
    ///   - onSpecific: Closure that builds call specific error component based on parsed from args error string value if it matches one.
    /// - Returns: `.common` if `onCommon` returns `non-nil`, `.specific` if `onSpecific` returns `non-nil` or `nil` if both closures return `nil`.
    public static func from(
        string: String,
        onCommon: (_ string: String) -> Common?,
        onSpecific: (_ string: String) -> Specific?
    ) -> SSApiError? {
        if let cause = onCommon(string) {
            return .common(cause: cause)
        }
        if let cause = onSpecific(string) {
            return .specific(cause: cause)
        }
        return nil
    }
}

extension SSApiError: SSStringRepresentableError where Common: SSStringRepresentableApiErrorComponent, Specific: SSStringRepresentableApiErrorComponent {
    public static func from(string: String) -> SSApiError? {
        return from(string: string, onCommon: Common.init(rawValue:), onSpecific: Specific.init(rawValue:))
    }
}

/// Api Error call component – errors may occur during Api calls preforming.
public enum ApiCallError: Error {
    /// No network connection
    case noConnection
    /// Server returns unexpected certificates
    case badCertificates
    /// Error caused by Underlied Library error
    case libError(libError: Error?)
    /// Error caused by some unxpected response data – on no error parsed from args and unexpected status, on exceptions during converting data to args, etc.
    case unexpected(data: Data?, args: [String : Any]?, commError: Error?)
}
