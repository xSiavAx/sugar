import Foundation
import SSSugarCore

public class SSJobPlannerMock: SSMock, SSJobPlanning {
    public var scheduled: Bool { try! super.call() }
    
    public func scheduleNew(job: @escaping (@escaping (SSJobPlannerTOStrategy) -> Void) -> Void) {
        try! super.call(job)
    }
    
    public func expectScheduled(_ scheduled: Bool) {
        expect(result: scheduled) { mock, _ in mock.scheduled }
    }
    
    @discardableResult
    public func expectSchedule(captor: SSValueShortCaptor<(@escaping (SSJobPlannerTOStrategy) -> Void) -> Void>) -> SSMockCallExpectation {
        expect() { $0.scheduleNew(job: $1.capture(captor)) }
    }
    
    @discardableResult
    public func expecetAndIgnore() -> SSMockCallExpectation {
        return expect() { $0.scheduleNew(job: $1.any({ _ in })) }
    }
    
    @discardableResult
    public func expecetScheduleAndAsync(handler: @escaping (SSJobPlannerTOStrategy) -> Void) -> SSMockCallExpectation {
        let captor = captor()
        
        return expect() { $0.scheduleNew(job: $1.capture(captor)) }
            .andAsync { captor.released(handler) }
    }
    
    public func captor() -> SSValueShortCaptor<(@escaping (SSJobPlannerTOStrategy) -> Void) -> Void> {
        return .forClosure()
    }
}
