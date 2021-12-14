import Foundation
import XCTest
import SSSugarTesting

@testable import SSSugarCore

/// Tests for `SSExponentialStepBasedTimeCalculator`
///
/// # Cases:
///
/// __SSJobPlanning:__
/// * _ignore_ - returns 0 for steps lower then ignore level
/// * _regular_ - returns baseTo + result of subCalculator
/// * _maximum_ - returns maxTO when result of subCalculator is bigger (then maxTO)
///
class SSChildBasedLimitedTimeCalculatorTests: XCTestCase {
    var subCulculator: SSStepBasedTimeCalculatingMock!
    var sut: SSChildBasedLimitedTimeCalculator!
    
    override func setUp() {
        subCulculator = .init()
    }
    
    override func tearDown() {
        subCulculator.verify()
        subCulculator = nil
    }
    
    //MARK: - cases
    
    //MARK: SSStepBasedTimeCalculating
    
    func testIgnore() {
        func check(level: Int) {
            sut = .init(baseTimeout: 0, maxTimeout: 100500, ignoreLevel: level, subCaculator: subCulculator)
            
            (0..<level).forEach() { step in
                XCTAssertEqual(sut.timeBasedOn(step: step), 0)
            }
            let time = Double((0...100500).randomElement()!)
            
            subCulculator.expectCall(steps: 0, result: time)
            XCTAssertEqual(sut.timeBasedOn(step: level), time)
        }
        [0, 100, 100500].forEach() { check(level: $0) }
    }
    
    func testRegular() {
        let baseTO = 100.0
        let maxTO = 100500.0
        let ignoreLevel = 12
        
        sut = .init(baseTimeout: baseTO, maxTimeout: maxTO, ignoreLevel: ignoreLevel, subCaculator: subCulculator)
        
        (12...10500).forEach() { step in
            let time = Double((1...Int(maxTO - baseTO)).randomElement()!)
            
            subCulculator.expectCall(steps: step - ignoreLevel, result: time)
            let result = sut.timeBasedOn(step: step)
            
            XCTAssertEqual(result, baseTO + time)
        }
    }
    
    func testMaximum() {
        func check(max: TimeInterval) {
            (0..<10_000).forEach() { addon in
                let ignoreLevel = 100
                sut = .init(baseTimeout: 500, maxTimeout: max, ignoreLevel: ignoreLevel, subCaculator: subCulculator)
                let step = (100...100500).randomElement()!
                let time = max + Double(addon)
                
                subCulculator.expectCall(steps: step - ignoreLevel, result: time)
                
                let result = sut.timeBasedOn(step: step)
                
                XCTAssertEqual(result, max)
            }
        }
        [10, 64.4, 100.500, 100500].forEach() {
            check(max: $0)
        }
    }
    
    //MARK: - private
    
    private func check(step: Int) {
        XCTAssertEqual(sut.timeBasedOn(step: step), .init(1 << step))
    }
}

