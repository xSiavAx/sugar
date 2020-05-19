import Foundation

/// Base class for any Entity Mutator that works with data modifications wit revisions. Just proxies calls to some `SSDmRequestDispatcher`.
/// - Note:
/// It's inheritors responsobility to provide requests creating. See `SSUETaskDmMutator` example for more info.
open class SSEntityDmMutator<Source: SSMutatingEntitySource, Dispatcher: SSDmRequestDispatcher> {
    /// Modifying entity source
    public private(set) weak var source: Source?
    /// Tool for requests dispatching
    public let dispatcher: Dispatcher
    
    /// Creates new Mutator with passed dispatcher
    /// - Parameter requestDispatcher: Requests dispatcher.
    public init(requestDispatcher: Dispatcher) {
        dispatcher = requestDispatcher
    }
    
    /// Protected method for mutating entity.
    ///
    /// Dispatches passed request via `dispatcher`.
    /// - Important: By design this method should be used only withing inheritors.
    /// - Parameters:
    ///   - requests: Requests array to dispatch.
    ///   - handler: Finish handler runned on main thread.
    ///   - error: Dispatch errror that amy occurs during mutating.
    public func mutate(requests: [Dispatcher.Request], handler: @escaping (_ error: SSDmRequestDispatchError?)->Void) {
        dispatcher.dispatchReuqests(requests, handler: handler)
    }
}

extension SSEntityDmMutator: SSBaseEntityMutating {
    #warning("TODO: Add started/stopped logic?")
    public func start(source mSource: Source) {
        source = mSource
    }
    
    public func stop() {}
}
