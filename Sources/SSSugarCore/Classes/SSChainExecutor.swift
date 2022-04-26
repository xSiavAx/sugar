import Foundation

/// Requirements for tool that chain async tasks execution.
public protocol SSChainExecuting {
    /// Executors Handler type
    typealias Handler = () -> Void
    /// Executors task type
    typealias Task = (@escaping Handler) -> Void
    
    /// Adds passed task to end of chain
    /// - Parameter task: task to add
    /// - Returns: Object was called on.
    @discardableResult
    func add(_ task: @escaping Task) -> Self
    
    /// Runs added tasks one by one and calls handler on finish.
    /// - Parameter executor: Executor to call handler on.
    /// - Parameter handler: Finish handler to be called on last task finished.
    func finish(executor: SSExecutor, _ handler: @escaping Handler)
    
    /// Runs added tasks one by one and calls handler on finish.
    /// - Parameter handler: Finish handler to be called on last task finished.
    func finish(_ handler: @escaping Handler)
    
    /// Runs added tasks one by one
    func finish()
}

/// Executor that executes async tasks one by one.
///
/// Note: - DefaultChainExecutor willn't produce memory leak, even if some of adding tasks willn't call handler or somewhat else, cuz logic in finish method doesn't captures `self` at all.
public class SSChainExecutor: SSChainExecuting {
    public typealias Task = (@escaping Handler) -> Void
    
    /// Stored tasks to execute
    private var tasks = [Task]()
    
    /// Creates new chain executor
    public init() {}

    @discardableResult
    public func add(_ task: @escaping Task) -> Self {
        tasks.append(task)
        return self
    }
    
    public func finish(executor: SSExecutor, _ handler: @escaping Handler) {
        finish(executor: executor, handler: handler)
    }
    
    /// See `ChainExecutor.finish()` docs.
    ///
    /// - Note: Handler will be called within the same queue as handler of last added task.
    public func finish(_ handler:  @escaping Handler) {
        finish(executor: nil, handler: handler)
    }
    
    public func finish() {
        finish(executor: nil, handler: nil)
    }
    
    //MARK: - private
    
    public func finish(executor: SSExecutor?, handler: (()->Void)?) {
        var mTasks = Array(tasks.reversed())
        
        func iteration() {
            if let task = mTasks.popLast() {
                task(iteration)
            } else {
                if let executor = executor {
                    executor.execute { handler?() }
                } else {
                    handler?()
                }
            }
        }
        iteration()
    }
}
