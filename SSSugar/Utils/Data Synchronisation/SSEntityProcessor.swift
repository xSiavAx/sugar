import Foundation

public protocol SSEntityObtainer {
    associatedtype Entity
    
    func obtain() -> Entity?
}

#warning("Add docs")
public protocol SSEntityProcessing {
    func start(_ handler: @escaping ()->Void)
    func stop()
}

public protocol SSSingleEntityProcessing: SSUpdaterEntitySource, SSMutatingEntitySource, SSOnMainExecutor
where
    Entity == Obtainer.Entity,
    Entity == Mutator.Entity
{
    associatedtype Obtainer: SSEntityObtainer
    associatedtype Updater: SSBaseEntityUpdating
    associatedtype Mutator: SSBaseEntityMutating
    
    var startOnEmptyEntity: Bool {get}
    var entity: Entity? {get}
    var executor: SSExecutor {get}
    var obtainer: Obtainer {get}
    var updater: Updater? {get}
    var mutator: Mutator? {get}
    var updateDelegate: Updater.Delegate? {get}
    
    func createUpdaterAndMutator()
    func assign(entity: Entity)
}

extension SSSingleEntityProcessing {
    public var startOnEmptyEntity: Bool { true }
    
    public func stop() {
        updater?.stop()
        mutator?.stop()
    }
}

extension SSSingleEntityProcessing where Updater.Source == Self, Mutator.Source == Self
{
    public func start(_ handler: @escaping () -> Void) {
        createUpdaterAndMutator()
        
        func onBg() {
            if let entity = obtainer.obtain() {
                func assignAndFinish() {
                    assign(entity: entity)
                    handler()
                }
                startHelpers()
                onMain(assignAndFinish)
            } else {
                if (startOnEmptyEntity) {
                    startHelpers()
                }
                onMain(handler)
            }
        }
        executor.execute(onBg)
    }
    
    private func startHelpers() {
        updater?.start(source: self, delegate: updateDelegate!)
        mutator?.start(source: self)
    }
}

extension SSSingleEntityProcessing where Entity == Updater.Source.Entity {
    public func entity<Updater: SSBaseEntityUpdating>(for updater: Updater) -> Entity? {
        return entity
    }
}

extension SSSingleEntityProcessing where Entity == Mutator.Entity {
    public func entity<Mutating: SSBaseEntityMutating>(for mutator: Mutating) -> Entity?  {
        return entity
    }
}

