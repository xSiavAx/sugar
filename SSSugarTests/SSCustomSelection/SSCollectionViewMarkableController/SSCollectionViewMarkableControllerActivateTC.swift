import XCTest
@testable import SSSugar

class SSCollectionViewMarkableControllerActivateTC: XCTestCase {
    let testsHelper = SSCollectionViewMarkableControllerTestsHelper()
    var suts = [SSCollectionViewMarkableControllerTestsSUT]()
    
    override func setUp() {
        suts = [
            testsHelper.makeSUT(withActiveController: false),
            testsHelper.makeSUT(withActiveController: true)
        ]
    }
    
    func testActivate() {
        suts.forEach { sut in
            sut.controller.setActive(true)
            testsHelper.checkSUT(sut, active: true, cells: expectedActivateCells())
        }
    }
    
    func testActivateViaProp() {
        suts.forEach { sut in
            sut.controller.active = true
            testsHelper.checkSUT(sut, active: true, cells: expectedActivateCells())
        }
    }
    
    func testActivateAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(true, animated: true)
            testsHelper.checkSUT(sut, active: true, cells: expectedActivateCells())
        }
    }
    
    func testActivateExplicitNonAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(true, animated: false)
            testsHelper.checkSUT(sut, active: true, cells: expectedActivateCells())
        }
    }
    
    func expectedActivateCells() -> [SSCollectionViewMarkableCellStub] {
        return [SSCollectionViewMarkableCellStub(marking: true, marked: false),
                SSCollectionViewMarkableCellStub(marking: true, marked: false),
                SSCollectionViewMarkableCellStub(marking: true, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false)]
    }
}
