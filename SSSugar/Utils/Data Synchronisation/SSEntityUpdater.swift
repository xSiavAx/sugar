import Foundation

/// Requirements for Updater's Entity source.
public protocol SSUpdaterEntitySource: AnyObject {
    /// Source Entity type
    associatedtype Entity
    
    /// Returns entity for Updater
    /// - Parameter updater: Updater that requiries entity.
    func entity<Updater: SSBaseEntityUpdating>(for updater: Updater) -> Entity?
}

/// Base protocol for Updater's delegate
public protocol SSEntityUpdaterDelegate: AnyObject {}

/// Requirements for Entity Updater
///
/// # Provides:
/// * `entity` implementation via `source.entity` proxing.
/// * `func start(source: Source, delegate: Delegate)` implementation.
/// * `func stop()` implementation.
///
/// # Implements:
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
    
    /// Startes updater.
    ///
    /// # Default implementation:
    /// Assign `source` and `delegate`, subscribe for updates.
    /// - Parameters:
    ///   - source: Entity source.
    ///   - delegate: Entity updater's delegate.
    func start(source: Source, delegate: Delegate)
    /// Stops updater.
    /// # Default implementation:
    /// Unsubscribe from updates.
    func stop()
}

extension SSBaseEntityUpdating {
    public var entity: Source.Entity? { return source?.entity(for: self) }
}

extension SSBaseEntityUpdating where Self: SSUpdateReceiver {
    public func start(source mSource: Source, delegate mDelegate: Delegate) {
        source = mSource
        delegate = mDelegate
        receiversManager.addReceiver(self)
    }
    
    public func stop() {
        receiversManager.removeReceiver(self)
    }
}
