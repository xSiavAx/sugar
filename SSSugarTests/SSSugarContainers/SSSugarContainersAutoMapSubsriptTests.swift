import XCTest

@testable import SSSugar

//subscript get. Получение контейнера по ключу. Получение контейнера по ключу которого нет.
//subscript set. subscript set. Перезапись. Перезапись пустым контейнером. Перезапись nil. Добавление. Добавление пустого. Добавление nil.

class SSSugarContainersAutoMapSubsriptTests: XCTestCase {
    let helper = SSSugarContainersAutoMapHelper()
    
    func testGetRegular() {
        let map = helper.setMap
        let key = helper.evens.key
        
        XCTAssert(AutoMap(map: map)[key] == map[key])
    }
    
    func testGetNotIncludedKey() {
        XCTAssert(AutoMap(map: helper.setMap)[helper.notIncludedKey] == nil)
    }
    
    func testResetRegular() {
        var map = helper.setMap
        let key = helper.evens.key
        map[key] = helper.replace.set
        let expectedResult = AutoMap(map: map)
        
        var sut = AutoMap(map: helper.setMap)
        sut[key] = helper.replace.set
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testResetEmpty() {
//        automapSet["key"] = Set<Int>()
        //fatalError
    }
    
    func testResetNil() {
        let expectedResult = AutoMap(map: [helper.evens.key : helper.evens.set, helper.odds.key : helper.odds.set])
        
        var sut = AutoMap(map: helper.setMap)
        sut[helper.key.key] = nil
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testSetRegular() {
        var expectedMap = helper.setMap
        expectedMap[helper.insertion.key] = helper.insertion.set
        let expectedResult = AutoMap(map: expectedMap)
        
        var sut = AutoMap(map: helper.setMap)
        sut[helper.insertion.key] = helper.insertion.set
        
        XCTAssertEqual(sut, expectedResult)
    }
    
    func testSetEmpty() {
//        automapSet["key1"] = Set<Int>()
        //fatalError
    }
    
    func testSetNil() {
        let expectedResult = AutoMap(map: helper.setMap)
        
        var sut = AutoMap(map: helper.setMap)
        sut[helper.notIncludedKey] = nil
        
        XCTAssertEqual(sut, expectedResult)
    }
}
