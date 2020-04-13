/*
 Tests for shuffle(using:type:), shuffled(using:type:) methods in Array extension

 [shuffle] shuffle(using:type:)
 [shuffled] shuffled(using:type:)
 [type] variants for the `type` argument that is passed to the method
    [built in] built in
    [durstenfeld] durstenfeld

 [Done] shuffle + built in type
 [Done] shuffle + durstenfeld type
 [Done] shuffled + built in type
 [Done] shuffled + durstenfeld type
 [Done] empty array
 */

import XCTest
@testable import SSSugar

class ArrayShuffleUsingTypeTests: XCTestCase {
    static let defaultArray = [0, 1, 2, 3, 4]

    var generator = SystemRandomNumberGenerator()
    var sut = ArrayShuffleUsingTypeTests.defaultArray

    func testShuffleBuiltInType() {
        sut.shuffle(using: &generator, type: .bultin)

        assertShuffleForDifferentElements(sut)
    }

    func testShuffleDurstenfeldType() {
        sut.shuffle(using: &generator, type: .durstenfeld)

        assertShuffleForDifferentElements(sut)
    }

    func testShuffledBuiltInType() {
        let result = sut.shuffled(using: &generator, type: .bultin)

        assertShuffleForDifferentElements(result)
        XCTAssertEqual(sut, Self.defaultArray)
    }

    func testShuffledDurstenfeldType() {
        let result = sut.shuffled(using: &generator, type: .durstenfeld)

        assertShuffleForDifferentElements(result)
        XCTAssertEqual(sut, Self.defaultArray)
    }

    func testEmptyArray() {
        sut = []
        sut.shuffle(using: &generator, type: .durstenfeld)

        XCTAssert(sut.isEmpty)
    }

    func assertShuffleForDifferentElements(_ firstArray: [Int], _ secondArray: [Int] = ArrayShuffleUsingTypeTests.defaultArray, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotEqual(firstArray, secondArray, "", file: file, line: line)
        XCTAssertEqual(firstArray.count, secondArray.count, "different number of elements", file: file, line: line)
        assertContainAllElements(firstArray, secondArray, file: file, line: line)
    }

    func assertContainAllElements(_ firstArray: [Int], _ secondArray: [Int], file: StaticString, line: UInt) {
        var secondArray = secondArray

        sut.forEach {
            guard let index = secondArray.firstIndex(of: $0) else {
                XCTFail("doesn't contain element \($0)", file: file, line: line)
                return
            }

            secondArray.remove(at: index)
        }
        XCTAssert(secondArray.isEmpty, "difference \(secondArray)", file: file, line: line)
    }
}
