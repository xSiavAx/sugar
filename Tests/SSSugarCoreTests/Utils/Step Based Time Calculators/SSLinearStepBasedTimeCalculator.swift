import Foundation
import XCTest
import SSSugarTesting

@testable import SSSugarCore

/// Tests for `SSLinearStepBasedTimeCalculator`
///
///
class SSLinearStepBasedTimeCalculatorTests: XCTestCase {
    var sut: SSLinearStepBasedTimeCalculator!
    
    //MARK: - cases
    
    //MARK: SSStepBasedTimeCalculating
    
    func testRegular() {
        check(timePerStep: 0.5)
        check(timePerStep: 1.0)
        check(timePerStep: 10.0)
    }
    
    //MARK: - private
    
    private func check(timePerStep: TimeInterval) {
        sut = .init(timePerStep: timePerStep)
        
        (0...100).forEach() { step in
            check(timePerStep: timePerStep, step: step)
        }
        
        (100_000...100_500).forEach() { step in
            check(timePerStep: timePerStep, step: step)
        }
    }
    
    private func check(timePerStep: TimeInterval, step: Int) {
        XCTAssertEqual(sut.timeBasedOn(step: step), Double(step) * timePerStep)
    }
}

