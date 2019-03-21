import XCTest

class SSCollectionViewMarkableControllerActivateTC: SSCollectionViewMarkableControllerBaseTC {
    func testActivateViaProp() {
        controller.active = true
        check(active: true, cells:expectedCells())
    }
    
    func testActivate() {
        controller.setActive(true)
        check(active: true, cells:expectedCells())
    }
    
    func testActivateAnimated() {
        controller.setActive(true, animated: true)
        check(active: true, cells:expectedCells())
    }
    
    func testActivateExplicitNonAnimated() {
        controller.setActive(true, animated: false)
        check(active: true, cells:expectedCells())
    }
    
    func expectedCells() -> [SSCollectionViewMarkableCellStub] {
        return [SSCollectionViewMarkableCellStub(marking: true, marked: false),
                SSCollectionViewMarkableCellStub(marking: true, marked: false),
                SSCollectionViewMarkableCellStub(marking: true, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false)]
    }
}
