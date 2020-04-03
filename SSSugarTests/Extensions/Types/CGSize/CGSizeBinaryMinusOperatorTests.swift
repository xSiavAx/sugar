/*
 
 Tests for binary minus operator in CGSize extension
 
 [Done] difference
    [Done] left.width > right.width & left.height > right.height
    [Done] left.width > right.width & left.height = right.height
    [Done] left.width > right.width & left.height < right.height
    [Done] left.width = right.width & left.height > right.height
    [Done] left.width = right.width & left.height = right.height
    [Done] left.width = right.width & left.height < right.height
    [Done] left.width < right.width & left.height > right.height
    [Done] left.width < right.width & left.height = right.height
    [Done] left.width < right.width & left.height < right.height
 [Done] left
    [Done] width > 0 & height > 0
    [Done] width > 0 & height = 0
    [Done] width > 0 & height < 0
    [Done] width = 0 & height > 0
    [Done] width = 0 & height = 0
    [Done] width = 0 & height < 0
    [Done] width < 0 & height > 0
    [Done] width < 0 & height = 0
    [Done] width < 0 & height < 0
 [Done] right
    [Done] width > 0 & height > 0
    [Done] width > 0 & height = 0
    [Done] width > 0 & height < 0
    [Done] width = 0 & height > 0
    [Done] width = 0 & height = 0
    [Done] width = 0 & height < 0
    [Done] width < 0 & height > 0
    [Done] width < 0 & height = 0
    [Done] width < 0 & height < 0
 
 */

import XCTest
@testable import SSSugar

class CGSizeBinaryMinusOperatorTests: XCTestCase {
    
    typealias Items = CGSizeTestItems
    
    var itemsArray = [Items]()

    func testGreaterWidthGreaterHeight() {
        itemsArray = [
            Items(lW: 65, lH: 41, rW: 42, rH: 10, eW: 23, eH: 31),
            Items(lW: 9, lH: 39, rW: 9, rH: 0, eW: 0, eH: 39),
            Items(lW: 66, lH: 31, rW: 18, rH: -14, eW: 48, eH: 45),
            Items(lW: 4, lH: 12, rW: 0, rH: 1, eW: 4, eH: 11),
            Items(lW: 66, lH: 14, rW: 0, rH: 0, eW: 66, eH: 14),
            Items(lW: 21, lH: 55, rW: 0, rH: -15, eW: 21, eH: 70),
            Items(lW: 65, lH: 35, rW: -100, rH: 28, eW: 165, eH: 7),
            Items(lW: 57, lH: 81, rW: -77, rH: 0, eW: 134, eH: 81),
            Items(lW: 3, lH: 94, rW: -45, rH: -23, eW: 48, eH: 117),
            Items(lW: 79, lH: 0, rW: 54, rH: -45, eW: 25, eH: 45),
            Items(lW: 14, lH: 0, rW: 0, rH: -26, eW: 14, eH: 26),
            Items(lW: 11, lH: 0, rW: -99, rH: -95, eW: 110, eH: 95),
            Items(lW: 80, lH: -52, rW: 72, rH: -76, eW: 8, eH: 24),
            Items(lW: 59, lH: -84, rW: 0, rH: -29, eW: 59, eH: -55),
            Items(lW: 79, lH: -41, rW: -80, rH: -28, eW: 159, eH: -13),
            Items(lW: 0, lH: 67, rW: -57, rH: 28, eW: 57, eH: 39),
            Items(lW: 0, lH: 25, rW: -77, rH: 0, eW: 77, eH: 25),
            Items(lW: 0, lH: 27, rW: -25, rH: -67, eW: 25, eH: 94),
            Items(lW: 0, lH: 0, rW: -49, rH: -85, eW: 49, eH: 85),
            Items(lW: 0, lH: -82, rW: -22, rH: -88, eW: 22, eH: 6),
            Items(lW: -11, lH: 22, rW: -38, rH: 19, eW: 27, eH: 3),
            Items(lW: -25, lH: 87, rW: -28, rH: 0, eW: 3, eH: 87),
            Items(lW: -83, lH: 30, rW: -69, rH: -58, eW: -14, eH: 88),
            Items(lW: -83, lH: 0, rW: -82, rH: -58, eW: -1, eH: 58),
            Items(lW: -55, lH: -3, rW: -79, rH: -50, eW: 24, eH: 47)
        ]
        assertEquaItemsArray()
    }
    
    func testGreaterWidthSameHeight() {
        itemsArray = [
            Items(lW: 92, lH: 100, rW: 45, rH: 100, eW: 47, eH: 0),
            Items(lW: 47, lH: 55, rW: 0, rH: 55, eW: 47, eH: 0),
            Items(lW: 67, lH: 63, rW: -82, rH: 63, eW: 149, eH: 0),
            Items(lW: 45, lH: 0, rW: 41, rH: 0, eW: 4, eH: 0),
            Items(lW: 7, lH: 0, rW: 0, rH: 0, eW: 7, eH: 0),
            Items(lW: 1, lH: 0, rW: -45, rH: 0, eW: 46, eH: 0),
            Items(lW: 3, lH: 71, rW: 3, rH: 71, eW: 0, eH: 0),
            Items(lW: 18, lH: 64, rW: 0, rH: 64, eW: 18, eH: 0),
            Items(lW: 65, lH: 32, rW: -40, rH: 32, eW: 105, eH: 0),
            Items(lW: 0, lH: 65, rW: 0, rH: 65, eW: 0, eH: 0),
            Items(lW: 0, lH: 39, rW: 0, rH: 39, eW: 0, eH: 0),
            Items(lW: 0, lH: 36, rW: -3, rH: 36, eW: 3, eH: 0),
            Items(lW: 0, lH: 0, rW: 0, rH: 0, eW: 0, eH: 0),
            Items(lW: 0, lH: 0, rW: 0, rH: 0, eW: 0, eH: 0),
            Items(lW: 0, lH: 0, rW: -32, rH: 0, eW: 32, eH: 0),
            Items(lW: 0, lH: 61, rW: 0, rH: 61, eW: 0, eH: 0),
            Items(lW: 0, lH: 58, rW: 0, rH: 58, eW: 0, eH: 0),
            Items(lW: 0, lH: 3, rW: -67, rH: 3, eW: 67, eH: 0),
            Items(lW: -2, lH: 42, rW: 0, rH: 42, eW: -2, eH: 0),
            Items(lW: -65, lH: 96, rW: -46, rH: 96, eW: -19, eH: 0),
            Items(lW: -59, lH: 0, rW: 0, rH: 0, eW: -59, eH: 0),
            Items(lW: -67, lH: 0, rW: -79, rH: 0, eW: 12, eH: 0),
            Items(lW: -56, lH: 50, rW: 0, rH: 50, eW: -56, eH: 0),
            Items(lW: -1, lH: 56, rW: -26, rH: 56, eW: 25, eH: 0)
        ]
        assertEquaItemsArray()
    }
    
    func testGreaterWidthSmallerHeight() {
        itemsArray = [
            Items(lW: 41, lH: 7, rW: 33, rH: 24, eW: 8, eH: -17),
            Items(lW: 66, lH: 5, rW: 0, rH: 38, eW: 66, eH: -33),
            Items(lW: 84, lH: 52, rW: -80, rH: 76, eW: 164, eH: -24),
            Items(lW: 99, lH: 0, rW: 39, rH: 71, eW: 60, eH: -71),
            Items(lW: 54, lH: 0, rW: 0, rH: 74, eW: 54, eH: -74),
            Items(lW: 22, lH: 0, rW: -83, rH: 39, eW: 105, eH: -39),
            Items(lW: 71, lH: 0, rW: -44, rH: 0, eW: 115, eH: 0),
            Items(lW: 10, lH: -97, rW: 3, rH: 39, eW: 7, eH: -136),
            Items(lW: 39, lH: -35, rW: 4, rH: 0, eW: 35, eH: -35),
            Items(lW: 53, lH: -97, rW: 23, rH: -85, eW: 30, eH: -12),
            Items(lW: 94, lH: -81, rW: 0, rH: 82, eW: 94, eH: -163),
            Items(lW: 8, lH: -48, rW: 0, rH: 0, eW: 8, eH: -48),
            Items(lW: 15, lH: -98, rW: 0, rH: -88, eW: 15, eH: -10),
            Items(lW: 13, lH: -62, rW: -75, rH: 56, eW: 88, eH: -118),
            Items(lW: 11, lH: -90, rW: -5, rH: 0, eW: 16, eH: -90),
            Items(lW: 93, lH: -88, rW: -22, rH: -87, eW: 115, eH: -1),
            Items(lW: 0, lH: 12, rW: 0, rH: 64, eW: 0, eH: -52),
            Items(lW: 0, lH: 1, rW: -46, rH: 70, eW: 46, eH: -69),
            Items(lW: 0, lH: 0, rW: 0, rH: 18, eW: 0, eH: -18),
            Items(lW: 0, lH: 0, rW: -48, rH: 36, eW: 48, eH: -36),
            Items(lW: 0, lH: -21, rW: 0, rH: 24, eW: 0, eH: -45),
            Items(lW: 0, lH: -21, rW: 0, rH: 0, eW: 0, eH: -21),
            Items(lW: 0, lH: -36, rW: 0, rH: -24, eW: 0, eH: -12),
            Items(lW: 0, lH: -35, rW: -1, rH: 49, eW: 1, eH: -84),
            Items(lW: 0, lH: -93, rW: -45, rH: 0, eW: 45, eH: -93),
            Items(lW: 0, lH: -77, rW: -53, rH: -17, eW: 53, eH: -60),
            Items(lW: -77, lH: 14, rW: -83, rH: 96, eW: 6, eH: -82),
            Items(lW: -39, lH: 0, rW: -99, rH: 24, eW: 60, eH: -24),
            Items(lW: -62, lH: -23, rW: -90, rH: 33, eW: 28, eH: -56),
            Items(lW: -31, lH: -35, rW: -88, rH: 0, eW: 57, eH: -35),
            Items(lW: -1, lH: -75, rW: -10, rH: -66, eW: 9, eH: -9)
        ]
        assertEquaItemsArray()
    }
    
    func testSameWidthGreaterHeight() {
        itemsArray = [
            Items(lW: 38, lH: 79, rW: 23, rH: 19, eW: 15, eH: 60),
            Items(lW: 70, lH: 49, rW: 34, rH: -64, eW: 36, eH: 113),
            Items(lW: 33, lH: 0, rW: 26, rH: -32, eW: 7, eH: 32),
            Items(lW: 59, lH: -15, rW: 13, rH: -99, eW: 46, eH: 84),
            Items(lW: -70, lH: 28, rW: -70, rH: 8, eW: 0, eH: 20),
            Items(lW: -61, lH: 91, rW: -61, rH: -15, eW: 0, eH: 106),
            Items(lW: -8, lH: 0, rW: -8, rH: -40, eW: 0, eH: 40),
            Items(lW: -45, lH: -74, rW: -45, rH: -80, eW: 0, eH: 6)
        ]
        assertEquaItemsArray()
    }
    
    func testSameWidthSameHeight() {
        itemsArray = [
            Items(lW: 97, lH: 41, rW: 97, rH: 41, eW: 0, eH: 0),
            Items(lW: 82, lH: 0, rW: 82, rH: 0, eW: 0, eH: 0),
            Items(lW: 59, lH: -29, rW: 59, rH: -29, eW: 0, eH: 0),
            Items(lW: 0, lH: 77, rW: 0, rH: 77, eW: 0, eH: 0),
            Items(lW: 0, lH: 0, rW: 0, rH: 0, eW: 0, eH: 0),
            Items(lW: 0, lH: -21, rW: 0, rH: -21, eW: 0, eH: 0),
            Items(lW: -4, lH: 28, rW: -4, rH: 28, eW: 0, eH: 0),
            Items(lW: -73, lH: 0, rW: -73, rH: 0, eW: 0, eH: 0),
            Items(lW: -27, lH: -38, rW: -27, rH: -38, eW: 0, eH: 0)
        ]
        assertEquaItemsArray()
    }
    
    func testSameWidthSmallerHeight() {
        itemsArray = [
            Items(lW: 75, lH: 73, rW: 75, rH: 22, eW: 0, eH: 51),
            Items(lW: 49, lH: 8, rW: 49, rH: 0, eW: 0, eH: 8),
            Items(lW: 39, lH: 47, rW: 39, rH: -23, eW: 0, eH: 70),
            Items(lW: 4, lH: 0, rW: 4, rH: -33, eW: 0, eH: 33),
            Items(lW: 81, lH: -7, rW: 81, rH: -93, eW: 0, eH: 86),
            Items(lW: 0, lH: 42, rW: 0, rH: 24, eW: 0, eH: 18),
            Items(lW: 0, lH: 48, rW: 0, rH: 0, eW: 0, eH: 48),
            Items(lW: 0, lH: 32, rW: 0, rH: -39, eW: 0, eH: 71),
            Items(lW: 0, lH: 0, rW: 0, rH: -91, eW: 0, eH: 91),
            Items(lW: 0, lH: -12, rW: 0, rH: -95, eW: 0, eH: 83),
            Items(lW: -39, lH: 42, rW: -39, rH: 20, eW: 0, eH: 22),
            Items(lW: -44, lH: 53, rW: -44, rH: 0, eW: 0, eH: 53),
            Items(lW: -56, lH: 66, rW: -56, rH: -57, eW: 0, eH: 123),
            Items(lW: -39, lH: 0, rW: -39, rH: -85, eW: 0, eH: 85),
            Items(lW: -13, lH: -97, rW: -13, rH: -98, eW: 0, eH: 1)
        ]
        assertEquaItemsArray()
    }
    
    func testSmallerWidthGreaterHeight() {
        itemsArray = [
            Items(lW: 68, lH: 95, rW: 84, rH: 25, eW: -16, eH: 70),
            Items(lW: 98, lH: 14, rW: 99, rH: 0, eW: -1, eH: 14),
            Items(lW: 69, lH: 52, rW: 71, rH: -86, eW: -2, eH: 138),
            Items(lW: 16, lH: 0, rW: 18, rH: -22, eW: -2, eH: 22),
            Items(lW: 26, lH: -71, rW: 86, rH: -73, eW: -60, eH: 2),
            Items(lW: 0, lH: 72, rW: 28, rH: 38, eW: -28, eH: 34),
            Items(lW: 0, lH: 38, rW: 31, rH: 0, eW: -31, eH: 38),
            Items(lW: 0, lH: 38, rW: 48, rH: -27, eW: -48, eH: 65),
            Items(lW: 0, lH: 0, rW: 11, rH: -90, eW: -11, eH: 90),
            Items(lW: 0, lH: -13, rW: 61, rH: -77, eW: -61, eH: 64),
            Items(lW: -65, lH: 38, rW: 98, rH: 7, eW: -163, eH: 31),
            Items(lW: -24, lH: 42, rW: 30, rH: 0, eW: -54, eH: 42),
            Items(lW: -20, lH: 36, rW: 95, rH: -26, eW: -115, eH: 62),
            Items(lW: -95, lH: 58, rW: 0, rH: 44, eW: -95, eH: 14),
            Items(lW: -6, lH: 15, rW: 0, rH: 0, eW: -6, eH: 15),
            Items(lW: -25, lH: 4, rW: 0, rH: -93, eW: -25, eH: 97),
            Items(lW: -90, lH: 58, rW: -87, rH: 54, eW: -3, eH: 4),
            Items(lW: -32, lH: 25, rW: -26, rH: 0, eW: -6, eH: 25),
            Items(lW: -78, lH: 62, rW: -6, rH: -87, eW: -72, eH: 149),
            Items(lW: -30, lH: 0, rW: 2, rH: -66, eW: -32, eH: 66),
            Items(lW: -51, lH: 0, rW: 0, rH: -98, eW: -51, eH: 98),
            Items(lW: -24, lH: 0, rW: -21, rH: -64, eW: -3, eH: 64),
            Items(lW: -31, lH: -93, rW: 98, rH: -96, eW: -129, eH: 3),
            Items(lW: -23, lH: -20, rW: 0, rH: -45, eW: -23, eH: 25),
            Items(lW: -15, lH: -3, rW: -8, rH: -63, eW: -7, eH: 60)
        ]
        assertEquaItemsArray()
    }
    
    func testSmallerWidthSameHeight() {
        itemsArray = [
            Items(lW: 65, lH: 61, rW: 71, rH: 61, eW: -6, eH: 0),
            Items(lW: 65, lH: 0, rW: 96, rH: 0, eW: -31, eH: 0),
            Items(lW: 21, lH: -62, rW: 92, rH: -62, eW: -71, eH: 0),
            Items(lW: 0, lH: 0, rW: 92, rH: 0, eW: -92, eH: 0),
            Items(lW: 0, lH: -86, rW: 38, rH: -86, eW: -38, eH: 0),
            Items(lW: -6, lH: 34, rW: 20, rH: 34, eW: -26, eH: 0),
            Items(lW: -4, lH: 97, rW: 0, rH: 97, eW: -4, eH: 0),
            Items(lW: -95, lH: 2, rW: -64, rH: 2, eW: -31, eH: 0),
            Items(lW: -62, lH: 0, rW: 65, rH: 0, eW: -127, eH: 0),
            Items(lW: -53, lH: 0, rW: 0, rH: 0, eW: -53, eH: 0),
            Items(lW: -68, lH: 0, rW: -56, rH: 0, eW: -12, eH: 0),
            Items(lW: -72, lH: -21, rW: 96, rH: -21, eW: -168, eH: 0),
            Items(lW: -29, lH: -1, rW: 0, rH: -1, eW: -29, eH: 0),
            Items(lW: -55, lH: -38, rW: -14, rH: -38, eW: -41, eH: 0)
        ]
        assertEquaItemsArray()
    }
    
    func testSmallerWidthSmallerHeight() {
        itemsArray = [
            Items(lW: 27, lH: 74, rW: 53, rH: 98, eW: -26, eH: -24),
            Items(lW: 99, lH: 0, rW: 99, rH: 81, eW: 0, eH: -81),
            Items(lW: 37, lH: -57, rW: 80, rH: 27, eW: -43, eH: -84),
            Items(lW: 91, lH: -78, rW: 97, rH: 0, eW: -6, eH: -78),
            Items(lW: 57, lH: -48, rW: 98, rH: -32, eW: -41, eH: -16),
            Items(lW: 0, lH: 92, rW: 87, rH: 95, eW: -87, eH: -3),
            Items(lW: 0, lH: 0, rW: 95, rH: 84, eW: -95, eH: -84),
            Items(lW: 0, lH: -13, rW: 79, rH: 83, eW: -79, eH: -96),
            Items(lW: 0, lH: -85, rW: 41, rH: 0, eW: -41, eH: -85),
            Items(lW: 0, lH: -46, rW: 90, rH: -5, eW: -90, eH: -41),
            Items(lW: -71, lH: 32, rW: 17, rH: 84, eW: -88, eH: -52),
            Items(lW: -92, lH: 37, rW: 0, rH: 37, eW: -92, eH: 0),
            Items(lW: -86, lH: 71, rW: -2, rH: 95, eW: -84, eH: -24),
            Items(lW: -67, lH: 0, rW: 95, rH: 96, eW: -162, eH: -96),
            Items(lW: -41, lH: 0, rW: 0, rH: 74, eW: -41, eH: -74),
            Items(lW: -80, lH: 0, rW: -79, rH: 50, eW: -1, eH: -50),
            Items(lW: -76, lH: -89, rW: 32, rH: 32, eW: -108, eH: -121),
            Items(lW: -64, lH: -19, rW: 1, rH: 0, eW: -65, eH: -19),
            Items(lW: -22, lH: -63, rW: 59, rH: -8, eW: -81, eH: -55),
            Items(lW: -62, lH: -35, rW: 0, rH: 54, eW: -62, eH: -89),
            Items(lW: -40, lH: -60, rW: 0, rH: 0, eW: -40, eH: -60),
            Items(lW: -85, lH: -69, rW: 0, rH: -42, eW: -85, eH: -27),
            Items(lW: -38, lH: -50, rW: -14, rH: 82, eW: -24, eH: -132),
            Items(lW: -11, lH: -61, rW: -8, rH: 0, eW: -3, eH: -61),
            Items(lW: -74, lH: -57, rW: -46, rH: -46, eW: -28, eH: -11)
        ]
        assertEquaItemsArray()
    }
    
    func assertEquaItemsArray() {
        for items in itemsArray {
            XCTAssertEqual(items.left - items.right, items.expected)
        }
    }
}
