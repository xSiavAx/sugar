import Foundation

#warning("TODO: Move model-updating functional out of processor (to EntityUpdater for ex)")

public protocol SSEntityObtainer {
    associatedtype Entity
    
    func obtain() -> Entity?
}

/// Base class for Any Entity Processor. Incapsulate obtain and updates subscribtions logic.
///
/// - Note: Use `SSEntityMutators` for mutating outside of `SSEntityProcessor`
open class SSEntityProcessor<Obtainer: SSEntityObtainer>: SSOnMainExecutor {
    /// Entity type
    public typealias Entity = Obtainer.Entity
    
    /// Processor's entity
    public private(set) var entity: Entity?
    /// Processor's entity obtainer
    public let obtainer: Obtainer
    /// Update center for notification subscriptions
    public let updater: SSUpdateReceiversManaging
    /// Executor to dispatch background tasks
    public let executor: SSExecutor
    
    public init(obtainer mObtainer: Obtainer, updater mUpdater: SSUpdateReceiversManaging, executor mExecutor: SSExecutor) {
        updater = mUpdater
        obtainer = mObtainer
        executor = mExecutor
    }
        
    deinit { updater.removeReceiver(self) }
    
    /// Starts processor. Obtain data and subscrive for updates.
    /// - Parameter handler: Closure will called on data obtain.
    public func start(_ handler: @escaping ()->Void) {
        onData { [weak self] in self?.obtain(handler) }
    }
    
    /// Dispatch passed closure on BG queue via executor.
    /// Method for internal purposes.
    /// - Parameter handler: closure to dispatch
    public func onData(_ handler: @escaping ()->Void) {
        executor.execute(handler)
    }
    
    //MARK: - private
    private func obtain(_ handler: @escaping ()->Void) {
        let mModel = obtainer.obtain()
        
        func didObtain() {
            entity = mModel
            handler()
        }
        onMain(didObtain)
        
        if (mModel != nil) {
            updater.addReceiver(self)
        }
    }
}

extension SSEntityProcessor: SSUpdateReceiver {
    /// Dummy reactions implementation. Each inheritor has override this method.
    ///
    /// - Returns: empty reactions dict.
    public func reactions() -> SSUpdate.ReactionMap {
        return [:]
    }
}
