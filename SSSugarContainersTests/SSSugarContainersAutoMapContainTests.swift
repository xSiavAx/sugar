import XCTest

@testable import SSSugar

//Содержание. В пустом контейнере, с нужным ключем без элемента, без нужного ключа с элементом, с нужным ключем с нужным элементом.

class SSSugarContainersAutoMapContainTests: SSSugarContainersAutoMapTests {
    func testEmpty() {
        automapSet = AutoMap(map: [String : Set<Int>]())
        
        XCTAssertFalse(automapSet.contains(0, for:"not_key"))
        XCTAssertFalse(automapSet.contains(1000, for:"120"))
    }
    
    func testKeyNotValue() {
        automapSet = AutoMap(map: ["key" : Set(arrayLiteral: 0, 2, 4)])
        
        XCTAssertFalse(automapSet.contains(1, for: "key"))
    }
    
    func testNotKeyButValue() {
        automapSet = AutoMap(map: ["key" : Set(arrayLiteral: 0, 2, 4)])
        
        XCTAssertFalse(automapSet.contains(0, for: "not_key"))
    }
    
    func testRegular() {
        automapSet = AutoMap(map: ["key" : Set(arrayLiteral: 0, 2, 4)])
        
        XCTAssertTrue(automapSet.contains(0, for: "key"))
        XCTAssertTrue(automapSet.contains(2, for: "key"))
        XCTAssertTrue(automapSet.contains(4, for: "key"))
    }
}
