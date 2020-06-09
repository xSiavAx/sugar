import Foundation

/// Base class for any Entity Mutator that works with storage. Storage – any place with low latency and synchronious interface (SharedPreferences, DataBase etc). Mutator will switch queue on it's own.
/// - Note:
/// It's inheritors responsobility to provide storage modification logic and notification creating. See examples for more info.
open class SSEntityDBMutator<Source: SSMutatingEntitySource> {
    /// Modifying entity source
    public private(set) weak var source: Source?
    /// Executor for tasks that work with storage.
    public let executor: SSExecutor
    /// Notifier for modification notification sending
    public let notifier: SSUpdateNotifier

    public init(executor mExecutor: SSExecutor, notifier mNotifier: SSUpdateNotifier, source mSource: Source) {
        executor = mExecutor
        notifier = mNotifier
        source = mSource
    }
    
    /// Protected method for mutating entity.
    /// - Important: By design this method should be used only withing inheritors.
    /// - Parameters:
    ///   - job: Closure that describe which changes should be applyed to storage
    ///   - marker: Marker for notification.
    ///   - handler: Finish handler runned on main thread.
    ///   - error: Error that amy occurs during mutating.
    public func mutate(job: @escaping (_ marker: String) throws -> SSUpdate, handler: @escaping (_ error: Error?)->Void) {
        let marker = Self.newMarker()

        func work() {
            do {
                let update = try job(marker)
                
                notifier.notify(update: update) { handler(nil) }
            } catch {
                onMain { handler(error) }
            }
        }
        executor.execute(work)
    }
}

extension SSEntityDBMutator: SSBaseEntityMutating {
    #warning("TODO: Add started/stopped logic?")
    public func start() {}
    
    public func stop() {}
}
