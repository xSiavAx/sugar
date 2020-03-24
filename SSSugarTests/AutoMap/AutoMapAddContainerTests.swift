import XCTest

//    Добавление контейнера. В пустую карту. В непустую карту. В карту содержащую ключ.

@testable import SSSugar

class AutoMapAddContainerTests: XCTestCase {
    let testHelper = AutoMapTestHelper()
    
    func testAddToEmpty() {
        let insertion = testHelper.insertion
        let expectedResult = AutoMap(map: [insertion.key : insertion.set])
        var sut = AutoMap<String, Set<Int>>()
        
        XCTAssertTrue(sut.add(container: insertion.set, for: insertion.key))
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testAdd() {
        let insertion = testHelper.insertion
        let expectedMap = testHelper.makeSetMap(with: testHelper.mapItems + [insertion])
        let expectedResult = AutoMap(map: expectedMap)
        var sut = AutoMap(map: testHelper.makeSetMap())
        
        XCTAssertTrue(sut.add(container: insertion.set, for: insertion.key))
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testAddForExistingKey() {
        let expectedResult = AutoMap(map: testHelper.makeSetMap())
        var sut = AutoMap(map: testHelper.makeSetMap())
        
        XCTAssertFalse(sut.add(container: testHelper.insertion.set, for: testHelper.evens.key))
        XCTAssertEqual(sut, expectedResult)
    }
}
