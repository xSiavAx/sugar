/*
 Tests for binary plus operator in CGPoint extension
 
 [Done] options of the left point
    [Done] x > 0 & y > 0
    [Done] x > 0 & y = 0
    [Done] x > 0 & y < 0
    [Done] x = 0 & y > 0
    [Done] x = 0 & y = 0
    [Done] x = 0 & y < 0
    [Done] x < 0 & y > 0
    [Done] x < 0 & y = 0
    [Done] x < 0 & y < 0
 [Done] options of the right point
    [Done] x > 0 & y > 0
    [Done] x > 0 & y = 0
    [Done] x > 0 & y < 0
    [Done] x = 0 & y > 0
    [Done] x = 0 & y = 0
    [Done] x = 0 & y < 0
    [Done] x < 0 & y > 0
    [Done] x < 0 & y = 0
    [Done] x < 0 & y < 0
 */

import XCTest
@testable import SSSugar

class CGPointBinaryPlusTests: XCTestCase {
    typealias Items = CGPointTestItems
    
    var itemsArray = [Items]()
    
    func testPlusWidthPlusHeight() {
        itemsArray = [
            Items(lX: 10, lY: 62, rX: 38, rY: 81, eX: 48, eY: 143),
            Items(lX: 97, lY: 79, rX: 13, rY: 0, eX: 110, eY: 79),
            Items(lX: 17, lY: 65, rX: 96, rY: -77, eX: 113, eY: -12),
            Items(lX: 3, lY: 35, rX: 0, rY: 50, eX: 3, eY: 85),
            Items(lX: 96, lY: 71, rX: 0, rY: 0, eX: 96, eY: 71),
            Items(lX: 86, lY: 70, rX: 0, rY: -30, eX: 86, eY: 40),
            Items(lX: 35, lY: 40, rX: -45, rY: 20, eX: -10, eY: 60),
            Items(lX: 29, lY: 84, rX: -49, rY: 0, eX: -20, eY: 84),
            Items(lX: 8, lY: 51, rX: -12, rY: -19, eX: -4, eY: 32)
        ]
        assertEqualItemsArray()
    }
    
    func testPlusWidthZeroHeight() {
        itemsArray = [
            Items(lX: 44, lY: 0, rX: 38, rY: 95, eX: 82, eY: 95),
            Items(lX: 1, lY: 0, rX: 1, rY: 0, eX: 2, eY: 0),
            Items(lX: 79, lY: 0, rX: 80, rY: -36, eX: 159, eY: -36),
            Items(lX: 47, lY: 0, rX: 0, rY: 39, eX: 47, eY: 39),
            Items(lX: 26, lY: 0, rX: 0, rY: 0, eX: 26, eY: 0),
            Items(lX: 8, lY: 0, rX: 0, rY: -99, eX: 8, eY: -99),
            Items(lX: 80, lY: 0, rX: -76, rY: 40, eX: 4, eY: 40),
            Items(lX: 84, lY: 0, rX: -97, rY: 0, eX: -13, eY: 0),
            Items(lX: 56, lY: 0, rX: -26, rY: -78, eX: 30, eY: -78)
        ]
        assertEqualItemsArray()
    }
    
    func testPlusWidthMinusHeight() {
        itemsArray = [
            Items(lX: 89, lY: -66, rX: 80, rY: 24, eX: 169, eY: -42),
            Items(lX: 43, lY: -10, rX: 72, rY: 0, eX: 115, eY: -10),
            Items(lX: 21, lY: -63, rX: 82, rY: -35, eX: 103, eY: -98),
            Items(lX: 94, lY: -29, rX: 0, rY: 12, eX: 94, eY: -17),
            Items(lX: 13, lY: -62, rX: 0, rY: 0, eX: 13, eY: -62),
            Items(lX: 29, lY: -59, rX: 0, rY: -64, eX: 29, eY: -123),
            Items(lX: 27, lY: -2, rX: -88, rY: 32, eX: -61, eY: 30),
            Items(lX: 85, lY: -73, rX: -37, rY: 0, eX: 48, eY: -73),
            Items(lX: 62, lY: -76, rX: -84, rY: -95, eX: -22, eY: -171)
        ]
        assertEqualItemsArray()
    }

    func testZeroWidthPlusHeight() {
        itemsArray = [
            Items(lX: 0, lY: 99, rX: 87, rY: 64, eX: 87, eY: 163),
            Items(lX: 0, lY: 86, rX: 40, rY: 0, eX: 40, eY: 86),
            Items(lX: 0, lY: 25, rX: 63, rY: -56, eX: 63, eY: -31),
            Items(lX: 0, lY: 74, rX: 0, rY: 75, eX: 0, eY: 149),
            Items(lX: 0, lY: 67, rX: 0, rY: 0, eX: 0, eY: 67),
            Items(lX: 0, lY: 11, rX: 0, rY: -11, eX: 0, eY: 0),
            Items(lX: 0, lY: 20, rX: -77, rY: 10, eX: -77, eY: 30),
            Items(lX: 0, lY: 10, rX: -83, rY: 0, eX: -83, eY: 10),
            Items(lX: 0, lY: 51, rX: -8, rY: -33, eX: -8, eY: 18),
        ]
        assertEqualItemsArray()
    }

    func testZeroWidthZeroHeight() {
        itemsArray = [
            Items(lX: 0, lY: 0, rX: 30, rY: 86, eX: 30, eY: 86),
            Items(lX: 0, lY: 0, rX: 94, rY: 0, eX: 94, eY: 0),
            Items(lX: 0, lY: 0, rX: 97, rY: -23, eX: 97, eY: -23),
            Items(lX: 0, lY: 0, rX: 0, rY: 71, eX: 0, eY: 71),
            Items(lX: 0, lY: 0, rX: 0, rY: 0, eX: 0, eY: 0),
            Items(lX: 0, lY: 0, rX: 0, rY: -67, eX: 0, eY: -67),
            Items(lX: 0, lY: 0, rX: -82, rY: 25, eX: -82, eY: 25),
            Items(lX: 0, lY: 0, rX: -42, rY: 0, eX: -42, eY: 0),
            Items(lX: 0, lY: 0, rX: -49, rY: -16, eX: -49, eY: -16)
        ]
        assertEqualItemsArray()
    }

    func testZeroWidthMinusHeight() {
        itemsArray = [
            Items(lX: 0, lY: -95, rX: 47, rY: 54, eX: 47, eY: -41),
            Items(lX: 0, lY: -94, rX: 42, rY: 0, eX: 42, eY: -94),
            Items(lX: 0, lY: -26, rX: 68, rY: -81, eX: 68, eY: -107),
            Items(lX: 0, lY: -15, rX: 0, rY: 81, eX: 0, eY: 66),
            Items(lX: 0, lY: -84, rX: 0, rY: 0, eX: 0, eY: -84),
            Items(lX: 0, lY: -25, rX: 0, rY: -12, eX: 0, eY: -37),
            Items(lX: 0, lY: -95, rX: -42, rY: 5, eX: -42, eY: -90),
            Items(lX: 0, lY: -72, rX: -99, rY: 0, eX: -99, eY: -72),
            Items(lX: 0, lY: -89, rX: -58, rY: -83, eX: -58, eY: -172)
        ]
        assertEqualItemsArray()
    }

    func testMinusWidthPlusHeight() {
        itemsArray = [
            Items(lX: -16, lY: 40, rX: 58, rY: 60, eX: 42, eY: 100),
            Items(lX: -70, lY: 6, rX: 35, rY: 0, eX: -35, eY: 6),
            Items(lX: -83, lY: 81, rX: 59, rY: -56, eX: -24, eY: 25),
            Items(lX: -3, lY: 59, rX: 0, rY: 56, eX: -3, eY: 115),
            Items(lX: -79, lY: 11, rX: 0, rY: 0, eX: -79, eY: 11),
            Items(lX: -84, lY: 87, rX: 0, rY: -59, eX: -84, eY: 28),
            Items(lX: -60, lY: 38, rX: -30, rY: 16, eX: -90, eY: 54),
            Items(lX: -39, lY: 63, rX: -11, rY: 0, eX: -50, eY: 63),
            Items(lX: -26, lY: 44, rX: -38, rY: -45, eX: -64, eY: -1)
        ]
        assertEqualItemsArray()
    }

    func testMinusWidthZeroHeight() {
        itemsArray = [
            Items(lX: -15, lY: 0, rX: 22, rY: 52, eX: 7, eY: 52),
            Items(lX: -42, lY: 0, rX: 35, rY: 0, eX: -7, eY: 0),
            Items(lX: -50, lY: 0, rX: 62, rY: -6, eX: 12, eY: -6),
            Items(lX: -61, lY: 0, rX: 0, rY: 12, eX: -61, eY: 12),
            Items(lX: -92, lY: 0, rX: 0, rY: 0, eX: -92, eY: 0),
            Items(lX: -20, lY: 0, rX: 0, rY: -7, eX: -20, eY: -7),
            Items(lX: -72, lY: 0, rX: -66, rY: 15, eX: -138, eY: 15),
            Items(lX: -55, lY: 0, rX: -18, rY: 0, eX: -73, eY: 0),
            Items(lX: -63, lY: 0, rX: -5, rY: -96, eX: -68, eY: -96)
        ]
        assertEqualItemsArray()
    }

    func testMinusWidthMinusHeight() {
        itemsArray = [
            Items(lX: -72, lY: -8, rX: 63, rY: 7, eX: -9, eY: -1),
            Items(lX: -76, lY: -34, rX: 87, rY: 0, eX: 11, eY: -34),
            Items(lX: -33, lY: -94, rX: 26, rY: -80, eX: -7, eY: -174),
            Items(lX: -41, lY: -82, rX: 0, rY: 72, eX: -41, eY: -10),
            Items(lX: -5, lY: -66, rX: 0, rY: 0, eX: -5, eY: -66),
            Items(lX: -53, lY: -36, rX: 0, rY: -64, eX: -53, eY: -100),
            Items(lX: -43, lY: -62, rX: -64, rY: 67, eX: -107, eY: 5),
            Items(lX: -95, lY: -91, rX: -87, rY: 0, eX: -182, eY: -91),
            Items(lX: -99, lY: -18, rX: -76, rY: -11, eX: -175, eY: -29)
        ]
        assertEqualItemsArray()
    }
    
    func assertEqualItemsArray() {
        for item in itemsArray {
            XCTAssertEqual(item.left + item.right, item.expected)
        }
    }
}
