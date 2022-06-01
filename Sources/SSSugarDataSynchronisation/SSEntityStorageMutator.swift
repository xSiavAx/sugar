import Foundation
import SSSugarExecutors

public protocol SSEntityDBMutatorMarkerGenerator: AnyObject {
    func newMarker() -> String
}

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
    /// Marker generator
    ///
    /// Generally for Test purpouses. If nill, self.newMarker() will be used instead (default behaviour).
    public weak var markerGenerator: SSEntityDBMutatorMarkerGenerator?

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
    ///   - handler: Finish handler runs on main thread.
    ///   - error: Error that amy occurs during mutating.
    public func mutate(job: @escaping (_ marker: String) throws -> SSUpdate?, handler: @escaping (_ error: Error?)->Void) {
        let marker = createMarker()
        
        executor.execute() {[weak self] in
            self?.bgMutate(marker: marker, job: job, handler: handler)
        }
    }
    
    private func bgMutate(marker: String, job: @escaping (_ marker: String) throws -> SSUpdate?, handler: @escaping (_ error: Error?)->Void) {
        do {
            if let update = try job(marker) {
                notifier.notify(update: update) { handler(nil) }
            }
        } catch {
            onMain { handler(error) }
        }
    }
    
    private func createMarker() -> String {
        return markerGenerator?.newMarker() ?? Self.newMarker()
    }
}

extension SSEntityDBMutator: SSBaseEntityMutating {
    #warning("TODO: Add started/stopped logic (like in Remote)?")
    public func start() {}
    
    public func stop() {}
}
