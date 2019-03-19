import XCTest

class SSMarkbaleCollectionCellHelperMarkNonActiveTC: SSMarkbaleCollectionCellHelperBaseTC {
    func testMarkNonActive() {
        testableCellHelper.setMarked(true, animated: false)
        
        XCTAssertEqual(testableCellHelper.marking, false)
        XCTAssertEqual(testableCellHelper.marked, false)
    }
    
    func testMarkNonActiveAnimated() {
        testableCellHelper.setMarked(true, animated: true)
        
        XCTAssertEqual(testableCellHelper.marking, false)
        XCTAssertEqual(testableCellHelper.marked, false)
    }
    
    func testMarkNonActiveExplicitNonAnimated() {
        testableCellHelper.setMarked(true, animated: false)
        
        XCTAssertEqual(testableCellHelper.marking, false)
        XCTAssertEqual(testableCellHelper.marked, false)
    }

}
