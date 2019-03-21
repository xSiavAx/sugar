import XCTest

class SSMarkbaleCollectionCellHelperMarkNonActiveTC: SSMarkbaleCollectionCellHelperBaseTC {
    func testMarkNonActive() {
        testableCellHelper.setMarked(true, animated: false)
        
        checkCell(marking: false, marked: false)
    }
    
    func testMarkNonActiveAnimated() {
        testableCellHelper.setMarked(true, animated: true)
        
        checkCell(marking: false, marked: false)
    }
    
    func testMarkNonActiveExplicitNonAnimated() {
        testableCellHelper.setMarked(true, animated: false)
        
        checkCell(marking: false, marked: false)
    }

}
