import Foundation
import SSSugarCore

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
