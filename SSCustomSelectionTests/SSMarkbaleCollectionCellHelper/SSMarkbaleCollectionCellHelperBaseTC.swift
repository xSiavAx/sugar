import XCTest
@testable import SSSugar

class SSMarkbaleCollectionCellHelperBaseTC: XCTestCase {
    var cellHelper: SSMarkbaleCollectionCellHelper!
    var cell: UIView!
    var content: UIView!
    
    override func setUp() {
        cell    = UIView()
        content = UIView()
        
        cell.addSubview(content)
        
        cellHelper = SSMarkbaleCollectionCellHelper(cell: cell, contentView: content, markedImage: UIImage(), emptyImage: UIImage())
    }
    
    override func tearDown() {
        cellHelper = nil
    }
    
    func checkCell(marking: Bool, marked: Bool) {
        XCTAssertEqual(cellHelper.marking, marking)
        XCTAssertEqual(cellHelper.marked, marked)
    }
}
