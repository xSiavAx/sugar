import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperActivateTC: SSMarkbaleCollectionCellHelperBaseTC {
    func testActivate() {
        testableCellHelper.setMarking(true)
        
        XCTAssertEqual(testableCellHelper.marking, true)
        XCTAssertEqual(testableCellHelper.marked, false)
    }
    
    func testActivateExplicitNonAnimated() {
        testableCellHelper.setMarking(true, animated: false)
        
        XCTAssertEqual(testableCellHelper.marking, true)
        XCTAssertEqual(testableCellHelper.marked, false)
    }
    
    func testActivateAnimated() {
        testableCellHelper.setMarking(true, animated: true)
        
        XCTAssertEqual(testableCellHelper.marking, true)
        XCTAssertEqual(testableCellHelper.marked, false)
    }

}
