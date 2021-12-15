import Foundation
import XCTest

@testable import SSSugarCore

class SSStepBasedLimitedTimeCaculatorBuilderTests: XCTestCase {
    var sut: SSStepBasedLimitedTimeCaculatorBuilder!
    
    override func setUp() {
        sut = .init()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testDefault() {
        check(level: 0, baseTo: 0, maxTo: .infinity, timePerStep: 42)
    }
    
    func testChanged() {
        sut.setIgnoreLevel(12)
            .setMaxTimeout(100500)
            .setBaseTimeout(100000)
        check(level: 12, baseTo: 100000, maxTo: 100500, timePerStep: 99)
    }
    
    func testOverrided() {
        sut.setIgnoreLevel(100)
            .setMaxTimeout(100)
            .setBaseTimeout(100)
            .setIgnoreLevel(80)
            .setMaxTimeout(42)
            .setBaseTimeout(10012)
            .setIgnoreLevel(12)
            .setMaxTimeout(100500)
            .setBaseTimeout(100000)
        check(level: 12, baseTo: 100000, maxTo: 100500, timePerStep: 99)
    }
    
    
    private func check(level: Int, baseTo: TimeInterval, maxTo: TimeInterval, timePerStep: TimeInterval) {
        let linear = sut.linear(timePerStep: timePerStep)
        let linearDef = sut.linear()
        let exponential = sut.exponential()
        let subLinear = linear.subCalculator as! SSLinearStepBasedTimeCalculator
        let subLinearDef = linearDef.subCalculator as! SSLinearStepBasedTimeCalculator
        let _ = exponential.subCalculator as! SSExponentialStepBasedTimeCalculator
        
        checkChildBased(calculator: linear, level: level, baseTo: baseTo, maxTo: maxTo)
        checkChildBased(calculator: linearDef, level: level, baseTo: baseTo, maxTo: maxTo)
        checkChildBased(calculator: exponential, level: level, baseTo: baseTo, maxTo: maxTo)
        
        XCTAssertEqual(subLinear.timePerStep, timePerStep)
        XCTAssertEqual(subLinearDef.timePerStep, 0)
    }
    
    private func checkChildBased(calculator: SSChildBasedLimitedTimeCalculator, level: Int, baseTo: TimeInterval, maxTo: TimeInterval) {
        XCTAssertEqual(calculator.baseTimeout, baseTo)
        XCTAssertEqual(calculator.ignoreLevel, level)
        XCTAssertEqual(calculator.maxTimeout, maxTo)
    }
}
