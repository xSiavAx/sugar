import Foundation

public protocol SSEntityUpdating {
    associatedtype Entity
}

public protocol SSUpdaterEntitySource: AnyObject {
    associatedtype Entity
    
    func entity<Updater: SSEntityUpdating>(for updater: Updater) -> Entity?
}

public protocol SSEntityUpdaterDelegate: AnyObject {}

open class SSEntityUpdater<Source: SSUpdaterEntitySource, Delegate: SSEntityUpdaterDelegate> {
    public typealias Entity = Source.Entity
    
    weak var delegate: Delegate?
    unowned let source: Source
    public var receiversManager: SSUpdateReceiversManaging
    public var entity: Entity? { return source.entity(for: self) }
    
    public init(entitySource: Source, updateReceiversManager: SSUpdateReceiversManaging) {
        source = entitySource
        receiversManager = updateReceiversManager
    }
    
    deinit {
        receiversManager.removeReceiver(self)
    }
    
    public func start() {
        receiversManager.addReceiver(self)
    }
    
    public func stop() {
        receiversManager.removeReceiver(self)
    }
}

extension SSEntityUpdater: SSOnMainExecutor {}

extension SSEntityUpdater: SSEntityUpdating {}

extension SSEntityUpdater: SSUpdateReceiver {
    public func reactions() -> SSUpdate.ReactionMap {
        return [:]
    }
}
