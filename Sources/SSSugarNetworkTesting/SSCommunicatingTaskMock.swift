import Foundation
import SSSugarCore
import SSSugarNetwork
import SSSugarTesting

open class SSCommunicatingTaskMock: SSMock, SSCommunicatingTask {
    open var finished: Bool { try! call() }
    
    open func cancel() { try! call() }
    
    open func expectFinished(_ finished: Bool) -> SSMockCallExpectation {
        expect(result: finished) { $0.finished }
    }
    
    open func expectCancel() -> SSMockCallExpectation {
        expect() { $0.cancel() }
    }
}
