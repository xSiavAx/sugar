import Foundation

public protocol SSGroupExecutorBuilding {
    func executor() -> SSGroupExecuting
}

public class SSGroupExecutorBuilder: SSGroupExecutorBuilding {
    public init() {}
    
    public func executor() -> SSGroupExecuting {
        return SSGroupExecutor()
    }
}
