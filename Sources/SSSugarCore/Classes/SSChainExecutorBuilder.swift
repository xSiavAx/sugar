import Foundation

public protocol SSChainExecutorBuilding {
    func executor() -> SSChainExecuting
}

public class SSChainExecutorBuilder: SSChainExecutorBuilding {
    public init() {}
    
    public func executor() -> SSChainExecuting {
        return SSChainExecutor()
    }
}
