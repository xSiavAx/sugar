import Foundation
import SSSugarCore


open class SSChainExecutorBuilderMock: SSMock, SSChainExecutorBuilding {
    open func executor() -> SSChainExecuting {
        try! super.call()
    }
    
    @discardableResult
    open func expectBuild(chain: SSChainExecutorMock) -> SSMockCallExpectation {
        expect(result: chain) { mock, _ in mock.executor() }
    }
}

open class SSChainExecutorMock: SSMock, SSChainExecuting {
    public typealias Task = SSChainExecuting.Task
    
    open func add(_ task: @escaping Task) -> Self {
        try! super.call(task)
    }
    
    open func finish(executor: SSExecutor, _ handler: @escaping Handler) {
        try! super.call(executor, handler)
    }
    
    open func finish(_ handler: @escaping Handler) {
        try! super.call(handler)
    }
    
    open func finish() {
        try! super.call()
    }
    
    @discardableResult
    open func expectAndAsync(times: Int) -> SSMockCallExpectation {
        expectAndAsync(executor: nil as SSExecutorMock?, times: times)
    }
    
    @discardableResult
    open func expectAndAsync<Ex: AnyObject & SSExecutor>(executor: Ex?, times: Int) -> SSMockCallExpectation {
        let finishCaptor = captor()
        
        let taskCaptors = (0..<times).map() { _ -> SSValueShortCaptor<Task> in
            let captor = taskCaptor()
            
            expect(result: self) { $0.add($1.capture(captor)) }
            
            return captor
        }
        return expect() {
            if let executor = executor {
                $0.finish(executor: $1.same(executor), $1.capture(finishCaptor))
            } else {
                $0.finish($1.capture(finishCaptor))
            }
        }
             .andAsync {
                 let chainExecutor = SSChainExecutor()

                 taskCaptors.forEach() { captor in
                     chainExecutor.add() {
                         captor.released($0)
                     }
                 }
                 chainExecutor.finish(executor: DispatchQueue.bg) {
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

