/*

 Tests for picking(for:) Dictionary extension
 
 [Done] regular
 [Done] empty
 [Done] incorrect key
 [Done] single element Dictionary

*/

import XCTest
@testable import SSSugar

class DictionaryPickingForTests: XCTestCase {
    
    typealias Key = DictionaryTestKey
    typealias Results = (dictionary: [Key: Int], value: Int)?
    
    var sut: [Key: Int] = [:]
    
    override func setUp() {
        sut = Key.defaultDictionary
    }
    
    override func tearDown() {
        sut = [:]
    }
    
    func testRegular() {
        let results: Results = sut.picking(for: .two)
        
        XCTAssertEqual(sut, Key.defaultDictionary)
        XCTAssertEqual(results?.value, Key.two.value)
        XCTAssertEqual(results?.dictionary, [.one : Key.one.value, .three : Key.three.value])
    }
    
    func testEmpty() {
        sut = [:]
        
        let results = sut.picking(for: .one)
        
        XCTAssertEqual(sut, [:])
        XCTAssertNil(results)
    }
    
    func testIncorrectKey() {
        let results: Results = sut.picking(for: .incorrect)
        
        XCTAssertEqual(sut, Key.defaultDictionary)
        XCTAssertNil(results)
    }
    
    func testSingleElementDictionary() {
        sut = [.one : Key.one.value]
        
        let results: Results = sut.picking(for: .one)
        
        XCTAssertEqual(sut, [Key.one : Key.one.value])
        XCTAssertEqual(results?.value, Key.one.value)
        XCTAssertEqual(results?.dictionary, [:])
    }
    
}
