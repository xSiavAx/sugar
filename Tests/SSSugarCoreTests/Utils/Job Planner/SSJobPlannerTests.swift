import Foundation
import XCTest
import SSSugarTesting

@testable import SSSugarCore

/// Tests for `SSJobPlanner`
///
/// # Cases:
///
/// __SSJobPlanning:__
/// * _scheduleNewRegular_ - EEA, block, EE
/// * _scheduleOneByOne_ - two regular cases one after onother
/// * _resultIncrease_ - several regulars with increase result + timeBasedOnStep with rised step,
/// * _resultReset_ - several regulars with increase result, then one with reset
/// * _resultIgnore_ - several regulars with increase result, then one with ignore, then increase again (ensure iggnore doesn't affect step)
/// * _resultMaximize_ - several regulars with increase result, then one with maximize (ensure time is max), then increase again (ensure maximize doesn't affect step)
/// * _scheduleIfNotScheduledRegular_ - as regular
/// * _scheduleIfNotScheduledScheduled_ - nothing happens
///
class SSJobPlannerTests: XCTestCase {
    //TODO: There are some bugs, fix me (particullary in `testReschedule`, ...)
    static let initalTO = 12.0
    static let maxTO = 100500.0
    
    var calculator: SSStepBasedTimeCalculatingMock!
    var executor: SSExecutorMock!
    var onFinish: SSCallMock!
    var sut: SSJobPlanner!
    
    override func setUp() {
        super.setUp()
        
        initialiseMocks()
        
        calculator.expectCall(steps: 0, result: Self.initalTO)
        sut = .init(timeCalculator: calculator, executor: executor)
    }
    
    override func tearDown() {
        super.tearDown()
        
        verifyMocks()
        nulifyMocks()
        
        sut = nil
    }
    
    //MARK: - cases
    
    //MARK: SSJobPlanning
    
    // EEA, block, EE
    func testScheduleNewRegular() {
        stageRegular()
    }

    // two regular cases one after onother
    func testScheduleOneByOne() {
        stageRegular()
        stageRegular()
    }

    // several regulars with increase result + timeBasedOnStep with rised step,
    func testResultIncrease() {
        let (step, to) = stageIncrease(times: 3)
        
        stageIncrease(step: step, times: 5, to: to)
    }

    // several regulars with increase result, then one with reset
    func testResultReset() {
        let (_, to) = stageIncrease(times: 3)
        
        stageRegular(to: to, strategy: .reset, calcConfig: .calculate(steps: 0, to: Self.initalTO))
        
        stageIncrease(times: 3)
    }

    // several regulars with increase result, then one with ignore, then increase again (ensure iggnore doesn't affect step)
    func testResultIgnore() {
        let (steps, to) = stageIncrease(times: 3)
        
        stageRegular(to: to, strategy: .ignore)
        stageIncrease(step: steps, times: 5, to: to)
    }

    // several regulars with increase result, then one with maximize (ensure time is max), then increase again (ensure maximize doesn't affect step)
    func testResultMaximize() {
        let (steps, to) = stageIncrease(times: 3)
        
        stageRegular(to: to, strategy: .maximize, calcConfig: .maximize(to: Self.maxTO))
        stageRegular(to: Self.maxTO, strategy: .increase, calcConfig: .calculate(steps: steps, to: to))
    }

    // First scheduled task canceled (not finished) by scheduling new one, that executes as regular
    func testReschedule() {
        let call = executor.expectAfter(interval: Self.initalTO, strategy: .future)
        
        wait(count: 2) { exp in
            configSchedule().andAsync {
                call.doFutures()
                exp.fulfill()
            }
            sut.scheduleNew() { _ in XCTFail() }
            runSchedule(strategy: .ignore, exp: exp)
        }
    }
    
    func testScheduleIfNotScheduledRegular() {
        let call = configSchedule(delayed: true)
        wait() { exp in
            DispatchQueue.bg.async {
                self.sut.scheduleIfNotScheduled() { handler in
                    self.onFinish.handle() as Void
                    handler(.ignore)
                    exp.fulfill()
                }
                DispatchQueue.bg.async {
                    call.doFutures()
                }
            }
        }
    }
    
    func testScheduleIfNotScheduledScheduled() {
        let call = configSchedule(delayed: true)
        
        wait() { exp in
            runSchedule(strategy: .ignore, exp: exp)
            DispatchQueue.bg.async {
                self.sut.scheduleIfNotScheduled() { _ in XCTFail() }
            }
            DispatchQueue.bg.async {
                call.doFutures()
            }
        }
    }
    
    //MARK: - private
    
    private func checkSchedule(strategy: SSJobPlannerTOStrategy = .ignore) {
        wait() { exp in
            runSchedule(strategy: strategy, exp: exp)
        }
    }
    
    private func runSchedule(strategy: SSJobPlannerTOStrategy, exp: XCTestExpectation) {
        DispatchQueue.bg.execute {
            self.sut.scheduleNew { handler in
                self.onFinish.handle() as Void
                handler(strategy)
                exp.fulfill()
            }
        }
    }
    
    //MARK: Stages
    
    private func stageRegular(to: TimeInterval = initalTO,
                              strategy: SSJobPlannerTOStrategy = .ignore,
                              calcConfig: CalculatorConfig? = nil) {
        configSchedule(to: to, calcConfig: calcConfig)
        checkSchedule(strategy: strategy)
    }
    
    @discardableResult
    private func stageIncrease(step: Int = 1, times: Int = 5, to: TimeInterval = initalTO) -> (Int, TimeInterval) {
        var to = to
        let limit = step + times

        (step..<limit).forEach { step in
            let nextTo = to + 10
            
            stageRegular(to: to, strategy: .increase, calcConfig: .calculate(steps: step, to: nextTo))
            to = nextTo
        }
        return (limit, to)
    }
    
    //MARK: Expectation config
    
    @discardableResult
    private func configSchedule(to: TimeInterval = initalTO, calcConfig: CalculatorConfig? = nil, delayed: Bool = false) -> SSMockCallExpectation {
        let call = executor.expectAfter(interval: to, delay: delayed)
        onFinish.expectCall()
        
        switch calcConfig {
        case .calculate(let steps, let to):
            calculator.expectCall(steps: steps, result: to)
        case .maximize(let to):
            calculator.expectMaxTimeout(to)
        case .none:
            break
        }
        return call
    }
    
    //MARK: Mocks managing
    
    private func initialiseMocks() {
        calculator = .init()
        executor = .init()
        onFinish = .init()
    }
    
    private func verifyMocks() {
        calculator.verify()
        executor.verify()
        onFinish.verify()
    }
    
    private func nulifyMocks() {
        calculator = nil
        executor = nil
        onFinish = nil
    }
    
    //MARK: - Helper
    
    enum CalculatorConfig {
        case calculate(steps: Int, to: TimeInterval)
        case maximize(to: TimeInterval)
    }
}

