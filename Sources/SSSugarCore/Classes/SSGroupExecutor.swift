import Foundation

public protocol SSGroupExecuting {
    typealias Handler = () -> Void
    typealias Task = (@escaping Handler) -> Void
    
    @discardableResult
    func add(_ task: @escaping Task) -> SSGroupExecutor
    
    func finish(executor: SSExecutor, _ handler: @escaping () -> Void)
}

extension SSGroupExecuting {
    func finish(_ handler: @escaping () -> Void) {
        finish(executor: DispatchQueue.bg, handler)
    }
}

public class SSGroupExecutor: SSGroupExecuting {
    public typealias Task = (@escaping Handler) -> Void
    
    public var tasks = [Task]()
    
    public init() {}

    @discardableResult public func add(_ task: @escaping Task) -> SSGroupExecutor {
        tasks.append(task)
        return self
    }
    
    public func finish(executor: SSExecutor, _ handler: @escaping () -> Void) {
        let group = DispatchGroup()
        
        tasks.forEach { (task, _) in
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
