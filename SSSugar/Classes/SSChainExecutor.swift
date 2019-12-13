import Foundation

public class SSChainExecutor {
    public typealias Handler = ()->Void
    public typealias Task = (@escaping Handler)->Void
    public var tasks = [Task]()
    
    public init() {}

    @discardableResult public func add(_ task: @escaping Task) -> SSChainExecutor {
        tasks.append(task)
        return self
    }
    
    public func finish(queue: DispatchQueue = DispatchQueue.main, _ handler: (()->Void)? = nil) {
        var mTasks = Array(tasks.reversed())
        
        func iteration() {
            if let task = mTasks.popLast() {
                task(iteration)
            } else {
                handler?()
            }
        }
        iteration()
    }
}
