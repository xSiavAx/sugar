import XCTest

@testable import SSSugar

class SSSugarExtensionContainersArrayInitUsingBlockTests: XCTestCase {
    func testZeros() {
        let testable = [Int](size:5) { (idx) in return 0 }
        
        XCTAssertEqual(testable, [0, 0, 0, 0, 0])
    }
    
    func testIndexes() {
        let testable = [Int](size:5) { return $0 }
        
        XCTAssertEqual(testable, [0, 1, 2, 3, 4])
    }
}
