import Foundation

public protocol SSUpdaterEntitySource: AnyObject {
    associatedtype Entity

    func entity<Updater: SSBaseEntityUpdating>(for updater: Updater) -> Entity?
}

public protocol SSEntityUpdaterDelegate: AnyObject {}

/// Requirements for Entity Mutator with some addons (like marker generating or dispatching on main queue)
public protocol SSBaseEntityUpdating: AnyObject, SSOnMainExecutor {
    associatedtype Source: SSUpdaterEntitySource
    associatedtype Delegate: SSEntityUpdaterDelegate
    
    typealias Entity = Source.Entity
    
    /// Object that give's (and potentially own) entity object to mutate.
    var source: Source? {get set}
    var delegate: Delegate? {get set}
    var receiversManager: SSUpdateReceiversManaging {get}
    
    func start(source: Source, delegate: Delegate)
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
