import Foundation

public enum SSJobPlannerTOStrategy {
    case increase
    case maximize
    case reset
    case ignore
}

public protocol SSJobPlanning {
    var scheduled: Bool { get }
    
    func scheduleNew(job: @escaping ( @escaping (SSJobPlannerTOStrategy) -> Void ) -> Void)
}

extension SSJobPlanning {
    public func scheduleIfNotScheduled(job: @escaping ( @escaping (SSJobPlannerTOStrategy) -> Void ) -> Void) {
        if (!scheduled) {
            scheduleNew(job: job)
        }
    }
}
