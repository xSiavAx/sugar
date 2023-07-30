import Foundation
import SSSugarExecutors

public protocol ErrorAlertProcessor: AnyObject {
    var errorAlert: ErrorAlertContext? { get set }
}

extension ErrorAlertProcessor {
    @MainActor
    public func processAlert(error: Error, retry: @escaping () -> Void) {
        errorAlert = .init(details: "\(error)", retryAction: retry)
    }
}

extension AsyncTaskRunner where Self: ErrorAlertProcessor {
    public func runTask(_ task: @escaping () async throws -> Void) {
        Task { [weak self] in
            do {
                try await task()
            } catch {
                await self?.processAlert(error: error) {
                    self?.runTask(task)
                }
            }
        }
    }
}
