import XCTest
@testable import SSSugar

class SSCollectionViewMarkableControllerDeactivateTC: XCTestCase {
    let testsHelper = SSCollectionViewMarkableControllerTestsHelper()
    var suts = [SSCollectionViewMarkableControllerTestsSUT]()
    
    override func setUp() {
        suts = [
            testsHelper.makeSUT(withActiveController: true),
            testsHelper.makeSUT(withActiveController: false)
        ]
    }
    
    func testDeactivate() {
        suts.forEach { sut in
            sut.controller.setActive(false)
            testsHelper.checkSUT(sut, active: false, cells: expectedDeactivateCells())
        }
    }
    
    func testDeactivateViaProp() {
        suts.forEach { sut in
            sut.controller.active = false
            testsHelper.checkSUT(sut, active: false, cells: expectedDeactivateCells())
        }
    }
    
    func testDeactivateAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(false, animated: true)
            testsHelper.checkSUT(sut, active: false, cells: expectedDeactivateCells())
        }
    }
    
    func testDeactivateExplicitNonAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(false, animated: false)
            testsHelper.checkSUT(sut, active: false, cells: expectedDeactivateCells())
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
