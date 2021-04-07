import XCTest
@testable import SSSugarCore

class ArrayBinarySearchTests: XCTestCase {
    func testFirstPos() {
        let arr = evens(size: 10)
        
        XCTAssertEqual(arr.binarySearch(0), 0)
    }
    
    func testInsertFirstPos() {
        let arr = odds(size: 10)

        XCTAssertEqual(arr.binarySearch(forInsert:0), 0)
    }
    
    func testInsertSameFirstPos() {
        let arr = evens(size: 10)
        let expectedResults = [0, 1]
        let result = arr.binarySearch(forInsert:0)
        
        XCTAssertTrue(expectedResults.contains(result))
    }
    
    func testLastPos() {
        let arr = evens(size: 5)
        
        XCTAssertEqual(arr.binarySearch(8), 4)
    }
    
    func testInsertLastPos() {
        let arr = odds(size: 5)
        
        XCTAssertEqual(arr.binarySearch(forInsert:10), 5)
    }
    
    func testInsertSameLastPos() {
        let arr = evens(size: 5)
        let expectedResults = [4, 5]
        let result = arr.binarySearch(forInsert:10)
        
        XCTAssertTrue(expectedResults.contains(result))
    }
    
    func testMidPos() {
        let arr = ints(size: 5)
        
        XCTAssertEqual(arr.binarySearch(2), 2)
    }
    
    func testInsertMidPos() {
        let arr = evens(size: 4)
        
        XCTAssertEqual(arr.binarySearch(forInsert:3), 2)
    }
    
    func testInsertSameMidPos() {
        let arr = ints(size: 5)
        let expectedResults = [2, 3]
        let result = arr.binarySearch(forInsert:2)
        
        XCTAssertTrue(expectedResults.contains(result))
    }
    
    func testEmpty() {
        XCTAssertNil([].binarySearch(1))
    }
    
    func testInsertEmpty() {
        XCTAssertEqual([].binarySearch(forInsert:1), 0)
    }
    
    func testNotFound() {
        XCTAssertNil(evens(size: 100).binarySearch(1))
    }
    
    func testSames2() {
        checkSames(sequenceLength: 2)
    }
    
    func testSames3() {
        checkSames(sequenceLength: 2)
    }
    
    func testSames4() {
        checkSames(sequenceLength: 4)
    }
    
    func testSames5() {
        checkSames(sequenceLength: 5)
    }
    
    func testSames10() {
        checkSames(sequenceLength: 10)
    }
    
    func testInsertSameTOSames2() {
        checkInsertSameToSames(sequenceLength: 2)
    }
    
    func testInsertSameTOSames3() {
        checkInsertSameToSames(sequenceLength: 3)
    }
    
    func testInsertSameTOSames4() {
        checkInsertSameToSames(sequenceLength: 4)
    }
    
    func testInsertSameTOSames5() {
        checkInsertSameToSames(sequenceLength: 5)
    }
    
    func testInsertSameTOSames10() {
        checkInsertSameToSames(sequenceLength: 10)
    }
    
    func testInsertLeftOfSames() {
        let arr = ints(size: 4) + sames(size: 4, element: 5) + ints(size: 5, start: 7)
        
        XCTAssertEqual(arr.binarySearch(forInsert:4), 4)
    }
    
    func testInsertRightOfSames() {
        let arr = ints(size: 4) + sames(size: 4, element: 5) + ints(size: 5, start: 7)
        
        XCTAssertEqual(arr.binarySearch(forInsert:6), 8)
    }
    
    func checkSames(sequenceLength: Int) {
        let arr = ints(size: 5) + sames(size: sequenceLength, element: 5) + ints(size: 5, start: 6)
        let expextedResults = ints(size: sequenceLength, start: 5)
        let result = arr.binarySearch(5)!
        
        XCTAssertTrue(expextedResults.contains(result))
    }
    
    func checkInsertSameToSames(sequenceLength: Int) {
        let arr = ints(size: 5) + sames(size: sequenceLength, element: 5) + ints(size: 5, start: 6)
        let expextedResults = ints(size: sequenceLength+1, start: 5)
        let result = arr.binarySearch(forInsert:5)
        
        XCTAssertTrue(expextedResults.contains(result))
    }
    
    func evens(size: Int) -> [Int] {
        return Array.init(size: size) { return 2*$0 }
    }
    
    func odds(size: Int) -> [Int] {
        return Array.init(size: size) { return 2*$0+1 }
    }
    
    func sames(size: Int, element: Int = 1) -> [Int] {
        return Array.init(size: size, buildBlock: { (idx) -> (Int) in
            return element
        })
    }
    
    func ints(size: Int, start: Int = 0) -> [Int] {
        return (start..<start+size).map() { return $0 }
    }
}
