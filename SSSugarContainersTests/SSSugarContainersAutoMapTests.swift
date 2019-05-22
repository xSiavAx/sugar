import XCTest

@testable import SSSugar

class SSSugarContainersAutoMapTests: XCTestCase {
    public var automap : AutoMap<String, Set<Int>>!
    
    override func setUp() {
         automap = AutoMap<String, Set<Int>>()
    }

    override func tearDown() {
        automap = nil
    }
    
    func checkWith(dict : [String : Set<Int>]) {
        XCTAssertEqual(automap.keys, dict.keys)
        
        for key in automap.keys {
            XCTAssertEqual(automap[key], dict[key])
        }
    }
}
