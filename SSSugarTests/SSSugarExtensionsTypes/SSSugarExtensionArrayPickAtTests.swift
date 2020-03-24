/*

 Test Cases Array extension pick(at:)
 
 [Done] regular
 [Done] first element
 [Done] last element
 
 [fatalError] incorrect index

*/

import XCTest

class SSSugarExtensionArrayPickAtTests: XCTestCase {
    var sut = [0, 1, 2, 3, 4]

    override func tearDown() {
        sut = []
    }

    func testRegular() {
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
