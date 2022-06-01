import Foundation

/// Requirements for tool that executes some group of async tasks.
public protocol SSGroupExecuting {
    /// Executors Handler type
    typealias Handler = () -> Void
    /// Executors task type
    typealias Task = (@escaping Handler) -> Void
    
    /// Adds passed task to executing group
    /// - Parameter task: task to add
    /// - Returns: Object was called on.
    @discardableResult
    func add(_ task: @escaping Task) -> Self
    
    /// Runs added tasks and calls handler on every task will be finished..
    /// - Parameter executor: Executor to call handler on.
    /// - Parameter handler: Finish handler to be called on last task finished.
    func finish(executor: SSExecutor, _ handler: @escaping () -> Void)
}

extension SSGroupExecuting {
    
    /// Runs added tasks and calls handler on every task will be finished..
    /// - Parameter handler: Finish handler to be called on last task finished.
    /// - Note: Handler will be called on `DispatchQueue.bg`
    public func finish(_ handler: @escaping () -> Void) {
        finish(executor: DispatchQueue.bg, handler)
    }
}

public class SSGroupExecutor: SSGroupExecuting {
    public typealias Task = (@escaping Handler) -> Void
    
    public var tasks = [Task]()
    
    /// Creates new executor
    public init() {}

    @discardableResult public func add(_ task: @escaping Task) -> Self {
        tasks.append(task)
        return self
    }
    
    public func finish(executor: SSExecutor, _ handler: @escaping () -> Void) {
        let group = DispatchGroup()
        
        tasks.forEach { task in
            group.enter()
            task { group.leave() }
        }
        if let executor = executor as? SSGCDExecutor {
            group.notify(queue: executor.underliedQueue(), execute: handler)
        } else {
            group.notify(queue: DispatchQueue.bg) {
                executor.execute {
                    handler()
                }
            }
        }
    }

    /// - Warning: **Deprecated**. Use `init(size:buildBlock:)` instead.
    @available(*, deprecated, message: "Use `finish(executor:handler:)` instead")
    public func finish(queue: DispatchQueue, _ handler: @escaping () -> Void) {
        finish(executor: queue, handler)
    }
}
