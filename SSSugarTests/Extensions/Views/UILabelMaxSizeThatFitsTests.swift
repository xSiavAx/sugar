import XCTest
@testable import SSSugar

/*
 Tests for maxSizeThatFits(_:) in UILabel extension
 
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
 
 [Done] (nil text + one number of lines) * size
 [Done] (nil text + two number of lines) * size
 [Done] (nil text + five number of lines) * size
 [Done] (nil text + zero number of lines) * size
 [Done] (empty text + one number of lines) * size
 [Done] (empty text + two number of lines) * size
 [Done] (empty text + five number of lines) * size
 [Done] (empty text + zero number of lines) * size
 [Done] (space text + one number of lines) * size
 [Done] (space text + two number of lines) * size
 [Done] (space text + five number of lines) * size
 [Done] (space text + zero number of lines) * size
 [Done] (tab text + one number of lines) * size
 [Done] (tab text + two number of lines) * size
 [Done] (tab text + five number of lines) * size
 [Done] (tab text + zero number of lines) * size
 [Done] (word text + one number of lines) * size
 [Done] (word text + two number of lines) * size
 [Done] (word text + five number of lines) * size
 [Done] (word text + zero number of lines) * size
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

//TODO: [Review] Fail almost every case

class UILabelMaxSizeThatFitsTests: XCTestCase {
    typealias Text = UILabelTestHelper.Text
    typealias LimitSize = UILabelTestHelper.LimitSize

    let sut = UILabel()
    
    func testNilTextOneNumberOfLines() {
        sut.numberOfLines = 1
        
        assertEqual(Result(real: .zero, max: CGSize(width: 0, height: 20)))
    }
    
    func testNilTextTwoNumberOfLines() {
        sut.numberOfLines = 2
        
        assertEqual(Result(real: .zero, max: CGSize(width: 0, height: 40)))
    }
    
    func testNilTextFiveNumberOfLines() {
        sut.numberOfLines = 5
        
        assertEqual(Result(real: .zero, max: CGSize(width: 0, height: 100)))
    }
    
    func testNilTextZeroNumberOfLines() {
        sut.numberOfLines = 0

        assertEqual(Result(both: .zero))
    }
    
    func testEmptyTextOneNumberOfLines() {
        sut.text = Text.empty
        sut.numberOfLines = 1
        
        assertEqual(Result(real: .zero, max: CGSize(width: 0, height: 20)))
    }
    
    func testEmptyTextTwoNumberOfLines() {
        sut.text = Text.empty
        sut.numberOfLines = 2
        
        assertEqual(Result(real: .zero, max: CGSize(width: 0, height: 40)))
    }
    
    func testEmptyTextFiveNumberOfLines() {
        sut.text = Text.empty
        sut.numberOfLines = 5
        
        assertEqual(Result(real: .zero, max: CGSize(width: 0, height: 100)))
    }
    
    func testEmptyTextZeroNumberOfLines() {
        sut.text = Text.empty
        sut.numberOfLines = 0
        
        assertEqual(Result(both: .zero))
    }
    
    func testSpaceTextOneNumberOfLines() {
        sut.text = Text.space
        sut.numberOfLines = 1
        
        assertEqual(Result(both: CGSize(width: 5, height: 20)))
    }
    
    func testSpaceTextTwoNumberOfLines() {
        sut.text = Text.space
        sut.numberOfLines = 2
        
        assertEqual(Result(real: CGSize(width: 5, height: 20), max: CGSize(width: 5, height: 40)))
    }
    
    func testSpaceTextFiveNumberOfLines() {
        sut.text = Text.space
        sut.numberOfLines = 5
        
        assertEqual(Result(real: CGSize(width: 5, height: 20), max: CGSize(width: 5, height: 100)))
    }
    
    func testSpaceTextZeroNumberOfLines() {
        sut.text = Text.space
        sut.numberOfLines = 0
        
        assertEqual(Result(both: CGSize(width: 5, height: 20)))
    }
    
    func testTabTextOneNumberOfLines() {
        sut.text = Text.tab
        sut.numberOfLines = 1
        
        assertEqual(Result(both: CGSize(width: 19, height: 20)))
    }
    
    func testTabTextTwoNumberOfLines() {
        sut.text = Text.tab
        sut.numberOfLines = 2
        
        assertEqual(Result(real: CGSize(width: 19, height: 20), max: CGSize(width: 19, height: 40)))
    }
    
    func testTabTextFiveNumberOfLines() {
        sut.text = Text.tab
        sut.numberOfLines = 5
        
        assertEqual(Result(real: CGSize(width: 19, height: 20), max: CGSize(width: 19, height: 100)))
    }
    
    func testTabTextZeroNumberOfLines() {
        sut.text = Text.tab
        sut.numberOfLines = 0
        
        assertEqual(Result(both: CGSize(width: 19, height: 20)))
    }
    
    func testWordTextOneNumberOfLines() {
        sut.text = Text.word
        sut.numberOfLines = 1
        
        assertEqual(Result(both: CGSize(width: 39.5, height: 20)))
    }
    
    func testWordTextTwoNumberOfLines() {
        sut.text = Text.word
        sut.numberOfLines = 2
        
        assertEqual(Result(real: CGSize(width: 39.5, height: 20), max: CGSize(width: 39.5, height: 40)))
    }
    
    func testWordTextFiveNumberOfLines() {
        sut.text = Text.word
        sut.numberOfLines = 5
        
        assertEqual(Result(real: CGSize(width: 39.5, height: 20), max: CGSize(width: 39.5, height: 100)))
    }
    
    func testWordTextZeroNumberOfLines() {
        sut.text = Text.word
        sut.numberOfLines = 0
        
        assertEqual(Result(both: CGSize(width: 39.5, height: 20)))
    }
    
    func testSentenceTextOneNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 1
        
        assertEqual(Result(both: CGSize(width: 361.5, height: 20)))
    }
    
    func testSentenceTextTwoNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 2
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 98, height: 40)))
        assertEqual(sizesToFit: LimitSize.medium, Result(both: CGSize(width: 200, height: 40)))
        assertEqual(
            sizesToFit: LimitSize.exceptSmallMedium,
            Result(real: CGSize(width: 361.5, height: 20), max: CGSize(width: 361.5, height: 40))
        )
    }
    
    func testSentenceTextFiveNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 5
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 97.5, height: 100)))
        assertEqual(
            sizesToFit: LimitSize.medium,
            Result(real: CGSize(width: 200, height: 40), max: CGSize(width: 200, height: 100))
        )
        assertEqual(
            sizesToFit: LimitSize.exceptSmallMedium,
            Result(real: CGSize(width: 361.5, height: 20), max: CGSize(width: 361.5, height: 100))
        )
    }
    
    func testSentenceTextZeroNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 0
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 93, height: 120)))
        assertEqual(sizesToFit: LimitSize.medium, Result(both: CGSize(width: 200, height: 40)))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, Result(both: CGSize(width: 361.5, height: 20)))
    }
    
    func testTwoLinesTextOneNumberOfLines() {
        sut.text = Text.twoLines
        sut.numberOfLines = 1
        
        assertEqual(Result(both: CGSize(width: 175, height: 20)))
    }
    
    func testTwoLinesTextTwoNumberOfLines() {
        sut.text = Text.twoLines
        sut.numberOfLines = 2
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 98, height: 40)))
        assertEqual(sizesToFit: LimitSize.exceptSmall, Result(both: CGSize(width: 182.5, height: 40)))
    }
    
    func testTwoLinesTextFiveNumberOfLines() {
        sut.text = Text.twoLines
        sut.numberOfLines = 5
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 97.5, height: 100)))
        assertEqual(
            sizesToFit: LimitSize.exceptSmall,
            Result(real: CGSize(width: 182.5, height: 40), max: CGSize(width: 182.5, height: 100))
        )
    }
    
    func testTwoLinesTextZeroNumberOfLines() {
        sut.text = Text.twoLines
        sut.numberOfLines = 0
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 70, height: 120)))
        assertEqual(sizesToFit: LimitSize.exceptSmall, Result(both: CGSize(width: 182.5, height: 40)))
    }
    
    func testFiveLinesTextOneNumberOfLines() {
        sut.text = Text.fiveLines
        sut.numberOfLines = 1
        
        assertEqual(Result(both: CGSize(width: 271, height: 20)))
    }
    
    func testFiveLinesTextTwoNumberOfLines() {
        sut.text = Text.fiveLines
        sut.numberOfLines = 2
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 91, height: 40)))
        assertEqual(sizesToFit: LimitSize.medium, Result(both: CGSize(width: 153, height: 40)))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, Result(both: CGSize(width: 275.5, height: 40)))
    }
    
    func testFiveLinesTextFiveNumberOfLines() {
        sut.text = Text.fiveLines
        sut.numberOfLines = 5
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 99, height: 100)))
        assertEqual(sizesToFit: LimitSize.medium, Result(both: CGSize(width: 200, height: 100)))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, Result(both: CGSize(width: 271, height: 100)))
    }
    
    func testFiveLinesTextZeroNumberOfLines() {
        sut.text = Text.fiveLines
        sut.numberOfLines = 0
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 100, height: 320)))
        assertEqual(sizesToFit: LimitSize.medium, Result(both: CGSize(width: 198.5, height: 200)))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, Result(both: CGSize(width: 271, height: 100)))
    }
    
    func testEightLinesTextOneNumberOfLines() {
        sut.text = Text.eightLines
        sut.numberOfLines = 1
        
        assertEqual(Result(both: CGSize(width: 204, height: 20)))
    }
    
    func testEightLinesTextTwoNumberOfLines() {
        sut.text = Text.eightLines
        sut.numberOfLines = 2
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 97.5, height: 40)))
        assertEqual(sizesToFit: LimitSize.medium, Result(both: CGSize(width: 118, height: 40)))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, Result(both: CGSize(width: 259, height: 40)))
    }
    
    func testEightLinesTextFiveNumberOfLines() {
        sut.text = Text.eightLines
        sut.numberOfLines = 5
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 100, height: 100)))
        assertEqual(sizesToFit: LimitSize.medium, Result(both: CGSize(width: 200, height: 100)))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, Result(both: CGSize(width: 264, height: 100)))
    }
    
    func testEightLinesTextZeroNumberOfLines() {
        sut.text = Text.eightLines
        sut.numberOfLines = 0
        
        assertEqual(sizesToFit: LimitSize.small, Result(both: CGSize(width: 100, height: 500)))
        assertEqual(sizesToFit: LimitSize.medium, Result(both: CGSize(width: 197.5, height: 260)))
        assertEqual(sizesToFit: LimitSize.exceptSmallMedium, Result(both: CGSize(width: 336.5, height: 160)))
    }
    
    func assertEqual(sizesToFit: [CGSize] = LimitSize.all, _ expected: Result, file: StaticString = #file, line: UInt = #line) {
        for sizeToFit in sizesToFit {
            let result = sut.maxSizeThatFits(sizeToFit)
            
            XCTAssertEqual(result.real, expected.real, "for size that fits: \(sizeToFit)", file: file, line: line)
            XCTAssertEqual(result.max, expected.max, "for size that fits: \(sizeToFit)", file: file, line: line)
        }
    }
}

extension UILabelMaxSizeThatFitsTests {
    struct Result {
        let real: CGSize
        let max: CGSize
        
        init(real: CGSize, max: CGSize) {
            self.real = real
            self.max = max
        }
        
        init(both size: CGSize) {
            real = size
            max = size
        }
    }
}
