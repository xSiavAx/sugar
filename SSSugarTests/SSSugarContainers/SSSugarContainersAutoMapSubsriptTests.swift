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
        let expectedMap = testHelper.makeSetMap(with: testHelper.replacedMapItems)
        let expectedResult = AutoMap(map: expectedMap)
        var sut = AutoMap(map: testHelper.makeSetMap())
        
        sut[testHelper.key.key] = testHelper.replace.set
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
        var sut = AutoMap(map: testHelper.makeSetMap())
        
        sut[testHelper.key.key] = nil
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testSetRegular() {
        let expectedMap = testHelper.makeSetMap(with: testHelper.mapItems + [testHelper.insertion])
        let expectedResult = AutoMap(map: expectedMap)
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
        var sut = AutoMap(map: testHelper.makeSetMap())
        
        sut["notIncludedKey"] = nil
        XCTAssertEqual(sut, expectedResult)
    }
}
