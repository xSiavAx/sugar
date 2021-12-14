import Foundation

public protocol SSChainExecuting {
    typealias Handler = () -> Void
    typealias Task = (@escaping Handler) -> Void
    
    func add(_ task: @escaping Task) -> Self
    func finish(executor: SSExecutor, _ handler: @escaping Handler)
    func finish(_ handler: @escaping Handler)
    func finish()
}

/// Note: - SSChainExecutor willn't produce memory leak, even if some of adding tasks willn't call handler or somewhat else, cuz logic in finish method doesn't captures `self` at all.
public class SSChainExecutor: SSChainExecuting {
    public typealias Task = (@escaping Handler) -> Void
    
    public var tasks = [Task]()
    
    public init() {}

    @discardableResult public func add(_ task: @escaping Task) -> Self {
        tasks.append(task)
        return self
    }
    
    public func finish(executor: SSExecutor, _ handler: @escaping Handler) {
        finish(executor: executor, handler: handler)
    }
    
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
