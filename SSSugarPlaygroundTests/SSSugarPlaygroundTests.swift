import XCTest
import Foundation

@testable import SSSugar

class SSSugarPlaygroundTests: XCTestCase {
    func testMain() {
        var am = AutoMap<String, [Int]>()

        
        am.add(key: "lol", 1)
        am.add(key: "lol", 1)
        am.add(key: "lol", 3)
        
        am.add(key: "test", 2)
        am.add(key: "test", 3)
        
        am["test", 0] = 5
        am["test", 2] = nil
        
        for (key, container, val) in am {
            print("\(key) : \(container) [\(val)]")
        }
        
        print(am)
    }
    
    func testSecond() {
        var am = AutoMap<String, Set<Int>>()
        
        am.add(key: "lol", 1)
        am.add(key: "lol", 1)
        am.add(key: "lol", 3)
        
        am.add(key: "test", 2)

        
        print(am)
    }
}
