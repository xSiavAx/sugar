import Foundation

public protocol AsyncTaskRunner {}

extension AsyncTaskRunner {
    public func runTask(_ task: @escaping () async -> Void) {
        Task {
            await task()
        }
    }
}
