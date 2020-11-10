import XCTest
@testable import SSSugar

/// Tests for `UILabel` extensions.
///
/// # Non Empty Size
/// Test cases for the `nonEmptySizeThatFits(_:)` method.
/// * _nonEmptySizeThatFitsSizeLargerThanZeroOnEmptyText_ — checks the result size is larger than the `CGSize.zero` when the label has empty text.
/// * _nonEmptySizeThatFitsSameAsSizeThatFitsOnNonEmptyText_ — checks the result size is equal to the `sizeThatFits(_:)` when the label has non empty text.
///
/// # Max Size
/// Test cases for the `maxSizeThatFits(_:)` method.
/// * _maxSizeThatFitsNumberOfLinesHeightOnNotFilledAllTextLines_ — checks the result `.max` size height is equal to the max height which is possible for the `label` when the `text` lines less than the `numberOfLines`.
/// * _maxSizeThatFitsSameAsSizeThatFitsOnFilledAllTextLines_ — checks the result `.max` size height is equal to the `sizeThatFits(_:)` when the `text` lines is equal to the `numberOfLines`.
/// * _maxSizeThatFitsSameAsSizeThatFitsOnZeroNumberOfLines_ — checks the result `.max` size height is equal to the `sizeThatFits(_:)` when the `numberOfLines` is equal to `0`.
///
/// # With Text
/// Test cases for the `sizeThatFits(_:withText:)` method.
/// * _sizeThatFitsSameSizeOnSameText_ — checks the result size is equal to the `sizeThatFits(_:)` for the equal text.
/// * _sizeThatFitsSameSizeOnSameTwoLinesText_ — checks the result size is equal to the `sizeThatFits(_:)` result size for the equal two lines text.
/// * _sizeThatFitsSameSizeOnSameFiveLinesText_ — checks the result size is equal to the `sizeThatFits(_:)` result size for the equal five lines text.
/// * _sizeThatFitsBiggerSizeOnBiggerText_ — checks the result size is bigger than the `sizeThatFits(_:)` size when the passed bigger text to the tested method.
/// * _sizeThatFitsSmallerSizeOnSmallerText_ — checks the result size is smaller than the `sizeThatFits(_:)` size when the passed smaller text to the tested method.
/// * _sizeThatFitsFitsSizeToFit_ — checks the result size width is smaller or equal to the fit size width.
class UILabelTests: XCTestCase {
    private let sut = UILabel()
    private let sizeToFit = CGSize(width: 100, height: 60)

    override func setUp() {
        sut.numberOfLines = 0
    }

    // MARK: Non Empty Size
    func testNonEmptySizeThatFitsSizeLargerThanZeroOnEmptyText() {
        sut.text = Text.empty

        XCTAssert(sut.nonEmptySizeThatFits(sizeToFit).width > 0)
        XCTAssert(sut.nonEmptySizeThatFits(sizeToFit).height > 0)
        XCTAssertNotEqual(sut.nonEmptySizeThatFits(sizeToFit), sut.sizeThatFits(sizeToFit))
    }

    func testNonEmptySizeThatFitsSameAsSizeThatFitsOnNonEmptyText() {
        sut.text = Text.word

        XCTAssertEqual(sut.nonEmptySizeThatFits(sizeToFit), sut.sizeThatFits(sizeToFit))
    }

    // MARK: Max Size
    func testMaxSizeThatFitsNumberOfLinesHeightOnNotFilledAllTextLines() {
        sut.text = Text.word
        sut.numberOfLines = 2

        XCTAssertEqual(sut.maxSizeThatFits(sizeToFit).real, sut.sizeThatFits(sizeToFit))
        XCTAssertEqual(sut.maxSizeThatFits(sizeToFit).max.width, sut.sizeThatFits(sizeToFit).width)
        XCTAssertEqual(sut.maxSizeThatFits(sizeToFit).max.height, 40, accuracy: 1)
        XCTAssert(sut.maxSizeThatFits(sizeToFit).max.height > sut.sizeThatFits(sizeToFit).height)
    }

    func testMaxSizeThatFitsSameAsSizeThatFitsOnFilledAllTextLines() {
        sut.text = Text.twoLines
        sut.numberOfLines = 2

        XCTAssertEqual(sut.maxSizeThatFits(sizeToFit).real, sut.sizeThatFits(sizeToFit))
        XCTAssertEqual(sut.maxSizeThatFits(sizeToFit).max, sut.sizeThatFits(sizeToFit))
    }

    func testMaxSizeThatFitsSameAsSizeThatFitsOnZeroNumberOfLines() {
        sut.text = Text.twoLines

        XCTAssertEqual(sut.maxSizeThatFits(sizeToFit).real, sut.sizeThatFits(sizeToFit))
        XCTAssertEqual(sut.maxSizeThatFits(sizeToFit).max, sut.sizeThatFits(sizeToFit))
    }

    // MARK: With Text
    func testSizeThatFitsSameSizeOnSameText() {
        sut.text = Text.word

        XCTAssertEqual(sut.sizeThatFits(sizeToFit, withText: Text.word), sut.sizeThatFits(sizeToFit))
    }

    func testSizeThatFitsSameSizeOnSameTwoLinesText() {
        sut.text = Text.twoLines

        XCTAssertEqual(sut.sizeThatFits(sizeToFit, withText: Text.twoLines), sut.sizeThatFits(sizeToFit))
    }

    func testSizeThatFitsSameSizeOnSameFiveLinesText() {
        sut.text = Text.fiveLines

        XCTAssertEqual(sut.sizeThatFits(sizeToFit, withText: Text.fiveLines), sut.sizeThatFits(sizeToFit))
    }

    func testSizeThatFitsBiggerSizeOnBiggerText() {
        sut.text = Text.word

        XCTAssert(sut.sizeThatFits(sizeToFit, withText: Text.twoLines).width > sut.sizeThatFits(sizeToFit).width)
        XCTAssert(sut.sizeThatFits(sizeToFit, withText: Text.twoLines).height > sut.sizeThatFits(sizeToFit).height)
    }

    func testSizeThatFitsSmallerSizeOnSmallerText() {
        sut.text = Text.twoLines

        XCTAssert(sut.sizeThatFits(sizeToFit, withText: Text.word).width < sut.sizeThatFits(sizeToFit).width)
        XCTAssert(sut.sizeThatFits(sizeToFit, withText: Text.word).height < sut.sizeThatFits(sizeToFit).height)
    }

    func testSizeThatFitsFitsSizeToFit() {
        let result = sut.sizeThatFits(sizeToFit, withText: Text.fiveLines)

        XCTAssert(result.width <= sizeToFit.width)
//        sizeThatFits(_:) method returns bigger height when the text doesn't fit the sizeToFit.
//        XCTAssert(result.height <= sizeToFit.height)
        print(Text.fiveLines)
    }
}

// MARK: - Text

extension UILabelTests {
    private enum Text {
        static let empty = ""
        static let word = "Word"
        static let twoLines = "First line\nSecond line"
        static let fiveLines = """
            One, two, Freddy's coming for you
            Three, four, better lock your door
            Five, six, grab your crucifix
            Seven, eight, gonna stay up late
            Nine, ten, never sleep again
            """
    }
}
