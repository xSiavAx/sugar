import XCTest

@testable import SSSugar

//subscript get. Получение контейнера по ключу. Получение контейнера по ключу которого нет.
//subscript set. subscript set. Перезапись. Перезапись пустым контейнером. Перезапись nil. Добавление. Добавление пустого. Добавление nil.

class SSSugarContainersAutoMapSubsriptTests: SSSugarContainersAutoMapTestsWithSetup {
    func testGetRegular() {
        XCTAssert(automapSet["key"] == values)
    }
    
    func testGetNotKey() {
        XCTAssert(automapSet["not_key"] == nil)
    }
    
    func testResetRegular() {
        let replaceSet = Set(arrayLiteral: 100, 200)
        let expectedResult = AutoMap(map:["evens" : evens, "odds" : odds, "key" : replaceSet])
        
        automapSet["key"] = replaceSet
        
        XCTAssertEqual(automapSet, expectedResult)
    }
    
    func testResetEmpty() {
//        automapSet["key"] = Set<Int>()
        //fatalError
    }
    
    func testResetNil() {
        let expectedResult = AutoMap(map:["evens" : evens, "odds" : odds])
        
        automapSet["key"] = nil
        
        XCTAssertEqual(automapSet, expectedResult)
    }
    
    func testSetRegular() {
        let values1 = Set(arrayLiteral: 100, 200)
        let expectedResult = AutoMap(map:["evens" : evens, "odds" : odds, "key" : values, "key1" : values1])
        
        automapSet["key1"] = values1
        
        XCTAssertEqual(automapSet, expectedResult)
    }
    
    func testSetEmpty() {
//        automapSet["key1"] = Set<Int>()
        //fatalError
    }
    
    func testSetNil() {
        let expectedResult = automapSet
        
        automapSet["key1"] = nil
        
        XCTAssertEqual(automapSet, expectedResult)
    }
}
