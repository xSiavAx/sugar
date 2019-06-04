import XCTest

@testable import SSSugar

class SSSugarExtensionRangeMiddleTests: XCTestCase {
    func testMiddleDocExample1() {
        checkMiddle(0, 4, 2)
    }
    
    func testMiddleDocExample2() {
        checkMiddle(0, 5, 2)
    }
    
    func testMiddleDocExample3() {
        checkMiddle(2, 8, 5)
    }

    func testMiddleZeroEven() {
        checkMiddle(0, 6, 3)
    }
    
    func testMiddleZeroOdd() {
        checkMiddle(0, 9, 4)
    }
    
    func testMiddleEvenEven() {
        checkMiddle(4, 10, 7)
    }
    
    func testMiddleEvenOdd() {
        checkMiddle(4, 7, 5)
    }
    
    func testMiddleOddEven() {
        checkMiddle(5, 12, 8)
    }
    
    func testMiddleOddOdd() {
        checkMiddle(5, 12, 8)
    }
    
    func testMiddleEmpty() {
        checkMiddle(6, 6, 6)
    }
    
    func testMiddleNegativeEvenZero() {
        checkMiddle(-6, 0, -3)
    }
    
    func testMiddleNegativeOddZero() {
        checkMiddle(-9, 0, -4)
    }
    
    func testMiddleNegativeEvenEven() {
        checkMiddle(-10, -4, -7)
    }
    
    func testMiddleNegativeEvenOdd() {
        checkMiddle(-8, -3, -5)
    }
    
    func testMiddleNegativeOddEven() {
        checkMiddle(-11, -6, -8)
    }
    
    func testMiddleNegativeOddOdd() {
        checkMiddle(-11, -5, -8)
    }
    
    func testMiddleNegativeEmpty() {
        checkMiddle(-6, -6, -6)
    }
    
    func testMiddleNegativeEvenPositiveEven() {
        checkMiddle(-10, 4, -3)
    }
    
    func testMiddleNegativeEvenPositiveOdd() {
        checkMiddle(-8, 3, -2)
    }
    
    func testMiddleNegativeOddPositiveEven() {
        checkMiddle(-11, 6, -2)
    }
    
    func testMiddleNegativeOddPositiveOdd() {
        checkMiddle(-11, 5, -3)
    }
    
    func testMiddleZeroEmpty() {
        checkMiddle(0, 0, 0)
    }
    
    func checkMiddle(_ start:Int, _ end:Int, _ middle:Int) {
        XCTAssertEqual((start..<end).middle, middle)
    }
}
