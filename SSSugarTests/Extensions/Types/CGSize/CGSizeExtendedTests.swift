/*
 
 Tests for CGSize extension extended(by:), extended(dx:dy:), 
 
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
    
 */

import XCTest

class CGSizeExtendedTests: XCTestCase {
    
    var itemsArray = [Items]()
    
    func testPlusWidthPlusHeight() {
        itemsArray = [
            Items(lW: 77, lH: 232, rW: 147, rH: 744, eW: 224, eH: 976),
            Items(lW: 196, lH: 870, rW: 1, rH: 0, eW: 197, eH: 870),
            Items(lW: 313, lH: 927, rW: 826, rH: -712, eW: 1139, eH: 215),
            Items(lW: 795, lH: 432, rW: 0, rH: 155, eW: 795, eH: 587),
            Items(lW: 189, lH: 212, rW: 0, rH: 0, eW: 189, eH: 212),
            Items(lW: 868, lH: 264, rW: 0, rH: -952, eW: 868, eH: -688),
            Items(lW: 180, lH: 768, rW: -998, rH: 385, eW: -818, eH: 1153),
            Items(lW: 864, lH: 427, rW: -906, rH: 0, eW: -42, eH: 427),
            Items(lW: 11, lH: 458, rW: -324, rH: -799, eW: -313, eH: -341)
        ]
        assertEqualItemArray()
    }
    
    func testPlusWidthZeroHeight() {
        itemsArray = [
            Items(lW: 874, lH: 0, rW: 263, rH: 274, eW: 1137, eH: 274),
            Items(lW: 265, lH: 0, rW: 107, rH: 0, eW: 372, eH: 0),
            Items(lW: 257, lH: 0, rW: 393, rH: -399, eW: 650, eH: -399),
            Items(lW: 112, lH: 0, rW: 0, rH: 572, eW: 112, eH: 572),
            Items(lW: 834, lH: 0, rW: 0, rH: 0, eW: 834, eH: 0),
            Items(lW: 391, lH: 0, rW: 0, rH: -98, eW: 391, eH: -98),
            Items(lW: 646, lH: 0, rW: -98, rH: 375, eW: 548, eH: 375),
            Items(lW: 233, lH: 0, rW: -971, rH: 0, eW: -738, eH: 0),
            Items(lW: 625, lH: 0, rW: -428, rH: -324, eW: 197, eH: -324)
        ]
        assertEqualItemArray()
    }
    
    func testPlusWidthMinusHeight() {
        itemsArray = [
            Items(lW: 508, lH: -886, rW: 640, rH: 953, eW: 1148, eH: 67),
            Items(lW: 810, lH: -228, rW: 962, rH: 0, eW: 1772, eH: -228),
            Items(lW: 46, lH: -13, rW: 25, rH: -559, eW: 71, eH: -572),
            Items(lW: 528, lH: -942, rW: 0, rH: 743, eW: 528, eH: -199),
            Items(lW: 1, lH: -353, rW: 0, rH: 0, eW: 1, eH: -353),
            Items(lW: 129, lH: -381, rW: 0, rH: -568, eW: 129, eH: -949),
            Items(lW: 335, lH: -365, rW: -271, rH: 188, eW: 64, eH: -177),
            Items(lW: 370, lH: -918, rW: -495, rH: 0, eW: -125, eH: -918),
            Items(lW: 806, lH: -737, rW: -998, rH: -747, eW: -192, eH: -1484)
        ]
        assertEqualItemArray()
    }
    
    func testZeroWidthPlusHeight() {
        itemsArray = [
            Items(lW: 0, lH: 618, rW: 640, rH: 842, eW: 640, eH: 1460),
            Items(lW: 0, lH: 162, rW: 750, rH: 0, eW: 750, eH: 162),
            Items(lW: 0, lH: 778, rW: 157, rH: -104, eW: 157, eH: 674),
            Items(lW: 0, lH: 929, rW: 0, rH: 135, eW: 0, eH: 1064),
            Items(lW: 0, lH: 752, rW: 0, rH: 0, eW: 0, eH: 752),
            Items(lW: 0, lH: 224, rW: 0, rH: -31, eW: 0, eH: 193),
            Items(lW: 0, lH: 105, rW: -130, rH: 27, eW: -130, eH: 132),
            Items(lW: 0, lH: 340, rW: -439, rH: 0, eW: -439, eH: 340),
            Items(lW: 0, lH: 763, rW: -899, rH: -150, eW: -899, eH: 613)
        ]
        assertEqualItemArray()
    }
    
    func testZeroWidthZeroHeight() {
        itemsArray = [
            Items(lW: 0, lH: 0, rW: 253, rH: 986, eW: 253, eH: 986),
            Items(lW: 0, lH: 0, rW: 601, rH: 0, eW: 601, eH: 0),
            Items(lW: 0, lH: 0, rW: 187, rH: -915, eW: 187, eH: -915),
            Items(lW: 0, lH: 0, rW: 0, rH: 515, eW: 0, eH: 515),
            Items(lW: 0, lH: 0, rW: 0, rH: 0, eW: 0, eH: 0),
            Items(lW: 0, lH: 0, rW: 0, rH: -246, eW: 0, eH: -246),
            Items(lW: 0, lH: 0, rW: -931, rH: 738, eW: -931, eH: 738),
            Items(lW: 0, lH: 0, rW: -178, rH: 0, eW: -178, eH: 0),
            Items(lW: 0, lH: 0, rW: -761, rH: -510, eW: -761, eH: -510)
        ]
        assertEqualItemArray()
    }
    
    func testZeroWidthMinusHeight() {
        itemsArray = [
            Items(lW: 0, lH: -346, rW: 668, rH: 232, eW: 668, eH: -114),
            Items(lW: 0, lH: -29, rW: 118, rH: 0, eW: 118, eH: -29),
            Items(lW: 0, lH: -503, rW: 45, rH: -244, eW: 45, eH: -747),
            Items(lW: 0, lH: -705, rW: 0, rH: 780, eW: 0, eH: 75),
            Items(lW: 0, lH: -603, rW: 0, rH: 0, eW: 0, eH: -603),
            Items(lW: 0, lH: -399, rW: 0, rH: -576, eW: 0, eH: -975),
            Items(lW: 0, lH: -818, rW: -933, rH: 271, eW: -933, eH: -547),
            Items(lW: 0, lH: -757, rW: -224, rH: 0, eW: -224, eH: -757),
            Items(lW: 0, lH: -202, rW: -718, rH: -205, eW: -718, eH: -407)
        ]
        assertEqualItemArray()
    }
    
    func testMinusWidthPlusHeight() {
        itemsArray = [
            Items(lW: -251, lH: 910, rW: 349, rH: 67, eW: 98, eH: 977),
            Items(lW: -909, lH: 498, rW: 559, rH: 0, eW: -350, eH: 498),
            Items(lW: -602, lH: 101, rW: 681, rH: -896, eW: 79, eH: -795),
            Items(lW: -691, lH: 64, rW: 0, rH: 783, eW: -691, eH: 847),
            Items(lW: -178, lH: 270, rW: 0, rH: 0, eW: -178, eH: 270),
            Items(lW: -527, lH: 522, rW: 0, rH: -646, eW: -527, eH: -124),
            Items(lW: -773, lH: 352, rW: -56, rH: 121, eW: -829, eH: 473),
            Items(lW: -705, lH: 230, rW: -89, rH: 0, eW: -794, eH: 230),
            Items(lW: -445, lH: 933, rW: -683, rH: -500, eW: -1128, eH: 433)
        ]
        assertEqualItemArray()
    }
    
    func testMinusWidthZeroHeight() {
        itemsArray = [
            Items(lW: -491, lH: 0, rW: 971, rH: 852, eW: 480, eH: 852),
            Items(lW: -747, lH: 0, rW: 616, rH: 0, eW: -131, eH: 0),
            Items(lW: -472, lH: 0, rW: 636, rH: -468, eW: 164, eH: -468),
            Items(lW: -784, lH: 0, rW: 0, rH: 809, eW: -784, eH: 809),
            Items(lW: -798, lH: 0, rW: 0, rH: 0, eW: -798, eH: 0),
            Items(lW: -170, lH: 0, rW: 0, rH: -175, eW: -170, eH: -175),
            Items(lW: -763, lH: 0, rW: -397, rH: 298, eW: -1160, eH: 298),
            Items(lW: -858, lH: 0, rW: -622, rH: 0, eW: -1480, eH: 0),
            Items(lW: -347, lH: 0, rW: -25, rH: -268, eW: -372, eH: -268)
        ]
        assertEqualItemArray()
    }
    
    func testMinusWidthMinusHeight() {
        itemsArray = [
            Items(lW: -140, lH: -734, rW: 402, rH: 723, eW: 262, eH: -11),
            Items(lW: -143, lH: -28, rW: 984, rH: 0, eW: 841, eH: -28),
            Items(lW: -75, lH: -35, rW: 635, rH: -971, eW: 560, eH: -1006),
            Items(lW: -719, lH: -484, rW: 0, rH: 760, eW: -719, eH: 276),
            Items(lW: -547, lH: -646, rW: 0, rH: 0, eW: -547, eH: -646),
            Items(lW: -660, lH: -507, rW: 0, rH: -597, eW: -660, eH: -1104),
            Items(lW: -521, lH: -9, rW: -850, rH: 485, eW: -1371, eH: 476),
            Items(lW: -69, lH: -882, rW: -577, rH: 0, eW: -646, eH: -882),
            Items(lW: -506, lH: -817, rW: -374, rH: -942, eW: -880, eH: -1759)
        ]
        assertEqualItemArray()
    }
    
    func assertEqualItemArray() {
        for items in itemsArray {
            XCTAssertEqual(items.left.extended(by: items.right), items.expected)
            XCTAssertEqual(items.left.extended(dx: items.dx, dy: items.dy), items.expected)
        }
    }

}


extension CGSizeExtendedTests {

    struct Items {
        
        let left: CGSize
        let right: CGSize
        let expected: CGSize
        
        var dx: CGFloat { right.width }
        var dy: CGFloat { right.height }
        
        init(lW: CGFloat, lH: CGFloat, rW: CGFloat, rH: CGFloat, eW: CGFloat, eH: CGFloat) {
            left = CGSize(width: lW, height: lH)
            right = CGSize(width: rW, height: rH)
            expected = CGSize(width: eW, height: eH)
        }
        
    }
    
}
