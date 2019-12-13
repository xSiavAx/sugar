import Foundation

public class SSGroupExecutor {
    public typealias Handler = ()->Void
    public typealias Task = (@escaping Handler)->Void
    public var tasks = [Task]()
    
    public init() {}

    @discardableResult public func add(_ task: @escaping Task) -> SSGroupExecutor {
        tasks.append(task)
        return self
    }
    
    public func finish(queue: DispatchQueue = DispatchQueue.main, _ handler: @escaping ()->Void) {
        let group = DispatchGroup()
        
        tasks.forEach { (task, _) in
            group.enter()
            task { group.leave() }
        }
        group.notify(queue: queue, execute: handler)
    }
}
