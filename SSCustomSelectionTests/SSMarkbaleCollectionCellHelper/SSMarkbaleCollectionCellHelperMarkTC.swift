import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperMarkingTC: SSMarkbaleCollectionCellHelperBaseTC {
    override func setUp() {
        super.setUp()
        testableCellHelper.setMarking(true)
    }
    
    func testMark() {
        testableCellHelper.setMarked(true, animated: false)
        
        XCTAssertEqual(testableCellHelper.marking, true)
        XCTAssertEqual(testableCellHelper.marked, true)
    }
    
    func testMarkAnimated() {
        testableCellHelper.setMarked(true, animated: true)
        
        XCTAssertEqual(testableCellHelper.marking, true)
        XCTAssertEqual(testableCellHelper.marked, true)
    }
    
    func testMarkExplicitNonAnimated() {
        testableCellHelper.setMarked(true, animated: true)
        
        XCTAssertEqual(testableCellHelper.marking, true)
        XCTAssertEqual(testableCellHelper.marked, true)
    }
    
    //add unmark tests
}
