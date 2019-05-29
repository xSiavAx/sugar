import XCTest

//    Добавление контейнера. В пустую карту. В непустую карту. В карту содержащую ключ.

@testable import SSSugar

class SSSugarContainersAutoMapAddContainerTests: SSSugarContainersAutoMapTestsWithSetup {
    func testAddToEmpty() {
        let insertionSet = Set(arrayLiteral: 1, 2, 3)
        let expectedResult = AutoMap(map: ["key" : insertionSet])
        
        automapSet = AutoMap<String, Set<Int>>()
        
        let result = automapSet.add(container: insertionSet, for: "key")
        
        XCTAssertEqual(automapSet, expectedResult)
        XCTAssertTrue(result)
    }
    
    func testAdd() {
        let insertionSet = Set(arrayLiteral: 1, 2, 3)
        let expectedResult = AutoMap(map: ["evens" : evens, "odds" : odds, "key" : values, "key1" : insertionSet])
        let result = automapSet.add(container: insertionSet, for: "key1")
        
        XCTAssertEqual(automapSet, expectedResult)
        XCTAssertTrue(result)
    }
    
    func testAddForExistingKey() {
        let insertionSet = Set(arrayLiteral: 1, 2, 3)
        let expectedResult = automapSet
        let result = automapSet.add(container: insertionSet, for: "key")
        
        XCTAssertEqual(automapSet, expectedResult)
        XCTAssertFalse(result)
    }
}
