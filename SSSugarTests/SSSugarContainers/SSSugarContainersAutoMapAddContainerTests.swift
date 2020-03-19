import XCTest

//    Добавление контейнера. В пустую карту. В непустую карту. В карту содержащую ключ.

@testable import SSSugar

class SSSugarContainersAutoMapAddContainerTests: XCTestCase {
    let testHelper = SSSugarContainersAutoMapTestHelper()
    
    func testAddToEmpty() {
        let insertion = testHelper.insertion
        let expectedResult = AutoMap(map: [insertion.key : insertion.set])
        
        var sut = AutoMap<String, Set<Int>>()
        let result = sut.add(container: insertion.set, for: insertion.key)
        
        XCTAssertEqual(sut, expectedResult)
        XCTAssertTrue(result)
    }
    
    func testAdd() {
        let insertion = testHelper.insertion
        var expectedMap = testHelper.makeSetMap()
        expectedMap[insertion.key] = insertion.set
        let expectedResult = AutoMap(map: expectedMap)
        
        var sut = AutoMap(map: testHelper.makeSetMap())
        let result = sut.add(container: insertion.set, for: insertion.key)
        
        XCTAssertEqual(sut, expectedResult)
        XCTAssertTrue(result)
    }
    
    func testAddForExistingKey() {
        let expectedResult = AutoMap(map: testHelper.makeSetMap())
        
        var sut = AutoMap(map: testHelper.makeSetMap())
        let result = sut.add(container: testHelper.insertion.set, for: testHelper.evens.key)
        
        XCTAssertEqual(sut, expectedResult)
        XCTAssertFalse(result)
    }
}
