import XCTest

class SSCollectionViewMarkableControllerConfigCellNonActvieTC: SSCollectionViewMarkableControllerBaseTC {
    func testConfigCellMark() {
        test(cell:collection.cells[0], marked:true, expected:expectedMarkedCell())
    }
    
    func testConfigCellUnmark() {
        test(cell:collection.cells[0], marked:false, expected:expectedUnmarkedCell())
    }
    
    func testConfigOutOfViewPortCellMark() {
        test(cell:collection.cells[collection.viewPortRows], marked:true, expected:expectedMarkedCell())
    }
    
    func testConfigOutOfViewPortCellUnmark() {
        test(cell:collection.cells[collection.viewPortRows], marked:false, expected:expectedUnmarkedCell())
    }
    
    func testConfigOutOfViewPortCellActiveMark() {
        let cell = collection.cells[collection.viewPortRows]
        cell.marking = true
        test(cell:cell, marked:true, expected:expectedMarkedCell())
    }
    
    func testConfigOutOfViewPortCellMarkedMark() {
        let cell = collection.cells[collection.viewPortRows]
        cell.marking = true
        cell.marked = true
        test(cell:cell, marked:true, expected:expectedMarkedCell())
    }
    
    func testConfigOutOfViewPortCellActiveUnmark() {
        let cell = collection.cells[collection.viewPortRows]
        cell.marking = true
        test(cell:cell, marked:false, expected:expectedUnmarkedCell())
    }
    
    func testConfigOutOfViewPortCellMarkedUnmark() {
        let cell = collection.cells[collection.viewPortRows]
        cell.marking = true
        cell.marked = true
        test(cell:cell, marked:false, expected:expectedUnmarkedCell())
    }
    
    func test(cell: SSCollectionViewMarkableCellStub, marked: Bool,  expected: SSCollectionViewMarkableCellStub) {
        controller.configCell(cell, marked: marked)
        XCTAssertEqual(cell, expected)
    }
    
    func expectedMarkedCell() -> SSCollectionViewMarkableCellStub {
        return SSCollectionViewMarkableCellStub()
    }
    
    func expectedUnmarkedCell() -> SSCollectionViewMarkableCellStub {
        return SSCollectionViewMarkableCellStub()
    }
}
