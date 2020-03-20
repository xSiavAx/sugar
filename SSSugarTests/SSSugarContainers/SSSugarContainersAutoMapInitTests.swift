import XCTest

@testable import SSSugar
//С обычной кратой. С пустой картой. С картой с пустыми контейнерами.

class SSSugarContainersAutoMapInitTests: XCTestCase {
    let testHelper = SSSugarContainersAutoMapTestHelper()
    
    func testRegularMap() {
        let sut = AutoMap(map: testHelper.makeArrayMap())
        
        testHelper.checkWith(sut, testHelper.makeArrayMap())
    }
    
    func testEmptyMap() {
        let initMap = [String : [Int]]()
        let sut = AutoMap(map: initMap)
        
        testHelper.checkWith(sut, initMap)
    }

    func testMapWithEmptySetContainer() {
        let initMap = [testHelper.evens.key : testHelper.evens.set, "empty" : Set()]
        let expectedMap = AutoMap(map: [testHelper.evens.key : testHelper.evens.set])
        let sut = AutoMap(map: initMap)
        
        XCTAssertEqual(sut, expectedMap)
    }
    
    func testMapWithEmptyArrayContainer() {
        let initMap = [testHelper.evens.key : testHelper.evens.array, "empty" : []]
        let expectedMap = AutoMap(map:[testHelper.evens.key : testHelper.evens.array])
        let sut = AutoMap(map: initMap)
        
        XCTAssertEqual(sut, expectedMap)
    }
}
