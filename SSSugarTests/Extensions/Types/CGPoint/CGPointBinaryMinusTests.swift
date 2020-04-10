/*
 Tests for binary minus operator in CGPoint extension
 
 options of difference between the left and right points
    [greater x greater y] left.x > right.x & left.y > right.y
    [greater x same    y] left.x > right.x & left.y = right.y
    [greater x smaller y] left.x > right.x & left.y < right.y
    [same    x greater y] left.x = right.x & left.y > right.y
    [same    x same    y] left.x = right.x & left.y = right.y
    [same    x smaller y] left.x = right.x & left.y < right.y
    [smaller x greater y] left.x < right.x & left.y > right.y
    [smaller x same    y] left.x < right.x & left.y = right.y
    [smaller x smaller y] left.x < right.x & left.y < right.y
 [left] options of the left points
    x > 0 & y > 0
    x > 0 & y = 0
    x > 0 & y < 0
    x = 0 & y > 0
    x = 0 & y = 0
    x = 0 & y < 0
    x < 0 & y > 0
    x < 0 & y = 0
    x < 0 & y < 0
 [right] options of the right points
    x > 0 & y > 0
    x > 0 & y = 0
    x > 0 & y < 0
    x = 0 & y > 0
    x = 0 & y = 0
    x = 0 & y < 0
    x < 0 & y > 0
    x < 0 & y = 0
    x < 0 & y < 0
 
 [Done] (greater x greater y) * left * right
 [Done] (greater x same    y) * left * rihgt
 [Done] (greater x smaller y) * left * rihgt
 [Done] (same    x greater y) * left * rihgt
 [Done] (same    x same    y) * left * rihgt
 [Done] (same    x smaller y) * left * rihgt
 [Done] (smaller x greater y) * left * rihgt
 [Done] (smaller x same    y) * left * rihgt
 [Done] (smaller x smaller y) * left * rihgt
 */

import XCTest
@testable import SSSugar

class CGPointBinaryMinusTests: XCTestCase {
    typealias Items = CGPointTestItems
    
    var itemsArray = [Items]()

    func testGreaterXGreaterY() {
        itemsArray = [
            Items(lX: 65, lY: 41, rX: 42, rY: 10, eX: 23, eY: 31),
            Items(lX: 9, lY: 39, rX: 9, rY: 0, eX: 0, eY: 39),
            Items(lX: 66, lY: 31, rX: 18, rY: -14, eX: 48, eY: 45),
            Items(lX: 4, lY: 12, rX: 0, rY: 1, eX: 4, eY: 11),
            Items(lX: 66, lY: 14, rX: 0, rY: 0, eX: 66, eY: 14),
            Items(lX: 21, lY: 55, rX: 0, rY: -15, eX: 21, eY: 70),
            Items(lX: 65, lY: 35, rX: -100, rY: 28, eX: 165, eY: 7),
            Items(lX: 57, lY: 81, rX: -77, rY: 0, eX: 134, eY: 81),
            Items(lX: 3, lY: 94, rX: -45, rY: -23, eX: 48, eY: 117),
            Items(lX: 79, lY: 0, rX: 54, rY: -45, eX: 25, eY: 45),
            Items(lX: 14, lY: 0, rX: 0, rY: -26, eX: 14, eY: 26),
            Items(lX: 11, lY: 0, rX: -99, rY: -95, eX: 110, eY: 95),
            Items(lX: 80, lY: -52, rX: 72, rY: -76, eX: 8, eY: 24),
            Items(lX: 59, lY: -84, rX: 0, rY: -29, eX: 59, eY: -55),
            Items(lX: 79, lY: -41, rX: -80, rY: -28, eX: 159, eY: -13),
            Items(lX: 0, lY: 67, rX: -57, rY: 28, eX: 57, eY: 39),
            Items(lX: 0, lY: 25, rX: -77, rY: 0, eX: 77, eY: 25),
            Items(lX: 0, lY: 27, rX: -25, rY: -67, eX: 25, eY: 94),
            Items(lX: 0, lY: 0, rX: -49, rY: -85, eX: 49, eY: 85),
            Items(lX: 0, lY: -82, rX: -22, rY: -88, eX: 22, eY: 6),
            Items(lX: -11, lY: 22, rX: -38, rY: 19, eX: 27, eY: 3),
            Items(lX: -25, lY: 87, rX: -28, rY: 0, eX: 3, eY: 87),
            Items(lX: -83, lY: 30, rX: -69, rY: -58, eX: -14, eY: 88),
            Items(lX: -83, lY: 0, rX: -82, rY: -58, eX: -1, eY: 58),
            Items(lX: -55, lY: -3, rX: -79, rY: -50, eX: 24, eY: 47)
        ]
        assertEquaItemsArray()
    }
    
    func testGreaterXSameY() {
        itemsArray = [
            Items(lX: 92, lY: 100, rX: 45, rY: 100, eX: 47, eY: 0),
            Items(lX: 47, lY: 55, rX: 0, rY: 55, eX: 47, eY: 0),
            Items(lX: 67, lY: 63, rX: -82, rY: 63, eX: 149, eY: 0),
            Items(lX: 45, lY: 0, rX: 41, rY: 0, eX: 4, eY: 0),
            Items(lX: 7, lY: 0, rX: 0, rY: 0, eX: 7, eY: 0),
            Items(lX: 1, lY: 0, rX: -45, rY: 0, eX: 46, eY: 0),
            Items(lX: 3, lY: 71, rX: 3, rY: 71, eX: 0, eY: 0),
            Items(lX: 18, lY: 64, rX: 0, rY: 64, eX: 18, eY: 0),
            Items(lX: 65, lY: 32, rX: -40, rY: 32, eX: 105, eY: 0),
            Items(lX: 0, lY: 65, rX: 0, rY: 65, eX: 0, eY: 0),
            Items(lX: 0, lY: 39, rX: 0, rY: 39, eX: 0, eY: 0),
            Items(lX: 0, lY: 36, rX: -3, rY: 36, eX: 3, eY: 0),
            Items(lX: 0, lY: 0, rX: 0, rY: 0, eX: 0, eY: 0),
            Items(lX: 0, lY: 0, rX: 0, rY: 0, eX: 0, eY: 0),
            Items(lX: 0, lY: 0, rX: -32, rY: 0, eX: 32, eY: 0),
            Items(lX: 0, lY: 61, rX: 0, rY: 61, eX: 0, eY: 0),
            Items(lX: 0, lY: 58, rX: 0, rY: 58, eX: 0, eY: 0),
            Items(lX: 0, lY: 3, rX: -67, rY: 3, eX: 67, eY: 0),
            Items(lX: -2, lY: 42, rX: 0, rY: 42, eX: -2, eY: 0),
            Items(lX: -65, lY: 96, rX: -46, rY: 96, eX: -19, eY: 0),
            Items(lX: -59, lY: 0, rX: 0, rY: 0, eX: -59, eY: 0),
            Items(lX: -67, lY: 0, rX: -79, rY: 0, eX: 12, eY: 0),
            Items(lX: -56, lY: 50, rX: 0, rY: 50, eX: -56, eY: 0),
            Items(lX: -1, lY: 56, rX: -26, rY: 56, eX: 25, eY: 0)
        ]
        assertEquaItemsArray()
    }
    
    func testGreaterXSmallerY() {
        itemsArray = [
            Items(lX: 41, lY: 7, rX: 33, rY: 24, eX: 8, eY: -17),
            Items(lX: 66, lY: 5, rX: 0, rY: 38, eX: 66, eY: -33),
            Items(lX: 84, lY: 52, rX: -80, rY: 76, eX: 164, eY: -24),
            Items(lX: 99, lY: 0, rX: 39, rY: 71, eX: 60, eY: -71),
            Items(lX: 54, lY: 0, rX: 0, rY: 74, eX: 54, eY: -74),
            Items(lX: 22, lY: 0, rX: -83, rY: 39, eX: 105, eY: -39),
            Items(lX: 71, lY: 0, rX: -44, rY: 0, eX: 115, eY: 0),
            Items(lX: 10, lY: -97, rX: 3, rY: 39, eX: 7, eY: -136),
            Items(lX: 39, lY: -35, rX: 4, rY: 0, eX: 35, eY: -35),
            Items(lX: 53, lY: -97, rX: 23, rY: -85, eX: 30, eY: -12),
            Items(lX: 94, lY: -81, rX: 0, rY: 82, eX: 94, eY: -163),
            Items(lX: 8, lY: -48, rX: 0, rY: 0, eX: 8, eY: -48),
            Items(lX: 15, lY: -98, rX: 0, rY: -88, eX: 15, eY: -10),
            Items(lX: 13, lY: -62, rX: -75, rY: 56, eX: 88, eY: -118),
            Items(lX: 11, lY: -90, rX: -5, rY: 0, eX: 16, eY: -90),
            Items(lX: 93, lY: -88, rX: -22, rY: -87, eX: 115, eY: -1),
            Items(lX: 0, lY: 12, rX: 0, rY: 64, eX: 0, eY: -52),
            Items(lX: 0, lY: 1, rX: -46, rY: 70, eX: 46, eY: -69),
            Items(lX: 0, lY: 0, rX: 0, rY: 18, eX: 0, eY: -18),
            Items(lX: 0, lY: 0, rX: -48, rY: 36, eX: 48, eY: -36),
            Items(lX: 0, lY: -21, rX: 0, rY: 24, eX: 0, eY: -45),
            Items(lX: 0, lY: -21, rX: 0, rY: 0, eX: 0, eY: -21),
            Items(lX: 0, lY: -36, rX: 0, rY: -24, eX: 0, eY: -12),
            Items(lX: 0, lY: -35, rX: -1, rY: 49, eX: 1, eY: -84),
            Items(lX: 0, lY: -93, rX: -45, rY: 0, eX: 45, eY: -93),
            Items(lX: 0, lY: -77, rX: -53, rY: -17, eX: 53, eY: -60),
            Items(lX: -77, lY: 14, rX: -83, rY: 96, eX: 6, eY: -82),
            Items(lX: -39, lY: 0, rX: -99, rY: 24, eX: 60, eY: -24),
            Items(lX: -62, lY: -23, rX: -90, rY: 33, eX: 28, eY: -56),
            Items(lX: -31, lY: -35, rX: -88, rY: 0, eX: 57, eY: -35),
            Items(lX: -1, lY: -75, rX: -10, rY: -66, eX: 9, eY: -9)
        ]
        assertEquaItemsArray()
    }
    
    func testSameXGreaterY() {
        itemsArray = [
            Items(lX: 38, lY: 79, rX: 23, rY: 19, eX: 15, eY: 60),
            Items(lX: 70, lY: 49, rX: 34, rY: -64, eX: 36, eY: 113),
            Items(lX: 33, lY: 0, rX: 26, rY: -32, eX: 7, eY: 32),
            Items(lX: 59, lY: -15, rX: 13, rY: -99, eX: 46, eY: 84),
            Items(lX: -70, lY: 28, rX: -70, rY: 8, eX: 0, eY: 20),
            Items(lX: -61, lY: 91, rX: -61, rY: -15, eX: 0, eY: 106),
            Items(lX: -8, lY: 0, rX: -8, rY: -40, eX: 0, eY: 40),
            Items(lX: -45, lY: -74, rX: -45, rY: -80, eX: 0, eY: 6)
        ]
        assertEquaItemsArray()
    }
    
    func testSameXSameY() {
        itemsArray = [
            Items(lX: 97, lY: 41, rX: 97, rY: 41, eX: 0, eY: 0),
            Items(lX: 82, lY: 0, rX: 82, rY: 0, eX: 0, eY: 0),
            Items(lX: 59, lY: -29, rX: 59, rY: -29, eX: 0, eY: 0),
            Items(lX: 0, lY: 77, rX: 0, rY: 77, eX: 0, eY: 0),
            Items(lX: 0, lY: 0, rX: 0, rY: 0, eX: 0, eY: 0),
            Items(lX: 0, lY: -21, rX: 0, rY: -21, eX: 0, eY: 0),
            Items(lX: -4, lY: 28, rX: -4, rY: 28, eX: 0, eY: 0),
            Items(lX: -73, lY: 0, rX: -73, rY: 0, eX: 0, eY: 0),
            Items(lX: -27, lY: -38, rX: -27, rY: -38, eX: 0, eY: 0)
        ]
        assertEquaItemsArray()
    }
    
    func testSameXSmallerY() {
        itemsArray = [
            Items(lX: 75, lY: 73, rX: 75, rY: 22, eX: 0, eY: 51),
            Items(lX: 49, lY: 8, rX: 49, rY: 0, eX: 0, eY: 8),
            Items(lX: 39, lY: 47, rX: 39, rY: -23, eX: 0, eY: 70),
            Items(lX: 4, lY: 0, rX: 4, rY: -33, eX: 0, eY: 33),
            Items(lX: 81, lY: -7, rX: 81, rY: -93, eX: 0, eY: 86),
            Items(lX: 0, lY: 42, rX: 0, rY: 24, eX: 0, eY: 18),
            Items(lX: 0, lY: 48, rX: 0, rY: 0, eX: 0, eY: 48),
            Items(lX: 0, lY: 32, rX: 0, rY: -39, eX: 0, eY: 71),
            Items(lX: 0, lY: 0, rX: 0, rY: -91, eX: 0, eY: 91),
            Items(lX: 0, lY: -12, rX: 0, rY: -95, eX: 0, eY: 83),
            Items(lX: -39, lY: 42, rX: -39, rY: 20, eX: 0, eY: 22),
            Items(lX: -44, lY: 53, rX: -44, rY: 0, eX: 0, eY: 53),
            Items(lX: -56, lY: 66, rX: -56, rY: -57, eX: 0, eY: 123),
            Items(lX: -39, lY: 0, rX: -39, rY: -85, eX: 0, eY: 85),
            Items(lX: -13, lY: -97, rX: -13, rY: -98, eX: 0, eY: 1)
        ]
        assertEquaItemsArray()
    }
    
    func testSmallerXGreaterY() {
        itemsArray = [
            Items(lX: 68, lY: 95, rX: 84, rY: 25, eX: -16, eY: 70),
            Items(lX: 98, lY: 14, rX: 99, rY: 0, eX: -1, eY: 14),
            Items(lX: 69, lY: 52, rX: 71, rY: -86, eX: -2, eY: 138),
            Items(lX: 16, lY: 0, rX: 18, rY: -22, eX: -2, eY: 22),
            Items(lX: 26, lY: -71, rX: 86, rY: -73, eX: -60, eY: 2),
            Items(lX: 0, lY: 72, rX: 28, rY: 38, eX: -28, eY: 34),
            Items(lX: 0, lY: 38, rX: 31, rY: 0, eX: -31, eY: 38),
            Items(lX: 0, lY: 38, rX: 48, rY: -27, eX: -48, eY: 65),
            Items(lX: 0, lY: 0, rX: 11, rY: -90, eX: -11, eY: 90),
            Items(lX: 0, lY: -13, rX: 61, rY: -77, eX: -61, eY: 64),
            Items(lX: -65, lY: 38, rX: 98, rY: 7, eX: -163, eY: 31),
            Items(lX: -24, lY: 42, rX: 30, rY: 0, eX: -54, eY: 42),
            Items(lX: -20, lY: 36, rX: 95, rY: -26, eX: -115, eY: 62),
            Items(lX: -95, lY: 58, rX: 0, rY: 44, eX: -95, eY: 14),
            Items(lX: -6, lY: 15, rX: 0, rY: 0, eX: -6, eY: 15),
            Items(lX: -25, lY: 4, rX: 0, rY: -93, eX: -25, eY: 97),
            Items(lX: -90, lY: 58, rX: -87, rY: 54, eX: -3, eY: 4),
            Items(lX: -32, lY: 25, rX: -26, rY: 0, eX: -6, eY: 25),
            Items(lX: -78, lY: 62, rX: -6, rY: -87, eX: -72, eY: 149),
            Items(lX: -30, lY: 0, rX: 2, rY: -66, eX: -32, eY: 66),
            Items(lX: -51, lY: 0, rX: 0, rY: -98, eX: -51, eY: 98),
            Items(lX: -24, lY: 0, rX: -21, rY: -64, eX: -3, eY: 64),
            Items(lX: -31, lY: -93, rX: 98, rY: -96, eX: -129, eY: 3),
            Items(lX: -23, lY: -20, rX: 0, rY: -45, eX: -23, eY: 25),
            Items(lX: -15, lY: -3, rX: -8, rY: -63, eX: -7, eY: 60)
        ]
        assertEquaItemsArray()
    }
    
    func testSmallerXSameY() {
        itemsArray = [
            Items(lX: 65, lY: 61, rX: 71, rY: 61, eX: -6, eY: 0),
            Items(lX: 65, lY: 0, rX: 96, rY: 0, eX: -31, eY: 0),
            Items(lX: 21, lY: -62, rX: 92, rY: -62, eX: -71, eY: 0),
            Items(lX: 0, lY: 0, rX: 92, rY: 0, eX: -92, eY: 0),
            Items(lX: 0, lY: -86, rX: 38, rY: -86, eX: -38, eY: 0),
            Items(lX: -6, lY: 34, rX: 20, rY: 34, eX: -26, eY: 0),
            Items(lX: -4, lY: 97, rX: 0, rY: 97, eX: -4, eY: 0),
            Items(lX: -95, lY: 2, rX: -64, rY: 2, eX: -31, eY: 0),
            Items(lX: -62, lY: 0, rX: 65, rY: 0, eX: -127, eY: 0),
            Items(lX: -53, lY: 0, rX: 0, rY: 0, eX: -53, eY: 0),
            Items(lX: -68, lY: 0, rX: -56, rY: 0, eX: -12, eY: 0),
            Items(lX: -72, lY: -21, rX: 96, rY: -21, eX: -168, eY: 0),
            Items(lX: -29, lY: -1, rX: 0, rY: -1, eX: -29, eY: 0),
            Items(lX: -55, lY: -38, rX: -14, rY: -38, eX: -41, eY: 0)
        ]
        assertEquaItemsArray()
    }
    
    func testSmallerXSmallerY() {
        itemsArray = [
            Items(lX: 27, lY: 74, rX: 53, rY: 98, eX: -26, eY: -24),
            Items(lX: 99, lY: 0, rX: 99, rY: 81, eX: 0, eY: -81),
            Items(lX: 37, lY: -57, rX: 80, rY: 27, eX: -43, eY: -84),
            Items(lX: 91, lY: -78, rX: 97, rY: 0, eX: -6, eY: -78),
            Items(lX: 57, lY: -48, rX: 98, rY: -32, eX: -41, eY: -16),
            Items(lX: 0, lY: 92, rX: 87, rY: 95, eX: -87, eY: -3),
            Items(lX: 0, lY: 0, rX: 95, rY: 84, eX: -95, eY: -84),
            Items(lX: 0, lY: -13, rX: 79, rY: 83, eX: -79, eY: -96),
            Items(lX: 0, lY: -85, rX: 41, rY: 0, eX: -41, eY: -85),
            Items(lX: 0, lY: -46, rX: 90, rY: -5, eX: -90, eY: -41),
            Items(lX: -71, lY: 32, rX: 17, rY: 84, eX: -88, eY: -52),
            Items(lX: -92, lY: 37, rX: 0, rY: 37, eX: -92, eY: 0),
            Items(lX: -86, lY: 71, rX: -2, rY: 95, eX: -84, eY: -24),
            Items(lX: -67, lY: 0, rX: 95, rY: 96, eX: -162, eY: -96),
            Items(lX: -41, lY: 0, rX: 0, rY: 74, eX: -41, eY: -74),
            Items(lX: -80, lY: 0, rX: -79, rY: 50, eX: -1, eY: -50),
            Items(lX: -76, lY: -89, rX: 32, rY: 32, eX: -108, eY: -121),
            Items(lX: -64, lY: -19, rX: 1, rY: 0, eX: -65, eY: -19),
            Items(lX: -22, lY: -63, rX: 59, rY: -8, eX: -81, eY: -55),
            Items(lX: -62, lY: -35, rX: 0, rY: 54, eX: -62, eY: -89),
            Items(lX: -40, lY: -60, rX: 0, rY: 0, eX: -40, eY: -60),
            Items(lX: -85, lY: -69, rX: 0, rY: -42, eX: -85, eY: -27),
            Items(lX: -38, lY: -50, rX: -14, rY: 82, eX: -24, eY: -132),
            Items(lX: -11, lY: -61, rX: -8, rY: 0, eX: -3, eY: -61),
            Items(lX: -74, lY: -57, rX: -46, rY: -46, eX: -28, eY: -11)
        ]
        assertEquaItemsArray()
    }
    
    func assertEquaItemsArray() {
        for items in itemsArray {
            XCTAssertEqual(items.left - items.right, items.expected)
        }
    }
}
