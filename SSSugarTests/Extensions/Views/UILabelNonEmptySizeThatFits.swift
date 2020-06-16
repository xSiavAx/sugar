/*
 
 Tests for nonEmptySizeThatFits(_:) method in UILabel extension
 
 [Done] text
    [Done] nil
    [Done] empty
    [Done] space
    [Done] tab
    [Done] word
    [Done] sentence
    [Done] multiline
        [Done] two lines
        [Done] five lines
        [Done] eight lines
 [Done] number of lines
    [Done] one
    [Done] two
    [Done] five
    [Done] zero
 [Done] sizeToFit
    [Done] width
        [Done] negative
        [Done] zero
        [Done] small
        [Done] medium
        [Done] large
    [Done] height
        [Done] negative
        [Done] zero
        [Done] small
        [Done] medium
        [Done] large
 
 */

import XCTest
@testable import SSSugar

class UILabelNonEmptySizeThatFits: XCTestCase {
    
    let sut = UILabel()
    
    func testNilText() {
        forAllNumberOfLines {
            assertEqual(expected: SizeThatFits.default)
        }
    }
    
    func testEmptyText() {
        sut.text = Text.empty
        forAllNumberOfLines {
            assertEqual(expected: SizeThatFits.default)
        }
    }
    
    func testSpaceText() {
        sut.text = Text.space
        forAllNumberOfLines {
            assertEqual(expected: SizeThatFits.space)
        }
    }
    
    func testTabText() {
        sut.text = Text.tab
        forAllNumberOfLines {
            assertEqual(expected: SizeThatFits.tab)
        }
    }
    
    func testWordText() {
        sut.text = Text.word
        forAllNumberOfLines {
            assertEqual(expected: SizeThatFits.word)
        }
    }
    
    func testSentenceTextOneNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 1
        assertEqual(expected: SizeThatFits.Sentence.default)
    }
    
    func testSentenceTextTwoNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 2
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Sentence.smallTwoLines)
        assertEqual(sizesToFit: SizeToFit.mediumWidth, expected: SizeThatFits.Sentence.mediumTwoLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallMediumWidth, expected: SizeThatFits.Sentence.default)
    }
    
    func testSentenceTextFiveNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 5
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Sentence.smallFiveLines)
        assertEqual(sizesToFit: SizeToFit.mediumWidth, expected: SizeThatFits.Sentence.mediumTwoLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallMediumWidth, expected: SizeThatFits.Sentence.default)
    }
    
    func testSentenceTextZeroNumberOfLines() {
        sut.text = Text.sentence
        sut.numberOfLines = 0
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Sentence.smallZeroLines)
        assertEqual(sizesToFit: SizeToFit.mediumWidth, expected: SizeThatFits.Sentence.mediumTwoLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallMediumWidth, expected: SizeThatFits.Sentence.default)
    }
    
    func testMultilineTwoLinesTextOneNumberOfLines() {
        sut.text = Text.multilineTwoLines
        sut.numberOfLines = 1
        assertEqual(expected: SizeThatFits.Multiline.Two.oneLine)
    }
    
    func testMultilineTwoLinesTextTwoNumberOfLines() {
        sut.text = Text.multilineTwoLines
        sut.numberOfLines = 2
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Sentence.smallTwoLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallWidth, expected: SizeThatFits.Multiline.Two.default)
    }
    
    func testMultilineTwoLinesTextFiveNumberOfLines() {
        sut.text = Text.multilineTwoLines
        sut.numberOfLines = 5
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Sentence.smallFiveLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallWidth, expected: SizeThatFits.Multiline.Two.default)
    }
    
    func testMultilineTwoLinesTextZeroNumberOfLines() {
        sut.text = Text.multilineTwoLines
        sut.numberOfLines = 0
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Multiline.Two.smallZeroLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallWidth, expected: SizeThatFits.Multiline.Two.default)
    }
    
    func testMultilineFiveLinesTextOneNumberOfLines() {
        sut.text = Text.mutlilineFiveLines
        sut.numberOfLines = 1
        assertEqual(expected: SizeThatFits.Multiline.Five.oneLine)
    }
    
    func testMultilineFiveLinesTextTwoNumberOfLines() {
        sut.text = Text.mutlilineFiveLines
        sut.numberOfLines = 2
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Multiline.Five.smallTwoLines)
        assertEqual(sizesToFit: SizeToFit.mediumWidth, expected: SizeThatFits.Multiline.Five.mediumTwoLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallMediumWidth, expected: SizeThatFits.Multiline.Five.twoLines)
    }
    
    func testMultilineFiveLinesTextFiveNumberOfLines() {
        sut.text = Text.mutlilineFiveLines
        sut.numberOfLines = 5
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Multiline.Five.smallFiveLines)
        assertEqual(sizesToFit: SizeToFit.mediumWidth, expected: SizeThatFits.Multiline.Five.mediumFiveLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallMediumWidth, expected: SizeThatFits.Multiline.Five.default)
    }
    
    func testMultilineFiveLinesTextZeroNumberOfLines() {
        sut.text = Text.mutlilineFiveLines
        sut.numberOfLines = 0
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Multiline.Five.smallZeroLines)
        assertEqual(sizesToFit: SizeToFit.mediumWidth, expected: SizeThatFits.Multiline.Five.mediumZeroLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallMediumWidth, expected: SizeThatFits.Multiline.Five.default)
    }
    
    func testMultilineEightLinesTextOneNumberOfLines() {
        sut.text = Text.multilineEightLines
        sut.numberOfLines = 1
        assertEqual(expected: SizeThatFits.Multiline.Eight.oneLine)
    }
    
    func testMultilineEightLinesTextTwoNumberOfLines() {
        sut.text = Text.multilineEightLines
        sut.numberOfLines = 2
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Multiline.Eight.smallTwoLines)
        assertEqual(sizesToFit: SizeToFit.mediumWidth, expected: SizeThatFits.Multiline.Eight.mediumTwoLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallMediumWidth, expected: SizeThatFits.Multiline.Eight.twoLines)
    }
    
    func testMultilineEightLinesTextFiveNumberOfLines() {
        sut.text = Text.multilineEightLines
        sut.numberOfLines = 5
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Multiline.Eight.smallFiveLines)
        assertEqual(sizesToFit: SizeToFit.mediumWidth, expected: SizeThatFits.Multiline.Eight.mediumFiveLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallMediumWidth, expected: SizeThatFits.Multiline.Eight.fiveLines)
    }
    
    func testMultilineEightLinesTextZeroNumberOfLines() {
        sut.text = Text.multilineEightLines
        sut.numberOfLines = 0
        assertEqual(sizesToFit: SizeToFit.smallWidth, expected: SizeThatFits.Multiline.Eight.smallZeroLines)
        assertEqual(sizesToFit: SizeToFit.mediumWidth, expected: SizeThatFits.Multiline.Eight.mediumZeroLines)
        assertEqual(sizesToFit: SizeToFit.exceptSmallMediumWidth, expected: SizeThatFits.Multiline.Eight.zeroLines)
    }
    
    func forAllNumberOfLines(block: () -> Void) {
        for number in [1, 2, 5, 0] {
            sut.numberOfLines = number
            block()
        }
    }
    
    func assertEqual(sizesToFit: [CGSize] = SizeToFit.all, expected: CGSize) {
        for sizeToFit in sizesToFit {
            XCTAssertEqual(sut.nonEmptySizeThatFits(sizeToFit), expected)
        }
    }

}


extension UILabelNonEmptySizeThatFits {
    
    enum Text {
        static let empty = ""
        static let space = " "
        static let tab = "    "
        static let word = "word"
        static let sentence = "He has every attribute of a dog except loyalty."
        static let multilineTwoLines = "He has every attribute\nof a dog except loyalty."
        static let mutlilineFiveLines = """
            One, two, Freddy's coming for you
            Three, four, better lock your door
            Five, six, grab your crucifix
            Seven, eight, gonna stay up late
            Nine, ten, never sleep again
            """
        static let multilineEightLines = """
            No stop signs, speed limit
            Nobody's gonna slow me down
            Like a wheel, gonna spin it
            Nobody's gonna mess me around
            Hey Satan, paid my dues
            Playing in a rocking band
            Hey mama, look at me
            I'm on my way to the promised land, whoo!
            """
    }
    
    enum SizeThatFits {
        
        enum Sentence {
            static let `default` = CGSize(width: 361.5, height: 20)
            static let smallTwoLines = CGSize(width: 98, height: 40)
            static let mediumTwoLines = CGSize(width: 200, height: 40)
            static let smallFiveLines = CGSize(width: 97.5, height: 100)
            static let smallZeroLines = CGSize(width: 93, height: 120)
        }
        
        enum Multiline {
            
            enum Two {
                static let `default` = CGSize(width: 182.5, height: 40)
                static let oneLine = CGSize(width: 175, height: 20)
                static let smallZeroLines = CGSize(width: 70, height: 120)
            }
            
            enum Five {
                static let `default` = CGSize(width: 271, height: 100)
                static let oneLine = CGSize(width: 271, height: 20)
                static let twoLines = CGSize(width: 275.5, height: 40)
                static let smallTwoLines = CGSize(width: 91, height: 40)
                static let mediumTwoLines = CGSize(width: 153, height: 40)
                static let smallFiveLines = CGSize(width: 99, height: 100)
                static let mediumFiveLines = CGSize(width: 200, height: 100)
                static let smallZeroLines = CGSize(width: 100, height: 320)
                static let mediumZeroLines = CGSize(width: 198.5, height: 200)
            }
            
            enum Eight {
                static let oneLine = CGSize(width: 204, height: 20)
                static let twoLines = CGSize(width: 259, height: 40)
                static let smallTwoLines = CGSize(width: 97.5, height: 40)
                static let mediumTwoLines = CGSize(width: 118, height: 40)
                static let fiveLines = CGSize(width: 264, height: 100)
                static let smallFiveLines = CGSize(width: 100, height: 100)
                static let mediumFiveLines = CGSize(width: 200, height: 100)
                static let smallZeroLines = CGSize(width: 100, height: 500)
                static let mediumZeroLines = CGSize(width: 197.5, height: 260)
                static let zeroLines = CGSize(width: 336.5, height: 160)
            }
        }
        
        static let `default` = CGSize(width: 4.67333984375, height: 20)
        static let space = CGSize(width: 5, height: 20)
        static let tab = CGSize(width: 19, height: 20)
        static let word = CGSize(width: 39.5, height: 20)
        
    }
    
    enum Size: CGFloat, CaseIterable {
        
        case negative = -20
        case zero = 0
        case small = 100
        case medium = 200
        case large = 600
        
        var value: CGFloat { rawValue }
        
        static func make(width: Size, height: Size) -> CGSize {
            CGSize(width: width.value, height: height.value)
        }
        
    }
    
    enum SizeToFit {
        
        static let all = make(widths: Size.allCases, heights: Size.allCases)
        static let smallWidth = make(widths: [.small], heights: Size.allCases)
        static let mediumWidth = make(widths: [.medium], heights: Size.allCases)
        static let exceptSmallWidth = make(widths: [.negative, .zero, .medium, .large], heights: Size.allCases)
        static let exceptSmallMediumWidth = make(widths: [.negative, .zero, .large], heights: Size.allCases)
        
        static func make(widths: [Size], heights: [Size]) -> [CGSize] {
            var sizeArray = [CGSize]()
            
            for width in widths {
                for height in heights {
                    sizeArray.append(Size.make(width: width, height: height))
                }
            }
            return sizeArray
        }
            
    }
    
}
