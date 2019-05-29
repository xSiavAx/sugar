import XCTest

@testable import SSSugar

class SSSugarContainersAutoMapTestsWithSetup: SSSugarContainersAutoMapTests {
    var evens : Set<Int>!
    var odds : Set<Int>!
    var values : Set<Int>!
    
    override func setUp() {
        evens = Set(arrayLiteral: 0, 2, 4)
        odds = Set(arrayLiteral: 1, 3, 5)
        values = Set(arrayLiteral: 0, 1, 2, 3)
        automapSet = AutoMap(map:["evens" : evens, "odds" : odds, "key" : values])
    }
}
