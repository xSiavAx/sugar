import Foundation
import XCTest
import SSSugarTesting

@testable import SSSugarCore

/// Tests for `SSExponentialStepBasedTimeCalculator`
///
///
class SSExponentialStepBasedTimeCalculatorTests: XCTestCase {
    var sut: SSExponentialStepBasedTimeCalculator!
    
    //MARK: - cases
    
    //MARK: SSStepBasedTimeCalculating
    
    func testRegular() {
        sut = .init()
        
        (0...64).forEach() { step in
            check(step: step)
        }
    }
    
    //MARK: - private
    
    private func check(step: Int) {
        XCTAssertEqual(sut.timeBasedOn(step: step), .init(1 << step))
    }
}

