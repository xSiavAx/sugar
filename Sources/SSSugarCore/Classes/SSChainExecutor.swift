import Foundation

/// Note: - SSChainExecutor willn't produce memory leak, even if some of adding tasks willn't call handler or somewhat else, cuz logic in finish method doesn't captures `self` at all.
public class SSChainExecutor {
    public typealias Handler = ()->Void
    public typealias Task = (@escaping Handler)->Void
    public var tasks = [Task]()
    
    public init() {}

    @discardableResult public func add(_ task: @escaping Task) -> SSChainExecutor {
        tasks.append(task)
        return self
    }
    
    public func finish(_ handler: (()->Void)? = nil) {
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
