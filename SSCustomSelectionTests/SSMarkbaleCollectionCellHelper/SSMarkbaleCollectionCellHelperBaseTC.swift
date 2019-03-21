import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperBaseTC: XCTestCase {
    var testableCellHelper: SSMarkbaleCollectionCellHelper!
    
    override func setUp() {
        let cell = UIView()
        let content = UIView()
        cell.addSubview(content)
        testableCellHelper = SSMarkbaleCollectionCellHelper(cell: cell, contentView: content, markedImage: UIImage(), emptyImage: UIImage())
    }
    
    override func tearDown() {
        testableCellHelper = nil
    }
    
    func checkCell(marking: Bool, marked: Bool) {
        XCTAssertEqual(testableCellHelper.marking, marking)
        XCTAssertEqual(testableCellHelper.marked, marked)
    }
}
