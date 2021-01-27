import Foundation

/// Stub for Api error where specific doesn't exist
///
/// # Conforms to:
/// `StringRepresentableApiErrorComponent`
public enum SSApiNoError: Error, StringRepresentableApiErrorComponent {
    public var rawValue: String { "" }

    public init?(rawValue: String) {
        return nil
    }
}
