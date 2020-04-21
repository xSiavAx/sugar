import Foundation

#warning("Add docs")
open class SSEntityDmMutator<Source: SSMutatingEntitySource, Dispatcher: SSDmRequestDispatcher> {
    public private(set) weak var source: Source?
    /// Notifier for modification notification sending
    public let dispatcher: Dispatcher

    public init(executor mExecutor: SSExecutor, requestDispatcher: Dispatcher) {
        dispatcher = requestDispatcher
    }
    
    public func mutate(requests: [Dispatcher.Request], resolveConflicts: Bool, handler: @escaping (_ error: SSDmRequestDispatchError?)->Void) {
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
