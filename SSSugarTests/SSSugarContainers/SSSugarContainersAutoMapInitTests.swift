import XCTest

@testable import SSSugar
//С обычной кратой. С пустой картой. С картой с пустыми контейнерами.

class SSSugarContainersAutoMapInitTests: XCTestCase {
    let helper = SSSugarContainersAutoMapHelper()
    
    func testRegularMap() {
        let sut = AutoMap(map: helper.arrayMap)
        
        helper.checkWith(sut, helper.arrayMap)
    }
    
    func testEmptyMap() {
        let initMap = [String : [Int]]()
        let sut = AutoMap(map: initMap)
        
        helper.checkWith(sut, initMap)
    }

    func testMapWithEmptySetContainer() {
        let initMap = [helper.evens.key : helper.evens.set, "empty" : Set()]
        let expectedMap = AutoMap(map: [helper.evens.key : helper.evens.set])
            
        let sut = AutoMap(map: initMap)
        
        XCTAssertEqual(sut, expectedMap)
    }
    
    func testMapWithEmptyArrayContainer() {
        let initMap = [helper.evens.key : helper.evens.array, "empty" : []]
        let expectedMap = AutoMap(map:[helper.evens.key : helper.evens.array])
        
        let sut = AutoMap(map: initMap)
        
        XCTAssertEqual(sut, expectedMap)
    }
}
