/*

 Tests for pick(at:) Array extension
 
 [Done] regular
 [Done] first element
 [Done] last element
 [fatalError] incorrect index

*/

//TODO: [Review] Pick from single element array

import XCTest

class SSSugarExtensionContainersArrayPickAtTests: XCTestCase {
    var sut = [0, 1, 2, 3, 4]

    override func tearDown() {
        sut = []
    }

    func testRegular() {
        //TODO: [Review] Dlon't use firstIndex(of:). Do less logic for tests condition.
        XCTAssertEqual(sut.pick(at: sut.firstIndex(of: 2)!), 2)
        XCTAssertEqual(sut, [0, 1, 3, 4])
    }
    
    func testFirstElement() {
        XCTAssertEqual(sut.pick(at: sut.startIndex), 0)
        XCTAssertEqual(sut, [1, 2, 3, 4])
    }
    
    func testLastElement() {
        XCTAssertEqual(sut.pick(at: sut.firstIndex(of: 4)!), 4)
        XCTAssertEqual(sut, [0, 1, 2, 3])
    }
}
