import XCTest

@testable import SSSugar

//Содержание. В пустом контейнере, с нужным ключем без элемента, без нужного ключа с элементом, с нужным ключем с нужным элементом.

class AutoMapContainTests: XCTestCase {
    let testHelper = AutoMapTestHelper()
    
    func testEmpty() {
        let sut = AutoMap(map: [String : Set<Int>]())
        
        XCTAssertFalse(sut.contains(0, for: "not_key"))
        XCTAssertFalse(sut.contains(1000, for: "120"))
    }
    
    func testKeyNotValue() {
        let key = testHelper.evens.key
        let sut = AutoMap(map: [key : testHelper.evens.set])
        
        XCTAssertFalse(sut.contains(1, for: key))
    }
    
    func testNotKeyButValue() {
        let sut = AutoMap(map: [testHelper.evens.key : testHelper.evens.set])
        
        XCTAssertFalse(sut.contains(0, for: "not_key"))
    }
    
    func testRegular() {
        let key = testHelper.evens.key
        let sut = AutoMap(map: [key : testHelper.evens.set])
        
        XCTAssertTrue(sut.contains(0, for: key))
        XCTAssertTrue(sut.contains(2, for: key))
        XCTAssertTrue(sut.contains(4, for: key))
    }
}
