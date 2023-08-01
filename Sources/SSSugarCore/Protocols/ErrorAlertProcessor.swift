import Foundation

public struct ErrorAlertContext: Identifiable {
    public let id = UUID()

    public var title = "Error"
    public var details: String

    public var retryAction: (() -> Void)?

    public init(
        title: String = "Error",
        details: String,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.details = details
        self.retryAction = retryAction
    }
}

public protocol ErrorAlertProcessor: AnyObject {
    var errorAlert: ErrorAlertContext? { get set }
}

extension ErrorAlertProcessor {
    @MainActor
    public func processAlert(error: Error, retry: @escaping () -> Void) {
        errorAlert = .init(details: "\(error)", retryAction: retry)
    }
}
