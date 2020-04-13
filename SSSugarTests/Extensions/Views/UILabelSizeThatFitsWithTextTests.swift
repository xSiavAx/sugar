/*
 Tests for sizeThatFits(_:withText:) method in UILabel extension
 
 [text] variations of the text that is passed as an argument to the method
    [empty] empty
    [space] space
    [tab] tab
    [word] word
    [sentence] sentence
    [two lines] two lines (text value contains one \n)
    [five lines] five lines (text value contains four \n)
    [eight lines] eight lines (text value contains seven \n)
 [size] variations of the sizes that is passed as an argument to the method
    variations of the size width
        [negative] -20
        [zero] 0
        [small] 100
        [medium] 200
        [large] 600
    variations of the size height
        [negative] -20
        [zero] 0
        [small] 100
        [medium] 200
        [large] 600
 
 [Done] empty text * size
 [Done] space text * size
 [Done] tab text * size
 [Done] word text * size
 [Done] sentence text * size
 [Done] two lines text * size
 [Done] five lines text * size
 [Done] eight lines text * size
 */

import XCTest
@testable import SSSugar

class UILabelSizeThatFitsWithText: XCTestCase {
    typealias Text = UILabelTestHelper.Text
    typealias LimitSize = UILabelTestHelper.LimitSize

    let sut = UILabel()
    
    func testEmptyText() {
        assertEqual(text: Text.empty, CGSize(width: 0, height: 20))
    }
    
    func testSpaceText() {
        assertEqual(text: Text.space, CGSize(width: 4.67333984375, height: 20))
    }
    
    func testTabText() {
        assertEqual(text: Text.tab, CGSize(width: 18.693359375, height: 20))
    }
    
    func testWordText() {
        assertEqual(text: Text.word, CGSize(width: 39.046875, height: 20))
    }
    
    func testSentence() {
        assertEqual(text: Text.sentence, CGSize(width: 361.42431640625, height: 20))
    }
    
    func testTwoLinesText() {
        assertEqual(text: Text.twoLines, CGSize(width: 182.02783203125, height: 40))
    }
    
    func testFiveLinesText() {
        assertEqual(text: Text.fiveLines, CGSize(width: 270.56396484375, height: 100))
    }
    
    func testEightLinesText() {
        assertEqual(text: Text.eightLines, CGSize(width: 336.20654296875, height: 160))
    }
    
    func assertEqual(text: String, _ expected: CGSize, file: StaticString = #file, line: UInt = #line) {
        for sizeToFit in LimitSize.all {
            XCTAssertEqual(sut.sizeThatFits(sizeToFit, withText: text), expected, "for size that fits: \(sizeToFit)", file: file, line: line)
        }
    }
}
