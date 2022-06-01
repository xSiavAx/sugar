import Foundation

/// Requirements for util that builds some Chain Executor
///
/// Usually used to simplify unit testing for utils that uses some ChainExecutor implementation.
///
/// - Seealso: ChainExecutor
public protocol SSChainExecutorBuilding {
    /// Builds some chain executor
    /// - Returns: Built chain executor
    func executor() -> SSChainExecuting
}

/// Tool that builds `DefaultChainExecutor` as some `ChainExecutor`
///
public class SSChainExecutorBuilder: SSChainExecutorBuilding {
    /// Creates new builder
    public init() {}
    
    /// Builds `DefaultChainExecutor` as some `ChainExecutor`
    /// - Returns: Built `DefaultChainExecutor` instance.
    public func executor() -> SSChainExecuting {
        return SSChainExecutor()
    }
}
