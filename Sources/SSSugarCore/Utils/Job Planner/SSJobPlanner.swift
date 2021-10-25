import Foundation

/// Isn't thread safe. Provided executors using only for delayed task executing.
/// Provided executor should be the same, as public method called within.
class SSJobPlanner: SSJobPlanning {
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
    let timeCalculator: LimitedStepBasedTimeCalculating
    let executor: SSTimeoutExecutor
    private var task: Task?
    private var step = 0
    private var timeout: TimeInterval
    
    var scheduled: Bool { task != nil }
    
    init(timeCalculator: LimitedStepBasedTimeCalculating, executor: SSTimeoutExecutor) {
        self.timeCalculator = timeCalculator
        self.executor = executor
        self.timeout = timeCalculator.timeBasedOn(step: step)
    }
    
    func scheduleNew(job: @escaping ( @escaping (SSJobPlannerTOStrategy) -> Void ) -> Void) {
        task?.cancel()
        task = Task(executor: executor) {[weak self] in
            job() { result in
                self?.executor.execute {
                    self?.task = nil
                    self?.process(result: result)
                }
            }
        }
        task?.run(timeout: timeout)
    }
    
    private func process(result: SSJobPlannerTOStrategy) {
        switch result {
        case .reset:
            step = 0
            timeout = 0
        case .increase:
            step += 1
            timeout = timeCalculator.timeBasedOn(step: step)
        case .maximize:
            step = 0
            timeout = timeCalculator.maxTimeout
        case .ignore:
            break
        }
    }
}

