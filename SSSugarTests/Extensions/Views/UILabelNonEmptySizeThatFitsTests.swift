/*
 Tests for nonEmptySizeThatFits(_:) method in UILabel extension
 
 [text] options of the text in UILabel object to which the method is applied
    [nil] nil
    [empty] empty
    [space] space
    [tab] tab
    [word] word
    [sentence] sentence
    [two lines] two lines (text value contains one \n)
    [five lines] five lines (text value contains four \n)
    [eight lines] eight lines (text value contains seven \n)
 [number of lines] variations of the number of lines property in UILabel object to which the method is applied
    [one] one
    [two] two
    [five] five
    [zero] zero
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
 
 [Done] nil text * number of lines * size
 [Done] empty text * number of lines * size
 [Done] space text * number of lines * size
 [Done] tab text * number of lines * size
 [Done] word text * number of lines * size
 [Done] (sentence text + one number of lines) * size
 [Done] (sentence text + two number of lines) * size
 [Done] (sentence text + five number of lines) * size
 [Done] (sentence text + zero number of lines) * size
 [Done] (two lines text + one number of lines) * size
 [Done] (two lines text + two number of lines) * size
 [Done] (two lines text + five number of lines) * size
 [Done] (two lines text + zero number of lines) * size
 [Done] (five lines text + one number of lines) * size
 [Done] (five lines text + two number of lines) * size
 [Done] (five lines text + five number of lines) * size
 [Done] (five lines text + zero number of lines) * size
 [Done] (eight lines text + one number of lines) * size
 [Done] (eight lines text + two number of lines) * size
 [Done] (eight lines text + five number of lines) * size
 [Done] (eight lines text + zero number of lines) * size
 */

import XCTest
@testable import SSSugar

class UILabelNonEmptySizeThatFitsTests: XCTestCase {
    typealias Text = UILabelTestHelper.Text
    typealias LimitSize = UILabelTestHelper.LimitSize

    let numbersOfLines = [0, 1, 2, 5]
    let sut = UILabel()
    
    func testNilText() {
        forEachNumberOfLines(numbersOfLines) {
            assertEqual(CGSize(width: 4.67333984375, height: 20))
        }
    }
    
    func testEmptyText() {
        sut.text = Text.empty
        forEachNumberOfLines(numbersOfLines) {
            assertEqual(CGSize(width: 4.67333984375, height: 20))
        }
    }
    
    func testSpaceText() {
        sut.text = Text.space
        forEachNumberOfLines(numbersOfLines) {
            assertEqual(CGSize(width: 5, height: 20))
        }
    }
    
    func testTabText() {
        sut.text = Text.tab
        forEachNumberOfLines(numbersOfLines) {
            assertEqual(CGSize(width: 19, height: 20))
        }
    }
    
    func testWordText() {
        sut.text = Text.word
        forEachNumberOfLines(numbersOfLines) {
            assertEqual(CGSize(width: 39.5, height: 20))
        }
    }
    
    func testSentenceTextOneNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 1
        
        assertEqual(CGSize(width: 361.5, height: 20))
    }
    
    func testSentenceTextTwoNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 2
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 98, height: 40))
        assertEqual(sizesToFit: LimitSize.medium, CGSize(width: 200, height: 40))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, CGSize(width: 361.5, height: 20))
    }
    
    func testSentenceTextFiveNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 5
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 97.5, height: 100))
        assertEqual(sizesToFit: LimitSize.medium, CGSize(width: 200, height: 40))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, CGSize(width: 361.5, height: 20))
    }
    
    func testSentenceTextZeroNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 0
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 93, height: 120))
        assertEqual(sizesToFit: LimitSize.medium, CGSize(width: 200, height: 40))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, CGSize(width: 361.5, height: 20))
    }
    
    func testTwoLinesTextOneNumberOfLines() {
        sut.text = Text.twoLines
        sut.numberOfLines = 1
        
        assertEqual(CGSize(width: 175, height: 20))
    }
    
    func testTwoLinesTextTwoNumberOfLines() {
        sut.text = Text.twoLines
        sut.numberOfLines = 2
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 98, height: 40))
        assertEqual(sizesToFit: LimitSize.exceptSmall, CGSize(width: 182.5, height: 40))
    }
    
    func testTwoLinesTextFiveNumberOfLines() {
        sut.text = Text.twoLines
        sut.numberOfLines = 5
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 97.5, height: 100))
        assertEqual(sizesToFit: LimitSize.exceptSmall, CGSize(width: 182.5, height: 40))
    }
    
    func testTwoLinesTextZeroNumberOfLines() {
        sut.text = Text.twoLines
        sut.numberOfLines = 0
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 70, height: 120))
        assertEqual(sizesToFit: LimitSize.exceptSmall, CGSize(width: 182.5, height: 40))
    }
    
    func testFiveLinesTextOneNumberOfLines() {
        sut.text = Text.fiveLines
        sut.numberOfLines = 1
        
        assertEqual(CGSize(width: 271, height: 20))
    }
    
    func testFiveLinesTextTwoNumberOfLines() {
        sut.text = Text.fiveLines
        sut.numberOfLines = 2
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 91, height: 40))
        assertEqual(sizesToFit: LimitSize.medium, CGSize(width: 153, height: 40))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, CGSize(width: 275.5, height: 40))
    }
    
    func testFiveLinesTextFiveNumberOfLines() {
        sut.text = Text.fiveLines
        sut.numberOfLines = 5
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 99, height: 100))
        assertEqual(sizesToFit: LimitSize.medium, CGSize(width: 200, height: 100))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, CGSize(width: 271, height: 100))
    }
    
    func testFiveLinesTextZeroNumberOfLines() {
        sut.text = Text.fiveLines
        sut.numberOfLines = 0
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 100, height: 320))
        assertEqual(sizesToFit: LimitSize.medium, CGSize(width: 198.5, height: 200))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, CGSize(width: 271, height: 100))
    }
    
    func testEightLinesTextOneNumberOfLines() {
        sut.text = Text.eightLines
        sut.numberOfLines = 1
        
        assertEqual(CGSize(width: 204, height: 20))
    }
    
    func testEightLinesTextTwoNumberOfLines() {
        sut.text = Text.eightLines
        sut.numberOfLines = 2
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 97.5, height: 40))
        assertEqual(sizesToFit: LimitSize.medium, CGSize(width: 118, height: 40))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, CGSize(width: 259, height: 40))
    }
    
    func testEightLinesTextFiveNumberOfLines() {
        sut.text = Text.eightLines
        sut.numberOfLines = 5
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 100, height: 100))
        assertEqual(sizesToFit: LimitSize.medium, CGSize(width: 200, height: 100))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, CGSize(width: 264, height: 100))
    }
    
    func testEightLinesTextZeroNumberOfLines() {
        sut.text = Text.eightLines
        sut.numberOfLines = 0
        
        assertEqual(sizesToFit: LimitSize.small, CGSize(width: 100, height: 500))
        assertEqual(sizesToFit: LimitSize.medium, CGSize(width: 197.5, height: 260))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, CGSize(width: 336.5, height: 160))
    }
    
    func forEachNumberOfLines(_ numberOfLines: [Int], block: () -> Void) {
        for number in numberOfLines {
            sut.numberOfLines = number
            block()
        }
    }
    
    func assertEqual(sizesToFit: [CGSize] = LimitSize.all, _ expected: CGSize, file: StaticString = #file, line: UInt = #line) {
        for sizeToFit in sizesToFit {
            XCTAssertEqual(sut.nonEmptySizeThatFits(sizeToFit), expected, "for size that fits: \(sizesToFit)", file: file, line: line)
        }
    }
}
