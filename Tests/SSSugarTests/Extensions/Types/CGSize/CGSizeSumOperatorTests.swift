/*
Tests for sum operator in CGSize extension

options of the left size
	[positive width positive height] width > 0 & height > 0
	[positive width zero     height] width > 0 & height = 0
	[positive width negative height] width > 0 & height < 0
	[zero     width positive height] width = 0 & height > 0
	[zero     width zero     height] width = 0 & height = 0
	[zero     width negative height] width = 0 & height < 0
	[negative width positive height] width < 0 & height > 0
	[negative width zero     height] width < 0 & height = 0
	[negative width negative height] width < 0 & height < 0
[right] options of the right size
	width > 0 & height > 0
	width > 0 & height = 0
	width > 0 & height < 0
	width = 0 & height > 0
	width = 0 & height = 0
	width = 0 & height < 0
	width < 0 & height > 0
	width < 0 & height = 0
	width < 0 & height < 0

[Done] positive width positive height * right
[Done] positive width zero     height * right
[Done] positive width negative height * right
[Done] zero     width positive height * right
[Done] zero     width zero     height * right
[Done] zero     width negative height * right
[Done] negative width positive height * right
[Done] negative width zero     height * right
[Done] negative width negative height * right
 */

import XCTest
@testable import SSSugarCore

class CGSizeSumOperatorTests: XCTestCase {
    typealias Items = CGSizeTestItems
    
    var itemsArray = [Items]()
    
    func testPositiveWidthPositiveHeight() {
        itemsArray = [
            Items(lW: 10, lH: 62, rW: 38, rH: 81, eW: 48, eH: 143),
            Items(lW: 97, lH: 79, rW: 13, rH: 0, eW: 110, eH: 79),
            Items(lW: 17, lH: 65, rW: 96, rH: -77, eW: 113, eH: -12),
            Items(lW: 3, lH: 35, rW: 0, rH: 50, eW: 3, eH: 85),
            Items(lW: 96, lH: 71, rW: 0, rH: 0, eW: 96, eH: 71),
            Items(lW: 86, lH: 70, rW: 0, rH: -30, eW: 86, eH: 40),
            Items(lW: 35, lH: 40, rW: -45, rH: 20, eW: -10, eH: 60),
            Items(lW: 29, lH: 84, rW: -49, rH: 0, eW: -20, eH: 84),
            Items(lW: 8, lH: 51, rW: -12, rH: -19, eW: -4, eH: 32)
        ]
        assertEqualItemsArray()
    }
    
    func testPositiveWidthZeroHeight() {
        itemsArray = [
            Items(lW: 44, lH: 0, rW: 38, rH: 95, eW: 82, eH: 95),
            Items(lW: 1, lH: 0, rW: 1, rH: 0, eW: 2, eH: 0),
            Items(lW: 79, lH: 0, rW: 80, rH: -36, eW: 159, eH: -36),
            Items(lW: 47, lH: 0, rW: 0, rH: 39, eW: 47, eH: 39),
            Items(lW: 26, lH: 0, rW: 0, rH: 0, eW: 26, eH: 0),
            Items(lW: 8, lH: 0, rW: 0, rH: -99, eW: 8, eH: -99),
            Items(lW: 80, lH: 0, rW: -76, rH: 40, eW: 4, eH: 40),
            Items(lW: 84, lH: 0, rW: -97, rH: 0, eW: -13, eH: 0),
            Items(lW: 56, lH: 0, rW: -26, rH: -78, eW: 30, eH: -78)
        ]
        assertEqualItemsArray()
    }
    
    func testPositiveWidthNegativeHeight() {
        itemsArray = [
            Items(lW: 89, lH: -66, rW: 80, rH: 24, eW: 169, eH: -42),
            Items(lW: 43, lH: -10, rW: 72, rH: 0, eW: 115, eH: -10),
            Items(lW: 21, lH: -63, rW: 82, rH: -35, eW: 103, eH: -98),
            Items(lW: 94, lH: -29, rW: 0, rH: 12, eW: 94, eH: -17),
            Items(lW: 13, lH: -62, rW: 0, rH: 0, eW: 13, eH: -62),
            Items(lW: 29, lH: -59, rW: 0, rH: -64, eW: 29, eH: -123),
            Items(lW: 27, lH: -2, rW: -88, rH: 32, eW: -61, eH: 30),
            Items(lW: 85, lH: -73, rW: -37, rH: 0, eW: 48, eH: -73),
            Items(lW: 62, lH: -76, rW: -84, rH: -95, eW: -22, eH: -171)
        ]
        assertEqualItemsArray()
    }

    func testZeroWidthPositiveHeight() {
        itemsArray = [
            Items(lW: 0, lH: 99, rW: 87, rH: 64, eW: 87, eH: 163),
            Items(lW: 0, lH: 86, rW: 40, rH: 0, eW: 40, eH: 86),
            Items(lW: 0, lH: 25, rW: 63, rH: -56, eW: 63, eH: -31),
            Items(lW: 0, lH: 74, rW: 0, rH: 75, eW: 0, eH: 149),
            Items(lW: 0, lH: 67, rW: 0, rH: 0, eW: 0, eH: 67),
            Items(lW: 0, lH: 11, rW: 0, rH: -11, eW: 0, eH: 0),
            Items(lW: 0, lH: 20, rW: -77, rH: 10, eW: -77, eH: 30),
            Items(lW: 0, lH: 10, rW: -83, rH: 0, eW: -83, eH: 10),
            Items(lW: 0, lH: 51, rW: -8, rH: -33, eW: -8, eH: 18),
        ]
        assertEqualItemsArray()
    }

    func testZeroWidthZeroHeight() {
        itemsArray = [
            Items(lW: 0, lH: 0, rW: 30, rH: 86, eW: 30, eH: 86),
            Items(lW: 0, lH: 0, rW: 94, rH: 0, eW: 94, eH: 0),
            Items(lW: 0, lH: 0, rW: 97, rH: -23, eW: 97, eH: -23),
            Items(lW: 0, lH: 0, rW: 0, rH: 71, eW: 0, eH: 71),
            Items(lW: 0, lH: 0, rW: 0, rH: 0, eW: 0, eH: 0),
            Items(lW: 0, lH: 0, rW: 0, rH: -67, eW: 0, eH: -67),
            Items(lW: 0, lH: 0, rW: -82, rH: 25, eW: -82, eH: 25),
            Items(lW: 0, lH: 0, rW: -42, rH: 0, eW: -42, eH: 0),
            Items(lW: 0, lH: 0, rW: -49, rH: -16, eW: -49, eH: -16)
        ]
        assertEqualItemsArray()
    }

    func testZeroWidthNegativeHeight() {
        itemsArray = [
            Items(lW: 0, lH: -95, rW: 47, rH: 54, eW: 47, eH: -41),
            Items(lW: 0, lH: -94, rW: 42, rH: 0, eW: 42, eH: -94),
            Items(lW: 0, lH: -26, rW: 68, rH: -81, eW: 68, eH: -107),
            Items(lW: 0, lH: -15, rW: 0, rH: 81, eW: 0, eH: 66),
            Items(lW: 0, lH: -84, rW: 0, rH: 0, eW: 0, eH: -84),
            Items(lW: 0, lH: -25, rW: 0, rH: -12, eW: 0, eH: -37),
            Items(lW: 0, lH: -95, rW: -42, rH: 5, eW: -42, eH: -90),
            Items(lW: 0, lH: -72, rW: -99, rH: 0, eW: -99, eH: -72),
            Items(lW: 0, lH: -89, rW: -58, rH: -83, eW: -58, eH: -172)
        ]
        assertEqualItemsArray()
    }

    func testNegativeWidthPositiveHeight() {
        itemsArray = [
            Items(lW: -16, lH: 40, rW: 58, rH: 60, eW: 42, eH: 100),
            Items(lW: -70, lH: 6, rW: 35, rH: 0, eW: -35, eH: 6),
            Items(lW: -83, lH: 81, rW: 59, rH: -56, eW: -24, eH: 25),
            Items(lW: -3, lH: 59, rW: 0, rH: 56, eW: -3, eH: 115),
            Items(lW: -79, lH: 11, rW: 0, rH: 0, eW: -79, eH: 11),
            Items(lW: -84, lH: 87, rW: 0, rH: -59, eW: -84, eH: 28),
            Items(lW: -60, lH: 38, rW: -30, rH: 16, eW: -90, eH: 54),
            Items(lW: -39, lH: 63, rW: -11, rH: 0, eW: -50, eH: 63),
            Items(lW: -26, lH: 44, rW: -38, rH: -45, eW: -64, eH: -1)
        ]
        assertEqualItemsArray()
    }

    func testNegativeWidthZeroHeight() {
        itemsArray = [
            Items(lW: -15, lH: 0, rW: 22, rH: 52, eW: 7, eH: 52),
            Items(lW: -42, lH: 0, rW: 35, rH: 0, eW: -7, eH: 0),
            Items(lW: -50, lH: 0, rW: 62, rH: -6, eW: 12, eH: -6),
            Items(lW: -61, lH: 0, rW: 0, rH: 12, eW: -61, eH: 12),
            Items(lW: -92, lH: 0, rW: 0, rH: 0, eW: -92, eH: 0),
            Items(lW: -20, lH: 0, rW: 0, rH: -7, eW: -20, eH: -7),
            Items(lW: -72, lH: 0, rW: -66, rH: 15, eW: -138, eH: 15),
            Items(lW: -55, lH: 0, rW: -18, rH: 0, eW: -73, eH: 0),
            Items(lW: -63, lH: 0, rW: -5, rH: -96, eW: -68, eH: -96)
        ]
        assertEqualItemsArray()
    }

    func testNegativeWidthNegativeHeight() {
        itemsArray = [
            Items(lW: -72, lH: -8, rW: 63, rH: 7, eW: -9, eH: -1),
            Items(lW: -76, lH: -34, rW: 87, rH: 0, eW: 11, eH: -34),
            Items(lW: -33, lH: -94, rW: 26, rH: -80, eW: -7, eH: -174),
            Items(lW: -41, lH: -82, rW: 0, rH: 72, eW: -41, eH: -10),
            Items(lW: -5, lH: -66, rW: 0, rH: 0, eW: -5, eH: -66),
            Items(lW: -53, lH: -36, rW: 0, rH: -64, eW: -53, eH: -100),
            Items(lW: -43, lH: -62, rW: -64, rH: 67, eW: -107, eH: 5),
            Items(lW: -95, lH: -91, rW: -87, rH: 0, eW: -182, eH: -91),
            Items(lW: -99, lH: -18, rW: -76, rH: -11, eW: -175, eH: -29)
        ]
        assertEqualItemsArray()
    }
    
    func assertEqualItemsArray() {
        for item in itemsArray {
            XCTAssertEqual(item.left + item.right, item.expected)
        }
    }
}
