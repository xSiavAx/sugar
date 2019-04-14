import XCTest

class SSSugarExtensionContainersArrayForEachTests: XCTestCase {

    func test() {
        let arr = (0...10).map() { return $0 * 2 }
        var expectedIdx = 0;
        
        arr.forEach { (element, idx) in
            XCTAssertEqual(expectedIdx, idx)
            XCTAssertTrue(element == arr[idx])
            
            expectedIdx += 1
        }
    }
}
