import XCTest

@testable import SSSugar

//subscript get. Получение контейнера по ключу. Получение контейнера по ключу которого нет.
//subscript set. subscript set. Перезапись. Перезапись пустым контейнером. Перезапись nil. Добавление. Добавление пустого. Добавление nil.

class SSSugarContainersAutoMapSubsriptTests: XCTestCase {
    let testHelper = SSSugarContainersAutoMapTestHelper()
    
    func testGetRegular() {
        let map = testHelper.makeSetMap()
        let key = testHelper.evens.key
        
        XCTAssert(AutoMap(map: map)[key] == map[key])
    }
    
    func testGetNotIncludedKey() {
        XCTAssert(AutoMap(map: testHelper.makeSetMap())["notIncludedKey"] == nil)
    }
    
    func testResetRegular() {
        //TODO: [Review] Don't mix
        var map = testHelper.makeSetMap()
        let key = testHelper.evens.key
        map[key] = testHelper.replace.set
        let expectedResult = AutoMap(map: map)
        
        var sut = AutoMap(map: testHelper.makeSetMap())
        sut[key] = testHelper.replace.set
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testResetEmpty() {
//        automapSet["key"] = Set<Int>()
        //fatalError
    }
    
    func testResetNil() {
        let expectedResult = AutoMap(map: [
            testHelper.evens.key : testHelper.evens.set,
            testHelper.odds.key : testHelper.odds.set
        ])
        //TODO: [Review] Redurant
        
        var sut = AutoMap(map: testHelper.makeSetMap())
        sut[testHelper.key.key] = nil
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testSetRegular() {
        //TODO: [Review] Don't mix
        var expectedMap = testHelper.makeSetMap()
        expectedMap[testHelper.insertion.key] = testHelper.insertion.set
        let expectedResult = AutoMap(map: expectedMap)
        //TODO: [Review] Redurant
        
        var sut = AutoMap(map: testHelper.makeSetMap())
        sut[testHelper.insertion.key] = testHelper.insertion.set
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testSetEmpty() {
//        automapSet["key1"] = Set<Int>()
        //fatalError
    }
    
    func testSetNil() {
        let expectedResult = AutoMap(map: testHelper.makeSetMap())
        //TODO: [Review] Don't mix, redurant
        
        var sut = AutoMap(map: testHelper.makeSetMap())
        sut["notIncludedKey"] = nil
        
        XCTAssertEqual(sut, expectedResult)
    }
}
