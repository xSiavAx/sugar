import Foundation
import SSSugarExecutors

/// Requirements for Updater's Entity source.
public protocol SSUpdaterEntitySource: AnyObject {
    /// Source Entity type
    associatedtype Entity
    
    /// Updates entity by passed `updater` using passed `closure`.
    /// - Parameters:
    ///   - updater: Updater which will modify entity.
    ///   - job: Closure that mutates entity. It may return other closure that will be called outside of entity modification scope. It's helpfull, when updater notifies it's delegate and delegate could safety read entity via it's own getter without running into `Simultaneous access` error.
    ///
    /// - Note: `Simultaneous access` error has been occuring cuz: 1) Updater calls `updateEntity` of it's source, that calls `job` closure within entity modification scope (cuz entity passed to job as `inout`). 2) There is call to Updater's delegate inside job closure (to notify that entity has just changed) 3) Delegate implementator may want to access entity within that method (to obtain some additional data, `isListEmpty` for example) 4) Since delegates method has called withing `job` closure, that has called within `updateEntity` that opens modifications entity scope (and doesn't close it untill `job` finished) we run's into `Simultaneous access` – `updateEntity` writes and Delegate implementator reads. Thats why we add closure as return of `job`, vars got within job may be applied within that closure (like pos of item in list, etc) and closure are called without modification scope.
    ///
    func updateEntity<Updater: SSBaseEntityUpdating>(by updater: Updater, job: (inout Entity?)->(()->Void)?)
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
    public func protUpdate(_ job: (inout Source.Entity?) -> (() -> Void)?) -> Void {
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
