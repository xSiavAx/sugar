import Foundation

/// Requirements for entity source for SSEntityMutator
public protocol SSEntityMutatorSource: AnyObject {
    associatedtype Entity
    
    func entity<Mutating: SSEntityMutating>(for mutator: Mutating) -> Entity?
}

/// Addon for Entity Mutator. `newMarker()` has default implementation.
public protocol SSEntityMutating {
    static func newMarker() -> String
}

extension SSEntityMutating {
    public static func newMarker() -> String { return UUID().uuidString }
}

/// Requirements for Entity Mutator with some addons (like marker generating or dispatching on main queue)
protocol SSBaseEntityMutating: SSEntityMutating, SSOnMainExecutor {
    associatedtype Source: SSEntityMutatorSource
    typealias Entity = Source.Entity
    
    /// Object that give's (and potentially own) entity object to mutate.
    var source: Source {get}
}

//MARK: - Storage Mutator

/// Base class for any Entity Mutator that works with storage. Storage – any place with low latency and synchronious interface (SharedPreferences, DataBase etc). Mutator will switch queue on it's own.
/// - Note:
/// It's inheritors responsobility to provide storage modification logic and notification creating. See examples for more info.
open class SSEntityDBMutator<Source: SSEntityMutatorSource>: SSBaseEntityMutating {
    public unowned let source: Source
    /// Executor for tasks that work with storage.
    public let executor: SSExecutor
    /// Notifier for modification notification sending
    public let notifier: SSUpdateNotifier

    public init(source mSource: Source, executor mExecutor: SSExecutor, notifier mNotifier: SSUpdateNotifier) {
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
    public func mutate(job: @escaping (_ marker: String) throws ->SSUpdate, handler: @escaping (_ error: Error?)->Void) {
        let marker = Self.newMarker()

        func work() {
            var mError: Error?

            do {
                let update = try job(marker)
                notifier.notify(info: update)
            } catch {
                mError = error
            }
            onMain { handler(mError) }
        }
        executor.execute(work)
    }
}

//MARK: - Remote Mutator

/// Base class for any Entity Mutator that works with Remote Storage. Remote storage – any place with hight latency and asynchronious interface and splited communication. (Back-end server, cloud etc.). Splitted communications means that async modfication is only intent (not an real modification) and system should wait on notification that arrives via 'SSUpdateReceiversManaging' to ensure modification is applied. Mutator will match notification on modifiation by marker and will call it's handler.
/// - Note:
/// It's inheritors responsobility to provide storage modification logic (usually it's api calls). Also inheritor must implements it's notifications handling by simply calling `handleUpdate(marker:error:)` method. See examples for more info.
open class EntityRemoteMutator<Source: SSEntityMutatorSource>: SSBaseEntityMutating {
    /// Type for handler closure
    public typealias Handler = (Error?)->Void
    /// Protected type for job closure (modification behaviour). See `mutate(job:handler:)`. Should be used only within inheritors.
    public typealias AsyncJob = (String, Handler)->Void
    
    public unowned let source: Source
    
    /// Manager to subscibe on notifications for mathing them with modifications.
    public let manager: SSUpdateReceiversManaging
    
    /// Finish handlers stored by markers.
    private var handlers = [String : (Error?) -> Void]()
    
    /// Creates new Remote Mutator instance. Should be used only within inheritor.
    /// - Parameters:
    ///   - source: Entity source. See coresponding property.
    ///   - manager: Updates receiver manager. See coresponding property.
    public init(source mSource: Source, manager mManager: SSUpdateReceiversManaging) {
        manager = mManager
        source = mSource
        manager.addReceiver(self)
    }

    deinit {
        manager.removeReceiver(self)
    }
    
    /// Protected method for mutating entity.
    /// - Important: By design this method should be used only withing inheritors.
    /// - Parameters:
    ///   - job: Closure that modifyes storage. Usually its Api call.
    ///   - handler: Finish handler.
    public func mutate(job: @escaping AsyncJob, handler: @escaping Handler) {
        let marker = Self.newMarker()

        func onBg() {
            store(handler: handler, marker: marker)
            job(marker, remoteHandler(with: marker))
        }
        DispatchQueue.bg.async(execute: onBg)
    }
    
    /// Protected method for handling notifications. Should be used only whithing inheritors in every SSUpdatesReceiver's method.
    /// - Parameters:
    ///   - marker: Notification marker.
    ///   - error: Error.
    public func handleUpdate(with marker: String, error: Error? = nil ) {
        handlers.pick(for: marker)?(nil)
    }
    
    /// Store passed finish handler for matching in future.
    /// - Parameters:
    ///   - handler: Closure to store
    ///   - marker: Modification marker which identify notification for handler matching.
    private func store(handler: @escaping (Error?) -> Void, marker: String) {
        handlers[marker] = handler
    }
    
    /// Creates handler that will call stored handler for passed marker in case of error occurs.
    /// - Parameter marker: marker for handler matching.
    private func remoteHandler(with marker: String) -> Handler {
        return {[weak self](error) in
            if let mError = error {
                DispatchQueue.bg.async {[weak self] in
                    self?.handleUpdate(with: marker, error: mError)
                }
            }
        }
    }
}

extension EntityRemoteMutator: SSUpdateReceiver {
    public func reactions() -> SSUpdate.ReactionMap { return [:] }
}
