import XCTest
@testable import SSSugarUIKIt

class SSCollectionViewMarkableControllerDeactivateTC: XCTestCase {
    let testHelper = SSCollectionViewMarkableControllerTestHelper()
    var suts = [SSCollectionViewMarkableControllerTestsSUT]()
    
    override func setUp() {
        suts = [
            testHelper.makeSUT(withActiveController: true),
            testHelper.makeSUT(withActiveController: false)
        ]
    }
    
    func testDeactivate() {
        suts.forEach { sut in
            sut.controller.setActive(false)
            testHelper.checkSUT(sut, active: false, cells: expectedDeactivateCells())
        }
    }
    
    func testDeactivateViaProp() {
        suts.forEach { sut in
            sut.controller.active = false
            testHelper.checkSUT(sut, active: false, cells: expectedDeactivateCells())
        }
    }
    
    func testDeactivateAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(false, animated: true)
            testHelper.checkSUT(sut, active: false, cells: expectedDeactivateCells())
        }
    }
    
    func testDeactivateExplicitNonAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(false, animated: false)
            testHelper.checkSUT(sut, active: false, cells: expectedDeactivateCells())
        }
    }
    
    func expectedDeactivateCells() -> [SSCollectionViewMarkableCellStub] {
        return [SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false)]
    }
}
