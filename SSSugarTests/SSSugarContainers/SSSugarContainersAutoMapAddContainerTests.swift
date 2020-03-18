import XCTest

//    Добавление контейнера. В пустую карту. В непустую карту. В карту содержащую ключ.

@testable import SSSugar

class SSSugarContainersAutoMapAddContainerTests: XCTestCase {
    let helper = SSSugarContainersAutoMapHelper()
    
    func testAddToEmpty() {
        let insertion = helper.insertion
        let expectedResult = AutoMap(map: [insertion.key : insertion.set])
        
        var sut = AutoMap<String, Set<Int>>()
        let result = sut.add(container: insertion.set, for: insertion.key)
        
        XCTAssertEqual(sut, expectedResult)
        XCTAssertTrue(result)
    }
    
    func testAdd() {
        let insertion = helper.insertion
        var expectedMap = helper.setMap
        expectedMap[insertion.key] = insertion.set
        let expectedResult = AutoMap(map: expectedMap)
        
        var sut = AutoMap(map: helper.setMap)
        let result = sut.add(container: insertion.set, for: insertion.key)
        
        XCTAssertEqual(sut, expectedResult)
        XCTAssertTrue(result)
    }
    
    func testAddForExistingKey() {
        let expectedResult = AutoMap(map: helper.setMap)
        
        var sut = AutoMap(map: helper.setMap)
        let result = sut.add(container: helper.insertion.set, for: helper.evens.key)
        
        XCTAssertEqual(sut, expectedResult)
        XCTAssertFalse(result)
    }
}
