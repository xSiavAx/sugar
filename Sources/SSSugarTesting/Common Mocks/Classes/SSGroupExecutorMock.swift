import Foundation
import SSSugarCore

open class SSGroupExecutorBuilderMock: SSMock, SSGroupExecutorBuilding {
    open func executor() -> SSGroupExecuting {
        try! super.call()
    }
    
    @discardableResult
    open func expectBuild(group: SSGroupExecutorMock) -> SSMockCallExpectation {
        expect(result: group) { mock, _ in mock.executor() }
    }
}

open class SSGroupExecutorMock: SSMock, SSGroupExecuting {
    public typealias Task = SSGroupExecuting.Task
    
    @discardableResult
    open func add(_ task: @escaping Task) -> Self {
        try! super.call(task)
    }
    
    open func finish(executor: SSExecutor, _ handler: @escaping () -> Void) {
        try! super.call(executor, handler)
    }
    
    open func expectAndAsync<Ex: AnyObject & SSExecutor>(executor: Ex, times: Int) {
        let finishCaptor = captor()
        let taskCaptors = (0..<times).map() { _ -> SSValueShortCaptor<Task> in
            let captor = taskCaptor()
            
            expect(result: self) { $0.add($1.capture(captor)) }
            
            return captor
        }
        expect() { $0.finish(executor: $1.same(executor), $1.capture(finishCaptor)) }
             .andAsync {
                 //We use chain executor, cuz we want constant execution order
                 let executor = SSChainExecutor()
                 
                 taskCaptors.forEach() { captor in
                     executor.add() { captor.released($0) }
                 }
                 executor.finish(executor: DispatchQueue.bg) {
                     finishCaptor.released()
                 }
             }
    }
    
    open func taskCaptor() -> SSValueShortCaptor<Task> {
        return .forClosure()
    }
    
    open func captor() -> SSValueShortCaptor<() -> Void> {
        return .forClosure()
    }
}
