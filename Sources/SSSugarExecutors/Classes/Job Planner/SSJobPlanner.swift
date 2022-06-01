import Foundation
import SSSugarCore

/// Tool that incapsulates planning repeating job.
///
/// Use `scheduleNew(job:)` to schedule passed job after current Time Out. Initial TO calculated by passing 0 as steps to `timeCalculator`. Call `handler` that passed to `job` closure to affect timeout for next scheduled task. Scheduling new job, just after handler call - right way to plan next task. If next job schedulee erlier then `handler`'s call – it will be scheduled after previous timeout ignoring strategy that will be passed to handler. If next job schedules some times later after `handler`'s call, it will be scheduled after newly calculated TO, ignoring some time already passed since `handler`'s call.
///
/// - Warning: Tool isn't thread safe. Provided executor used only for delayed task executing and not for synchronising internal state. That why:
/// * Handler passed to job, should be called withing same queue as `scheduleNew` do.
/// * User may be sure, that passed job will be executed within executor passed to init.
///
public class SSJobPlanner: SSJobPlanning {
    class Task {
        var executor: SSTimeoutExecutor
        var canceled = false
        var job: () -> Void
        
        init(executor: SSTimeoutExecutor, job: @escaping () -> Void) {
            self.executor = executor
            self.job = job
        }
        
        func run(timeout: TimeInterval) {
            executor.executeAfter(sec: timeout) {[weak self] in
                if let canceled = self?.canceled, !canceled {
                    self?.job()
                }
            }
        }
        
        func cancel() {
            canceled = true
        }
    }
    public let timeCalculator: SSLimitedStepBasedTimeCalculating
    public let executor: SSTimeoutExecutor
    private var task: Task?
    private var step = 0
    private var timeout: TimeInterval
    
    public var scheduled: Bool { task != nil }
    
    public init(timeCalculator: SSLimitedStepBasedTimeCalculating, executor: SSTimeoutExecutor) {
        self.timeCalculator = timeCalculator
        self.executor = executor
        self.timeout = timeCalculator.timeBasedOn(step: step)
    }
    
    //MARK: - SSJobPlanning
    
    public func scheduleNew(job: @escaping ( @escaping (SSJobPlannerTOStrategy) -> Void ) -> Void) {
        task?.cancel()
        task = Task(executor: executor) {[weak self] in
            job() { result in
                self?.task = nil
                self?.process(result: result)
            }
        }
        task?.run(timeout: timeout)
    }
    
    //MARK: - private

    private func process(result: SSJobPlannerTOStrategy) {
        switch result {
        case .reset:
            step = 0
            timeout = timeCalculator.timeBasedOn(step: step)
        case .increase:
            step += 1
            timeout = timeCalculator.timeBasedOn(step: step)
        case .maximize:
            timeout = timeCalculator.maxTimeout
        case .ignore:
            break
        }
    }
}

