import Foundation

/// Base class for any Entity Mutator that works with storage. Storage – any place with low latency and synchronious interface (SharedPreferences, DataBase etc). Mutator will switch queue on it's own.
/// - Note:
/// It's inheritors responsobility to provide storage modification logic and notification creating. See examples for more info.
open class SSEntityDBMutator<Source: SSMutatingEntitySource> {
    public private(set) weak var source: Source?
    /// Executor for tasks that work with storage.
    public let executor: SSExecutor
    /// Notifier for modification notification sending
    public let notifier: SSUpdateNotifier

    public init(executor mExecutor: SSExecutor, notifier mNotifier: SSUpdateNotifier) {
        executor = mExecutor
        notifier = mNotifier
    }
    
    /// Protected method for mutating entity.
    /// - Important: By design this method should be used only withing inheritors.
    /// - Parameters:
    ///   - job: Closure that describe which changes should be applyed to storage
    ///   - marker: Marker for notification.
    ///   - handler: Finish handler runned on main thread.
    ///   - error: Error that amy occurs during mutating.
    public func mutate(job: @escaping (_ marker: String) throws ->SSUpdate, handler: @escaping (_ error: Error?)->Void) {
        let marker = Self.newMarker()

        func work() {
            let error = execute(job: job, marker: marker)
            
            onMain { handler(error) }
        }
        executor.execute(work)
    }
    
    private func execute(job: (_ marker: String) throws ->SSUpdate, marker: String) -> Error? {
        do {
            let update = try job(marker)
            notifier.notify(update: update)
        } catch {
            return error
        }
        return nil
    }
}

extension SSEntityDBMutator: SSBaseEntityMutating {
    #warning("TODO: Add started/stopped logic?")
    public func start(source mSource: Source) {
        source = mSource
    }
    
    public func stop() {}
}

