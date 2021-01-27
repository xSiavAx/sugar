import Foundation

/// Tool helps create Api Error Adapters (with some `Common` and `Spiceific`) for corresponding `KeyStoring` field.
///
/// Contains simplified methods for cases when one of error components confoms `ApiErrorCause`, see `parser(buildSpecific:)`, `parser(buildCommon:)`. When both components conform to `ApiErrorCause` use corresponding `SSErrorConverter` extension (`readAdapter()`)
public class SSApiErrorConverter<CommonError: Error, SpecificError: Error> {
    /// Api Error type shortcut
    typealias IApiError = SSApiError<CommonError, SpecificError>
    /// `SSKeyField<ApiError> Adapter` type shortcut
    typealias Adapter = SSKeyField<IApiError?>.Adapter
    /// Build error commponent Closure type
    /// - Parameters:
    ///   - input: Value parsed form storage and converted to String
    ///   - storage: Storage to create error based on data from.
    typealias BuildErrorComponent<T> = (_ input: String, _ storage: SSKeyFieldStorage)->T?
    /// Build Common error commponent Closure type
    typealias BuildCommon = BuildErrorComponent<CommonError>
    /// Build Specific error commponent Closure type
    typealias BuildSpecific = BuildErrorComponent<SpecificError>
    
    /// Creates read closure that creates api error, that may be used to initialize `SSKeyField<iApiError>.Adapter`.
    /// - Parameters:
    ///   - buildCommon: Closure that builds `Common` error components (if possible)
    ///   - buildSpecific: Closure that builds `Specific` error components (if possible)
    /// - Returns: Read closure.
    static func onRead(buildCommon: @escaping BuildCommon, buildSpecific: @escaping BuildSpecific) -> Adapter.Read {
        func onRead(storage: SSKeyFieldStorage, key: String, parsed: Any?) -> IApiError? {
            func onCommon(input: String) -> CommonError? {
                return buildCommon(input, storage)
            }
            func onSpecific(input: String) -> SpecificError? {
                return buildSpecific(input, storage)
            }
            return SSErrorConverter<IApiError>.stringToError(input: parsed) {
                return IApiError.from(string: $0, onCommon: onCommon, onSpecific: onSpecific)
            }
        }
        return onRead(storage:key:parsed:)
    }
    
    /// Creates read-only `Adapter` for `SSKeyField<ApiError<CommonError, SpecificError>>`, that returns `nil` on input is `nil`.
    /// - Parameters:
    ///   - buildCommon: Closure that builds `Common` error components (if possible)
    ///   - buildSpecific: Closure that builds `Specific` error components (if possible)
    /// - Returns: Created adapter.
    static func parser(buildCommon: @escaping BuildCommon, buildSpecific: @escaping BuildSpecific) -> Adapter {
        return Adapter(onRead: onRead(buildCommon: buildCommon, buildSpecific: buildSpecific))
    }
}

extension SSApiErrorConverter where CommonError: SSStringRepresentableApiErrorComponent {
    /// Creates read-only `Adapter` for `SSKeyField<ApiError<CommonError, SpecificError>>`, that returns `nil` on input is `nil`.
    ///
    /// - Parameters:
    ///   - buildSpecific: Closure that builds `Specific` error components (if possible)
    /// - Returns: Created adapter.
    ///
    /// Use `ApiErrorCause.from(string:)` to build `Common` error
    static func parser(buildSpecific: @escaping BuildSpecific) -> Adapter {
        return parser(buildCommon: buildCommon, buildSpecific: buildSpecific)
    }
    
    private static func buildCommon(input: String, storage: SSKeyFieldStorage) -> CommonError? {
        return CommonError(rawValue: input)
    }
}

extension SSApiErrorConverter where SpecificError: SSStringRepresentableApiErrorComponent {
    /// Creates read-only `Adapter` for `SSKeyField<ApiError<CommonError, SpecificError>>`, that returns `nil` on input is `nil`.
    /// - Parameters:
    ///   - buildCommon: Closure that builds `Common` error components (if possible)
    /// - Returns: Created adapter.
    ///
    /// Use `ApiErrorCause.from(string:)` to build `Specific` error
    static func parser(buildCommon: @escaping BuildCommon) -> Adapter {
        return parser(buildCommon: buildCommon, buildSpecific: buildSpecific)
    }
    
    private static func buildSpecific(input: String, storage: SSKeyFieldStorage) -> SpecificError? {
        return SpecificError(rawValue: input)
    }
}
