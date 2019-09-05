import Foundation

/// Struct incapsulate data obtain result.
public struct SSObtainResult<Model> {
    /// Indicate should obtaining be repeated or not. For example, if obtainer decide that data may be not actual it return result with 'true' value in this property.
    public var needReobtain = false
    /// Obtaining model
    public var model : Model?
    
    public init() {}
}

/// Protocol with requirements for each model obtainer.
public protocol SSModelObtainer {
    /// Obtaining model type
    associatedtype Model
    
    /// Prepare to obtain model (for example, notification subscriptions)
    func start()
    /// Obtain model
    func obtain()
    /// Generate obtaining result
    func finish() -> SSObtainResult<Model>
}

/// Base class for Any Model Processor. Incapsulate obtain and updates subscribtions logic.
///
/// There is ModelObtainer as Generic.
open class SSModelProcessor<Obtainer: SSModelObtainer> {
    /// Model Processor work with
    public typealias Model = Obtainer.Model
    
    /// Internal struct implementing ObtainJob protocol
    private struct ProcObtainJob: SSObtainJob {
        let run: ()->Void
        let onFinish: ()->Bool
    }
    /// Struct implementing EditJob protocol
    public struct ProcEditJob: SSProcessorJob {
        public let run: () throws ->Void
        public let onFinish: ()->Void
    }
    
    /// Processor's model obtainer
    public var obtainer: Obtainer?
    /// Update center for notification subscriptions
    var updater: SSUpdateCenter
    
    /// Create new processor with passed Update Center and Obtainer
    ///
    /// Ussually inheritor creates Obtainer and pass it to super's init
    /// - Parameters:
    ///   - updater: Update Center for notificatons subscriptions
    ///   - obtainer: Model obtainer
    init(updater mUpdater: SSUpdateCenter, obtainer mObtainer: Obtainer) {
        updater = mUpdater
        obtainer = mObtainer
    }
    
    deinit { updater.removeReceiver(self) }
    
    //MARK: protected
    func pAssignModel(_ model: Model) {}
    func pModelUnavailable() {}
}

extension SSModelProcessor: SSObtainJobCreator {
    /// Obtain data. Creates Obtain Job object user can control obtaining process with.
    ///
    /// - Returns: created ObtainJob object.
    public func obtain() -> SSObtainJob {
        obtainer!.start()
        return ProcObtainJob(run: obtainer!.obtain, onFinish: onDidObtain)
    }
    
    //MARK: private
    private func onDidObtain() -> Bool {
        guard let data = obtainer?.finish() else { fatalError("Invalid state") }
        guard !data.needReobtain else { return false }
        
        obtainer = nil
        if let model = data.model {
            pAssignModel(model)
            updater.addReceiver(self)
        } else {
            pModelUnavailable()
        }
        return true
    }
}

extension SSModelProcessor: SSUpdateReceiver {
    /// Dummy reactions implementation. Each inheritor has override this method.
    ///
    /// - Returns: empty reactions dict.
    public func reactions() -> SSUpdate.ReactionMap {
        return [:]
    }
}
