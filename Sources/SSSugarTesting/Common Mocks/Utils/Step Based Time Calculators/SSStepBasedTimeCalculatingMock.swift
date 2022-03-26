import Foundation
import SSSugarCore

open class SSStepBasedTimeCalculatingMock: SSMock, SSStepBasedTimeCalculating, SSLimitedStepBasedTimeCalculating {
    open var maxTimeout: TimeInterval { try! super.call() }
    
    open func timeBasedOn(step: Int) -> TimeInterval {
        try! super.call(step)
    }
    
    @discardableResult
    open func expectCall(steps: Int, result: TimeInterval) -> SSMockCallExpectation {
        expect(result: result) { $0.timeBasedOn(step: $1.eq(steps)) }
    }
    
    @discardableResult
    open func expectMaxTimeout(_ result: TimeInterval) -> SSMockCallExpectation {
        expect(result: result) { $0.maxTimeout }
    }
}
