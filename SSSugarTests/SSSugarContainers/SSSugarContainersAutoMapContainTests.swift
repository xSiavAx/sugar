import XCTest

@testable import SSSugar

//Содержание. В пустом контейнере, с нужным ключем без элемента, без нужного ключа с элементом, с нужным ключем с нужным элементом.

class SSSugarContainersAutoMapContainTests: XCTestCase {
    func testEmpty() {
        let sut = AutoMap(map: [String : Set<Int>]())
        
        XCTAssertFalse(sut.contains(0, for: "not_key"))
        XCTAssertFalse(sut.contains(1000, for: "120"))
    }
    
    func testKeyNotValue() {
        let sut = AutoMap(map: ["key" : Set(arrayLiteral: 0, 2, 4)])
        
        XCTAssertFalse(sut.contains(1, for: "key"))
    }
    
    func testNotKeyButValue() {
        let sut = AutoMap(map: ["key" : Set(arrayLiteral: 0, 2, 4)])
        
        XCTAssertFalse(sut.contains(0, for: "not_key"))
    }
    
    func testRegular() {
        let sut = AutoMap(map: ["key" : Set(arrayLiteral: 0, 2, 4)])
        
        XCTAssertTrue(sut.contains(0, for: "key"))
        XCTAssertTrue(sut.contains(2, for: "key"))
        XCTAssertTrue(sut.contains(4, for: "key"))
    }
}
