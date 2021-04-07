import Foundation

/// Requirements for Updater's Entity source.
public protocol SSUpdaterEntitySource: AnyObject {
    /// Source Entity type
    associatedtype Entity
    
    /// Updates entity by passed `updater` using passed `closure`.
    /// - Parameters:
    ///   - updater: Updater which will modify entity.
    ///   - job: Closure that makes entity updates.
    func updateEntity<Updater: SSBaseEntityUpdating>(by updater: Updater, job: (inout Entity?)->Void)
}

/// Base protocol for Updater's delegate
public protocol SSEntityUpdaterDelegate: AnyObject {}

/// Requirements for Entity Updater
///
/// # Provides:
/// * `func start(source: Source, delegate: Delegate)` implementation.
/// * `func stop()` implementation.
///
/// # Conforms to:
/// `SSOnMainExecutor`
public protocol SSBaseEntityUpdating: AnyObject, SSOnMainExecutor {
    /// Updater's entity Source Type
    associatedtype Source: SSUpdaterEntitySource
    /// Updater's Delegate Type
    associatedtype Delegate: SSEntityUpdaterDelegate
    
    /// Object that give's (and potentially own) entity object to update.
    var source: Source? {get set}
    /// Updater's delegate
    var delegate: Delegate? {get set}
    /// Manager to subscribe/unsubscribe to/from updates.
    var receiversManager: SSUpdateReceiversManaging {get}
    
    /// Starts updater.
    ///
    /// # Default implementation:
    /// Subscribe for updates.
    ///
    /// - Important: `source` and `delegate` should be assigned.
    func start()
    
    /// Stops updater.
    ///
    /// # Default implementation:
    /// Unsubscribe from updates.
    func stop()
}

extension SSBaseEntityUpdating {
    /// Updates entity using passed closure.
    ///
    /// - Inportnat: Protected means it's for internal usage only. Don't use this method whenever except inheritors.
    public func protUpdate(_ job: (inout Source.Entity?)->Void ) -> Void {
        source?.updateEntity(by: self, job: job)
    }
}

extension SSBaseEntityUpdating where Self: SSUpdateReceiver {
    public func start() {
        guard source != nil, delegate != nil else { fatalError("`Source` and `Delegate` should be assigned before `start`") }
        receiversManager.addReceiver(self)
    }
    
    public func stop() {
        receiversManager.removeReceiver(self)
    }
}

/// Protocol-helper, contains updates collecting and applying logic.
///
/// Usefull to extend some `SSUpdateReceiver` implementator.
public protocol SSUpdateApplying: AnyObject {
    typealias CollectableUpdate = ()->Void
    var collectedUpdates: [CollectableUpdate] {get set}
}

extension SSUpdateApplying {
    public func collect(update: @escaping CollectableUpdate) {
        collectedUpdates.append(update)
    }
    
    public func apply() {
        collectedUpdates.forEach { $0() }
        collectedUpdates.removeAll()
    }
}
