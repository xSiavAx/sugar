import XCTest
@testable import SSSugarUIKit

struct SSMarkbaleCollectionCellHelperTestHelper {
    func makeCellHelper() -> SSMarkbaleCollectionCellHelper {
        let cell = UIView()
        let content = UIView()
        
        cell.addSubview(content)
        
        return SSMarkbaleCollectionCellHelper(cell: cell, contentView: content, markedImage: UIImage(), emptyImage: UIImage())
    }
    
    func checkCell(_ cellHelper: SSMarkbaleCollectionCellHelper, marking: Bool, marked: Bool) {
        XCTAssertEqual(cellHelper.marking, marking)
        XCTAssertEqual(cellHelper.marked, marked)
    }
}
