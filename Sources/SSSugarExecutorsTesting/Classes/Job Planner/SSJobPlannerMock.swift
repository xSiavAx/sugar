import Foundation
import SSSugarCore
import SSSugarExecutors
import SSSugarTesting

open class SSJobPlannerMock: SSMock, SSJobPlanning {
    open var scheduled: Bool { try! super.call() }
    
    open func scheduleNew(job: @escaping (@escaping (SSJobPlannerTOStrategy) -> Void) -> Void) {
        try! super.call(job)
    }
    
    open func expectScheduled(_ scheduled: Bool) {
        expect(result: scheduled) { mock, _ in mock.scheduled }
    }

    @discardableResult
    open func expectSchedule(captor: SSValueShortCaptor<(@escaping (SSJobPlannerTOStrategy) -> Void) -> Void>) -> SSMockCallExpectation {
        expect() { $0.scheduleNew(job: $1.capture(captor)) }
    }
    
    @discardableResult
    open func expectAndIgnore() -> SSMockCallExpectation {
        return expect() { $0.scheduleNew(job: $1.any({ _ in })) }
    }
    
    @discardableResult
    open func expectScheduleAndAsync(handler: @escaping (SSJobPlannerTOStrategy) -> Void) -> SSMockCallExpectation {
        let captor = captor()
        
        return expect() { $0.scheduleNew(job: $1.capture(captor)) }
            .andAsync { captor.released(handler) }
    }
    
    open func captor() -> SSValueShortCaptor<(@escaping (SSJobPlannerTOStrategy) -> Void) -> Void> {
        return .forClosure()
    }
}
