import Foundation

public protocol SSUpdaterEntitySource: AnyObject {
    associatedtype Entity
    
    func entity<Updater: SSBaseEntityUpdating>(for updater: Updater) -> Entity?
}

public protocol SSEntityUpdaterDelegate: AnyObject {}

/// Requirements for Entity Mutator with some addons (like marker generating or dispatching on main queue)
public protocol SSBaseEntityUpdating: SSOnMainExecutor {
    associatedtype Source: SSUpdaterEntitySource
    associatedtype Delegate: SSEntityUpdaterDelegate
    
    typealias Entity = Source.Entity
    
    /// Object that give's (and potentially own) entity object to mutate.
    var source: Source? {get}
    var delegate: Delegate? {get set}
    
    func start(source: Source)
    func stop()
}

open class SSEntityUpdater<Source: SSUpdaterEntitySource, Delegate: SSEntityUpdaterDelegate> {
    public weak var delegate: Delegate?
    public private(set) weak var source: Source?
    public var receiversManager: SSUpdateReceiversManaging
    public var entity: Entity? { return source?.entity(for: self) }
    
    public init(updateReceiversManager: SSUpdateReceiversManaging) {
        receiversManager = updateReceiversManager
    }
    
    deinit {
        stop()
    }
}

extension SSEntityUpdater: SSBaseEntityUpdating {
    public func start(source mSource: Source) {
        source = mSource
        receiversManager.addReceiver(self)
    }
    
    public func stop() {
        receiversManager.removeReceiver(self)
    }
}

extension SSEntityUpdater: SSOnMainExecutor {}

extension SSEntityUpdater: SSUpdateReceiver {
    public func reactions() -> SSUpdate.ReactionMap {
        print("Call wrong")
        return [:]
    }
}
