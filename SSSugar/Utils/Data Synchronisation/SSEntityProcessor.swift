import Foundation

/// Requirements for tool that obtains entity.
public protocol SSEntityObtainer {
    associatedtype Entity
    
    func obtain() -> Entity?
}

/// Requirements for tool that process entity.
public protocol SSEntityProcessing {
    /// Obtains entity and start listening for it's updates
    /// - Parameter handler: Finish handler
    func start(_ handler: @escaping ()->Void)
    /// Stops processing entity
    func stop()
}

/// Requirements for processor that works with single entity.
///
/// Protocol provides default implementation (with some conditions, see below) for `start` and `stop` that fits almost all possible concrete processors.
///
/// # Provides:
/// * Default implementation for `stop` – stops Updater and Mutator.
/// * Default imnplementation for `SSUpdaterEntitySource` when `Entity` and `Updater.Source.Enity` is same.
/// * Default imnplementation for `SSMutatingEntitySource` when `Entity` and `Mutator.Entity` is same.
/// * Default implementation for `start` – creates Updater and Mutator via abstract method `createUpdaterAndMutator`, obtain Enriry via `Obtainer`, assign it via abstract method `assign(entity:)`, starts `Updater` and `Mutator` when `Processor` is Enity source for updater and mutator (see previous 2 items).
///
/// # Conforms to:
/// `SSUpdaterEntitySource`, `SSMutatingEntitySource`, `SSOnMainExecutor`
///
/// # Requires:
/// Processor's, Obtainer's and Mutator's `Entity` should be the same type.
public protocol SSSingleEntityProcessing: SSUpdaterEntitySource, SSMutatingEntitySource, SSOnMainExecutor
where
    Entity == Obtainer.Entity,
    Entity == Mutator.Entity
{
    /// Processor's Obtainer Type
    associatedtype Obtainer: SSEntityObtainer
    /// Processor's Updater Type
    associatedtype Updater: SSBaseEntityUpdating
    /// Processor's Mutator Type
    associatedtype Mutator: SSBaseEntityMutating
    
    /// Indicates, should processor starts when no entity obtained.
    ///
    /// Default value is `true`.
    /// - Note: Override to `false` for cases when processor shouldn't wait for entity creation. Processor will not start it's updater and mutator if entity hasn't obtained.
    var startOnEmptyEntity: Bool {get}
    
    /// Processing entity
    var entity: Entity? {get set}
    /// Background tasks executor
    var executor: SSExecutor {get}
    /// Entity obtainer
    var obtainer: Obtainer {get}
    /// Entity updater
    var updater: Updater? {get}
    /// Entity mutator
    var mutator: Mutator? {get}
    /// Updates delegate
    var updateDelegate: Updater.Delegate? {get}
    
    /// Creates `Updater` and `Mutator`.
    ///
    /// Override it – create and assign to corresponding properties concrete `Updater` and `Mutator`.
    func createUpdaterAndMutator()
}

extension SSSingleEntityProcessing {
    public var startOnEmptyEntity: Bool { true }
    
    public func stop() {
        updater?.stop()
        mutator?.stop()
    }
}

extension SSSingleEntityProcessing where Updater.Source == Self, Mutator.Source == Self {
    public func start(_ handler: @escaping () -> Void) {
        createUpdaterAndMutator()
        
        func onBg() {
            if let obtained = obtainer.obtain() {
                func assignAndFinish() {
                    entity = obtained
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

