import Foundation
import SSSugarCore

public class SSCommunicatingTaskMock: SSMock, SSCommunicatingTask {
    public var finished: Bool { try! call() }
    
    public func cancel() { try! call() }
    
    public func expectFinished(_ finished: Bool) -> SSMockCallExpectation {
        expect(result: finished) { $0.finished }
    }
    
    public func expectCancel() -> SSMockCallExpectation {
        expect() { $0.cancel() }
    }
}
