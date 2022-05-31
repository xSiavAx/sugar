/*
 Tests for shuffle(using:type:), shuffled(using:type:) methods in Array extension

 [shuffle] shuffle(using:type:)
 [shuffled] shuffled(using:type:)
 variants for the `type` argument that is passed to the method
    [built-in] built-in
    [durstenfeld] durstenfeld

 [Done] shuffle + built-in
 [Done] shuffle + durstenfeld
 [Done] shuffled + built-in
 [Done] shuffled + durstenfeld
 [Done] empty array
 */

import XCTest
@testable import SSSugarCore

class ArrayShuffleUsingTypeTests: XCTestCase {
    static let defaultArray = [0, 1, 2, 3]

	fileprivate var generator = ConstantNumberGenerator()
	var expectedResult: (durstenfeld: [Int], builtIn: [Int]) {
		// The expected result of the built-in shuffle is calculated because its algorithm may change. For more details check Array.shuffled(using:) documentation.
		([1, 3, 0, 2], Self.defaultArray.shuffled(using: &generator))
	}
	var sut = defaultArray

    func testShuffleBuiltInType() {
        sut.shuffle(using: &generator, type: .bultin)
		XCTAssertEqual(sut, expectedResult.builtIn)
    }

    func testShuffleDurstenfeldType() {
        sut.shuffle(using: &generator, type: .durstenfeld)
		XCTAssertEqual(sut, expectedResult.durstenfeld)
    }

    func testShuffledBuiltInType() {
        let result = sut.shuffled(using: &generator, type: .bultin)

		XCTAssertEqual(result, expectedResult.builtIn)
        XCTAssertEqual(sut, Self.defaultArray)
    }

    func testShuffledDurstenfeldType() {
        let result = sut.shuffled(using: &generator, type: .durstenfeld)

		XCTAssertEqual(result, expectedResult.durstenfeld)
        XCTAssertEqual(sut, Self.defaultArray)
    }

    func testEmptyArray() {
        sut = []
        sut.shuffle(using: &generator, type: .durstenfeld)

        XCTAssert(sut.isEmpty)
    }
}

fileprivate struct ConstantNumberGenerator: RandomNumberGenerator {
	func next() -> UInt64 { 42 }
}
