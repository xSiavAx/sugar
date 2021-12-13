import Foundation
import SSSugarCore

public class SSStepBasedTimeCalculatingMock: SSMock, SSStepBasedTimeCalculating, SSLimitedStepBasedTimeCalculating {
    public var maxTimeout: TimeInterval { try! super.call() }
    
    public func timeBasedOn(step: Int) -> TimeInterval {
        try! super.call(step)
    }
    
    @discardableResult
    public func expectCall(steps: Int, result: TimeInterval) -> SSMockCallExpectation {
        expect(result: result) { $0.timeBasedOn(step: $1.eq(steps)) }
    }
    
    @discardableResult
    public func expectMaxTimeout(_ result: TimeInterval) -> SSMockCallExpectation {
        expect(result: result) { $0.maxTimeout }
    }
}
