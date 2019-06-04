import XCTest

@testable import SSSugar

class SSSugarExtensionContainersArrayInitBuildBlockTests: XCTestCase {
    func testZeros() {
        let testable = [Int](size:5) { (idx) in return 0 }
        
        XCTAssertEqual(testable, [0, 0, 0, 0, 0])
    }
    
    func testIndexes() {
        let testable = [Int](size:5) { return $0 }
        
        XCTAssertEqual(testable, [0, 1, 2, 3, 4])
    }
    
    func testStringIndexes() {
        let testable = [String](size:5) { return String($0) }
        
        XCTAssertEqual(testable, ["0", "1", "2", "3", "4"])
    }
}
