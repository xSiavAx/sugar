import XCTest
@testable import SSSugarUIKit

class SSCollectionViewMarkableControllerConfigCellTC: XCTestCase {
    let testHelper = SSCollectionViewMarkableControllerTestHelper()
    var suts = [SSCollectionViewMarkableControllerTestsSUT]()
    
    override func setUp() {
        suts = [
            testHelper.makeSUT(withActiveController: true),
            testHelper.makeSUT(withActiveController: false)
        ]
    }
    
    func testConfigCellMark() {
        suts.forEach { sut in
            let cell = sut.collection.cells[0]
            
            testCell(cell, with: sut.controller, marked: true, expected: expectedMarkedCell(for: sut))
        }
    }
    
    func testConfigCellUnmark() {
        suts.forEach { sut in
            let cell = sut.collection.cells[0]
            
            testCell(cell, with: sut.controller, marked: false, expected: expectedUnmarkedCell(for: sut))
        }
    }
    
    func testConfigOutOfViewPortCellMark() {
        suts.forEach { sut in
            let cell = sut.collection.cells[sut.collection.viewPortRows]
            
            testCell(cell, with: sut.controller, marked: true, expected: expectedMarkedCell(for: sut))
        }
    }
    
    func testConfigOutOfViewPortCellUnmark() {
        suts.forEach { sut in
            let cell = sut.collection.cells[sut.collection.viewPortRows]
            
            testCell(cell, with: sut.controller, marked: false, expected: expectedUnmarkedCell(for: sut))
        }
    }
    
    func testConfigOutOfViewPortCellActiveMark() {
        suts.forEach { sut in
            let cell = sut.collection.cells[sut.collection.viewPortRows]
            
            cell.marking = true
            testCell(cell, with: sut.controller, marked: true, expected: expectedMarkedCell(for: sut))
        }
    }
    
    func testConfigOutOfViewPortCellMarkedMark() {
        suts.forEach { sut in
            let cell = sut.collection.cells[sut.collection.viewPortRows]
            
            cell.marking = true
            cell.marked = true
            testCell(cell, with: sut.controller, marked: true, expected: expectedMarkedCell(for: sut))
        }
    }
    
    func testConfigOutOfViewPortCellActiveUnmark() {
        suts.forEach { sut in
            let cell = sut.collection.cells[sut.collection.viewPortRows]
            
            cell.marking = true
            testCell(cell, with: sut.controller, marked: false, expected: expectedUnmarkedCell(for: sut))
        }
    }
    
    func testConfigOutOfViewPortCellMarkedUnmark() {
        suts.forEach { sut in
            let cell = sut.collection.cells[sut.collection.viewPortRows]
            
            cell.marking = true
            cell.marked = true
            testCell(cell, with: sut.controller, marked: false, expected: expectedUnmarkedCell(for: sut))
        }
    }
    
    func testCell(_ cell: SSCollectionViewMarkableCellStub, with controller: SSCollectionViewMarkableController, marked: Bool, expected: SSCollectionViewMarkableCellStub) {
        controller.configCell(cell, marked: marked)
        XCTAssertEqual(cell, expected)
    }
    
    func expectedMarkedCell(for sut: SSCollectionViewMarkableControllerTestsSUT) -> SSCollectionViewMarkableCellStub {
        if sut.controller.active {
            return SSCollectionViewMarkableCellStub(marking: true, marked: true)
        }
        return SSCollectionViewMarkableCellStub()
    }
    
    func expectedUnmarkedCell(for sut: SSCollectionViewMarkableControllerTestsSUT) -> SSCollectionViewMarkableCellStub {
        if sut.controller.active {
            return SSCollectionViewMarkableCellStub(marking: true, marked: false)
        }
        return SSCollectionViewMarkableCellStub()
    }
}
