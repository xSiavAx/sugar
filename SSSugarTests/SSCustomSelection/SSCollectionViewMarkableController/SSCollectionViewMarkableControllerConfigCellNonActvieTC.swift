import XCTest
@testable import SSSugar

class SSCollectionViewMarkableControllerConfigCellNonActvieTC: XCTestCase {
    let testsHelper = SSCollectionViewMarkableControllerTestsHelper()
    var sut: SSCollectionViewMarkableControllerTestsSUT!
    
    override func setUp() {
        sut = testsHelper.makeSUT()
    }
    
    func testConfigCellMark() {
        let cell = sut.collection.cells[0]
        testCell(cell, with: sut.controller, marked: true, expected: expectedMarkedCell())
    }
    
    func testConfigCellUnmark() {
        let cell = sut.collection.cells[0]
        testCell(cell, with: sut.controller, marked: false, expected: expectedUnmarkedCell())
    }
    
    func testConfigOutOfViewPortCellMark() {
        let cell = sut.collection.cells[sut.collection.viewPortRows]
        testCell(cell, with: sut.controller, marked: true, expected: expectedMarkedCell())
    }
    
    func testConfigOutOfViewPortCellUnmark() {
        let cell = sut.collection.cells[sut.collection.viewPortRows]
        testCell(cell, with: sut.controller, marked: false, expected: expectedUnmarkedCell())
    }
    
    func testConfigOutOfViewPortCellActiveMark() {
        let cell = sut.collection.cells[sut.collection.viewPortRows]
        cell.marking = true
        testCell(cell, with: sut.controller, marked: true, expected: expectedMarkedCell())
    }
    
    func testConfigOutOfViewPortCellMarkedMark() {
        let cell = sut.collection.cells[sut.collection.viewPortRows]
        cell.marking = true
        cell.marked = true
        testCell(cell, with: sut.controller, marked: true, expected: expectedMarkedCell())
    }
    
    func testConfigOutOfViewPortCellActiveUnmark() {
        let cell = sut.collection.cells[sut.collection.viewPortRows]
        cell.marking = true
        testCell(cell, with: sut.controller, marked: false, expected: expectedUnmarkedCell())
    }
    
    func testConfigOutOfViewPortCellMarkedUnmark() {
        let cell = sut.collection.cells[sut.collection.viewPortRows]
        cell.marking = true
        cell.marked = true
        testCell(cell, with: sut.controller, marked: false, expected: expectedUnmarkedCell())
    }
    
    func testCell(_ cell: SSCollectionViewMarkableCellStub, with controller: SSCollectionViewMarkableController, marked: Bool, expected: SSCollectionViewMarkableCellStub) {
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
