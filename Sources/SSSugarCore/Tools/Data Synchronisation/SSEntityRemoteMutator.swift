import Foundation

/// Errors may occur during Remoute mutator usage
///
/// * `notStarted` - Mutator not started and can't mutate entity.
enum SSEntityRemoteMutatorError: Error {
    /// Mutator not started and can't mutate entity.
    case notStarted
}

/// Base class for any Entity Mutator that works with Remote Storage. Remote storage – any place with hight latency and asynchronious interface and splited communication. (Back-end server, cloud etc.). Splitted communications means that async modfication is only intent (not an real modification) and system should wait on notification that arrives via 'SSUpdateReceiversManaging' to ensure modification is applied. Mutator will match notification on modifiation by marker and will call it's handler.
/// - Note:
/// It's inheritors responsobility to provide storage modification logic (usually it's api calls). Also inheritor must implements notifications handling, usually it's just calling `handleUpdate(marker:error:)` method. See examples for more info.
/// - Important: Remote mutator count on some `Updater` working on `DispatchQueue.bg` queue. Methods works with `handlers` property may cause racecondition otherwise, cuz `mutate` dispatches to `DispatchQueue.bg` on it's own  and `handleUpdate` usually calls from reaction on update.
open class SSEntityRemoteMutator<Source: SSMutatingEntitySource>: SSUpdateReceiver {
    /// Type for handler closure
    public typealias Handler = (Error?)->Void
    /// Protected type for job closure (modification behaviour). See `mutate(job:handler:)`. Should be used only within inheritors.
    public typealias AsyncJob = (String, @escaping Handler)->Void
    
    public weak var source: Source?
    
    /// Manager to subscibe on notifications for matching them with modifications.
    public let manager: SSUpdateReceiversManaging
    
    /// Finish handlers stored by markers.
    private var handlers = [String : (Error?) -> Void]()
    
    
    public var handlersToApply = [(handler:Handler, error: Error?)]()
    
    private var started = false
    
    /// Creates new Remote Mutator instance. Should be used only within inheritor.
    /// - Parameters:
    ///   - manager: Updates receiver manager. See coresponding property.
    public init(manager mManager: SSUpdateReceiversManaging, source mSource: Source) {
        manager = mManager
        source = mSource
    }

    deinit {
        stop()
    }
    
    //MARK: SSUpdateReceiver
    
    public func reactions() -> SSUpdate.ReactionMap { return [:] }
    
    public func apply() {
        for holder in handlersToApply {
            holder.handler(holder.error)
        }
        handlersToApply.removeAll()
    }
    
    /// Mark: protected
    
    /// Protected method for mutating entity.
    /// - Important: By design this method should be used only within inheritors.
    /// - Parameters:
    ///   - job: Closure that modifyes storage. Usually its Api call.
    ///   - handler: Finish handler.
    /// - Throws: SSEntityRemoteMutatorError.notStarted if mutator hasn't started yet.
    public func mutate(job: @escaping AsyncJob, handler: @escaping Handler) throws {
        guard started else { throw SSEntityRemoteMutatorError.notStarted }
        let marker = Self.newMarker()

        DispatchQueue.bg.async {[weak self] in
            self?.handlers[marker] = handler
            job(marker) {
                if let mError = $0 {
                    DispatchQueue.bg.async {
                        self?.handleError(mError, marker: marker)
                    }
                }
            }
        }
    }
    
    /// Protected method for handling notifications. Should be used only whithing inheritors in every SSUpdatesReceiver's method.
    /// - Parameters:
    ///   - marker: Notification marker.
    ///   - error: Error.
    public func handleUpdate(with marker: String, error: Error? = nil) {
        if let handler = handlers.removeValue(forKey: marker) {
            onMain() {[weak self] in
                self?.handlersToApply.append((handler:handler, error: error))
            }
        }
    }
    
    //MARK: private
    
    private func handleError(_ error: Error, marker: String) {
        guard let handler = handlers.removeValue(forKey: marker) else { fatalError("No handler for \(marker)") }
        onMain { handler(error) }
    }
}

extension SSEntityRemoteMutator: SSBaseEntityMutating {
    public func start() {
        if (!started) {
            manager.addReceiver(self)
            started = true
        }
    }
    
    public func stop() {
        if (started) {
            manager.removeReceiver(self)
            started = false
        }
    }
}
