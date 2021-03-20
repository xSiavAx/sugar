/*
 Tests for pick(for:) Dictionary extension
 
 [Done] regular
 [Done] empty
 [Done] incorrect key
 [Done] single element Dictionary
 */

import XCTest
@testable import SSSugar

class DictionaryPickForTests: XCTestCase {
    typealias Key = DictionaryTestKey
    
    var sut: [Key: Int] = [:]
    
    override func setUp() {
        sut = Key.defaultDictionary
    }

    override func tearDown() {
        sut = [:]
    }
    
    func testRegular() {
        XCTAssertEqual(sut.pick(for: .two), Key.two.value)
        XCTAssertEqual(sut, [.one : Key.one.value, .three : Key.three.value])
    }

    func testEmpty() {
        sut = [:]
        
        XCTAssertNil(sut.pick(for: .one))
        XCTAssertEqual(sut, [:])
    }
    
    func testIncorrectKey() {
        XCTAssertNil(sut.pick(for: .incorrect))
        XCTAssertEqual(sut, Key.defaultDictionary)
    }
    
    func testSingleElementDictionary() {
        sut = [.one : Key.one.value]
        XCTAssertEqual(sut.pick(for: .one), Key.one.value)
        XCTAssertEqual(sut, [:])
    }
}
