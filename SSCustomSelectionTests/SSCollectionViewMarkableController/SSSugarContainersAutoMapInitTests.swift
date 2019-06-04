import XCTest

@testable import SSSugar
//С обычной кратой. С пустой картой. С картой с пустыми контейнерами.

class SSSugarContainersAutoMapInitTests: SSSugarContainersAutoMapTests {
    func testRegularMap() {
        let inititalizingMap = ["lol" : [1, 2, 3], "test" : [123, 672, 982], "1" : [0]]
        automapArr = AutoMap(map:inititalizingMap)
        
        checkWith(automapArr, inititalizingMap)
    }
    
    func testEmptyMap() {
        let inititalizingMap = [String : [Int]]()
        automapArr = AutoMap(map:inititalizingMap)
        
        checkWith(automapArr, inititalizingMap)
    }

    func testMapWithEmptyContainers() {
        let inititalizingMapSet = ["not_empty" : Set(arrayLiteral: 1, 2, 3), "empty" : Set()]
        let expectedMapSet = AutoMap(map:["not_empty" : Set(arrayLiteral: 1, 2, 3)])
        let inititalizingMapArr = ["not_empty" : [100], "empty" : []]
        let expectedMapArr = AutoMap(map:["not_empty" : [100]])
            
        automapSet = AutoMap(map:inititalizingMapSet)
        automapArr = AutoMap(map:inititalizingMapArr)
        
        XCTAssertEqual(automapSet, expectedMapSet)
        XCTAssertEqual(automapArr, expectedMapArr)
    }
}
