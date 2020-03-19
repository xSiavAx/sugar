import XCTest

class SSCollectionViewMarkableControllerConfigCellTC: SSCollectionViewMarkableControllerConfigCellNonActvieTC {
    override func setUp() {
        super.setUp()
        sut.controller.active = true
    }
    
    override func expectedMarkedCell() -> SSCollectionViewMarkableCellStub {
        return SSCollectionViewMarkableCellStub(marking: true, marked: true)
    }
    
    override func expectedUnmarkedCell() -> SSCollectionViewMarkableCellStub {
        return SSCollectionViewMarkableCellStub(marking: true, marked: false)
    }
}
