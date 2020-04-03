/*

Tests for CGSize extension added(to:verticaly:)

[Done] difference
   [Done] left.width > right.width && left.height > right.height
   [Done] left.width > right.width && left.height = right.height
   [Done] left.width > right.width && left.height < right.height
   [Done] left.width = right.width && left.height > right.height
   [Done] left.width = right.width && left.height = right.height
   [Done] left.width = right.width && left.height < right.height
   [Done] left.width < right.width && left.height > right.height
   [Done] left.width < right.width && left.height = right.height
   [Done] left.width < right.width && left.height < right.height
[Done] left
   [Done] width > 0 && height > 0
   [Done] width > 0 && height = 0
   [Done] width > 0 && height < 0
   [Done] width = 0 && height > 0
   [Done] width = 0 && height = 0
   [Done] width = 0 && height < 0
   [Done] width < 0 && height > 0
   [Done] width < 0 && height = 0
   [Done] width < 0 && height < 0
[Done] right
   [Done] width > 0 && height > 0
   [Done] width > 0 && height = 0
   [Done] width > 0 && height < 0
   [Done] width = 0 && height > 0
   [Done] width = 0 && height = 0
   [Done] width = 0 && height < 0
   [Done] width < 0 && height > 0
   [Done] width < 0 && height = 0
   [Done] width < 0 && height < 0
[Done] not vertically

*/

import XCTest
@testable import SSSugar

class CGSizeAddedTests: XCTestCase {
    
    typealias Items = CGSizeTestItems
    
    var itemsArray = [Items]()
    
    func testGreaterWidthGreaterHeight() {
        itemsArray = [
            Items(lW: 345, lH: 783, rW: 0, rH: -17, eW: 345, eH: 766),
            Items(lW: -70, lH: -22, rW: -85, rH: 0, eW: -70, eH: -22),
            Items(lW: 0, lH: 0, rW: -45, rH: -90, eW: 0, eH: -90)
        ]
        assertEqualItemsArray(vertically: true)
    }
    
    func testGreaterWidthSameHeight() {
        itemsArray = [
            Items(lW: 87, lH: 0, rW: 0, rH: 0, eW: 87, eH: 0),
            Items(lW: 23, lH: -34, rW: 13, rH: -34, eW: 23, eH: -68),
            Items(lW: 0, lH: 90, rW: -56, rH: 90, eW: 0, eH: 180)
        ]
        assertEqualItemsArray(vertically: true)
    }
    
    func testGreaterWidthSmallerHeight() {
        itemsArray = [
            Items(lW: 0, lH: 0, rW: -50, rH: 45, eW: 0, eH: 45),
            Items(lW: 0, lH: -45, rW: -30, rH: 0, eW: 0, eH: -45),
            Items(lW: -45, lH: 80, rW: -70, rH: 100, eW: -45, eH: 180)
        ]
        assertEqualItemsArray(vertically: true)
    }
    
    func testSameWidthGreaterHeight() {
        itemsArray = [
            Items(lW: -56, lH: 0, rW: -56, rH: -56, eW: -56, eH: -56),
            Items(lW: 876, lH: 567, rW: 875, rH: 0, eW: 876, eH: 567),
            Items(lW: 0, lH: 900, rW: 0, rH: 100, eW: 0, eH: 1000)
        ]
        assertEqualItemsArray(vertically: true)
    }
    
    func testSameWidthSameHeight() {
        itemsArray = [
            Items(lW: 0, lH: -56, rW: 0, rH: -56, eW: 0, eH: -112),
            Items(lW: 99, lH: 0, rW: 99, rH: 0, eW: 99, eH: 0),
            Items(lW: 190, lH: -80, rW: 190, rH: -80, eW: 190, eH: -160)
        ]
        assertEqualItemsArray(vertically: true)
    }
    
    func testSameWidthSmallerHeight() {
        itemsArray = [
            Items(lW: 0, lH: -70, rW: 0, rH: 0, eW: 0, eH: -70),
            Items(lW: 567, lH: 465, rW: 567, rH: 735, eW: 567, eH: 1200),
            Items(lW: 0, lH: 900, rW: 0, rH: 1000, eW: 0, eH: 1900)
        ]
        assertEqualItemsArray(vertically: true)
    }
    
    func testSmallerWidthBiggerHeight() {
        itemsArray = [
            Items(lW: 890, lH: 0, rW: 900, rH: -90, eW: 900, eH: -90),
            Items(lW: -58, lH: 540, rW: 0, rH: -40, eW: 0, eH: 500),
            Items(lW: -67, lH: -89, rW: -50, rH: -111, eW: -50, eH: -200)
        ]
        assertEqualItemsArray(vertically: true)
    }
    
    func testSmallerWidthSameHeight() {
        itemsArray = [
            Items(lW: 0, lH: 0, rW: 45, rH: 0, eW: 45, eH: 0),
            Items(lW: -4, lH: 90, rW: 45, rH: 90, eW: 45, eH: 180),
            Items(lW: -567, lH: 0, rW: 0, rH: 0, eW: 0, eH: 0)
        ]
        assertEqualItemsArray(vertically: true)
    }
    
    func testSmallerWidthSmallerHeight() {
        itemsArray = [
            Items(lW: -89, lH: 0, rW: 0, rH: 89, eW: 0, eH: 89),
            Items(lW: -90, lH: -670, rW: -56, rH: 0, eW: -56, eH: -670),
            Items(lW: 456, lH: -100, rW: 500, rH: 100, eW: 500, eH: 0)
        ]
        assertEqualItemsArray(vertically: true)
    }
    
    func testGreaterWidthGreaterHeightNotVertically() {
        itemsArray = [
            Items(lW: 345, lH: 783, rW: 0, rH: -17, eW: 345, eH: 783),
            Items(lW: -70, lH: -22, rW: -85, rH: 0, eW: -155, eH: 0),
            Items(lW: 0, lH: 0, rW: -45, rH: -90, eW: -45, eH: 0)
        ]
        assertEqualItemsArray(vertically: false)
    }
    
    func testGreaterWidthSameHeightNotVertically() {
        itemsArray = [
            Items(lW: 87, lH: 0, rW: 0, rH: 0, eW: 87, eH: 0),
            Items(lW: 23, lH: -34, rW: 13, rH: -34, eW: 36, eH: -34),
            Items(lW: 0, lH: 90, rW: -56, rH: 90, eW: -56, eH: 90)
        ]
        assertEqualItemsArray(vertically: false)
    }

    func testGreaterWidthSmallerHeightNotVertically() {
        itemsArray = [
            Items(lW: 0, lH: 0, rW: -50, rH: 45, eW: -50, eH: 45),
            Items(lW: 0, lH: -45, rW: -30, rH: 0, eW: -30, eH: 0),
            Items(lW: -45, lH: 80, rW: -70, rH: 100, eW: -115, eH: 100)
        ]
        assertEqualItemsArray(vertically: false)
    }

    func testSameWidthGreaterHeightNotVertically() {
        itemsArray = [
            Items(lW: -56, lH: 0, rW: -56, rH: -56, eW: -112, eH: 0),
            Items(lW: 876, lH: 567, rW: 875, rH: 0, eW: 1751, eH: 567),
            Items(lW: 0, lH: 900, rW: 0, rH: 100, eW: 0, eH: 900)
        ]
        assertEqualItemsArray(vertically: false)
    }

    func testSameWidthSameHeightNotVertically() {
        itemsArray = [
            Items(lW: 0, lH: -56, rW: 0, rH: -56, eW: 0, eH: -56),
            Items(lW: 99, lH: 0, rW: 99, rH: 0, eW: 198, eH: 0),
            Items(lW: 190, lH: -80, rW: 190, rH: -80, eW: 380, eH: -80)
        ]
        assertEqualItemsArray(vertically: false)
    }

    func testSameWidthSmallerHeightNotVertically() {
        itemsArray = [
            Items(lW: 0, lH: -70, rW: 0, rH: 0, eW: 0, eH: 0),
            Items(lW: 567, lH: 465, rW: 567, rH: 735, eW: 1134, eH: 735),
            Items(lW: 0, lH: 900, rW: 0, rH: 1000, eW: 0, eH: 1000)
        ]
        assertEqualItemsArray(vertically: false)
    }

    func testSmallerWidthBiggerHeightNotVertically() {
        itemsArray = [
            Items(lW: 890, lH: 0, rW: 900, rH: -90, eW: 1790, eH: 0),
            Items(lW: -58, lH: 540, rW: 0, rH: -40, eW: -58, eH: 540),
            Items(lW: -67, lH: -89, rW: -50, rH: -111, eW: -117, eH: -89)
        ]
        assertEqualItemsArray(vertically: false)
    }

    func testSmallerWidthSameHeightNotVertically() {
        itemsArray = [
            Items(lW: 0, lH: 0, rW: 45, rH: 0, eW: 45, eH: 0),
            Items(lW: -4, lH: 90, rW: 45, rH: 90, eW: 41, eH: 90),
            Items(lW: -567, lH: 0, rW: 0, rH: 0, eW: -567, eH: 0)
        ]
        assertEqualItemsArray(vertically: false)
    }

    func testSmallerWidthSmallerHeightNotVertically() {
        itemsArray = [
            Items(lW: -89, lH: 0, rW: 0, rH: 89, eW: -89, eH: 89),
            Items(lW: -90, lH: -670, rW: -56, rH: 0, eW: -146, eH: 0),
            Items(lW: 456, lH: -100, rW: 500, rH: 100, eW: 956, eH: 100)
        ]
        assertEqualItemsArray(vertically: false)
    }
    
    func assertEqualItemsArray(vertically: Bool) {
        for items in itemsArray {
            XCTAssertEqual(items.left.added(to: items.right, vertically: vertically), items.expected)
        }
    }
    
}
