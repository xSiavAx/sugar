import XCTest

class SSMarkbaleCollectionCellHelperMarkNonActiveTC: SSMarkbaleCollectionCellHelperBaseTC {
    func testMarkNonActive() {
        cellHelper.setMarked(true, animated: false)
        
        checkCell(marking: false, marked: false)
    }
    
    func testMarkNonActiveAnimated() {
        cellHelper.setMarked(true, animated: true)
        
        checkCell(marking: false, marked: false)
    }
    
    func testMarkNonActiveExplicitNonAnimated() {
        cellHelper.setMarked(true, animated: false)
        
        checkCell(marking: false, marked: false)
    }

}
