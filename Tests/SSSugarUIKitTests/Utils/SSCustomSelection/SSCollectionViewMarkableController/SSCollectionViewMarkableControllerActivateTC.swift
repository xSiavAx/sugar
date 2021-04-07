import XCTest
@testable import SSSugarUIKit

class SSCollectionViewMarkableControllerActivateTC: XCTestCase {
    let testHelper = SSCollectionViewMarkableControllerTestHelper()
    var suts = [SSCollectionViewMarkableControllerTestsSUT]()
    
    override func setUp() {
        suts = [
            testHelper.makeSUT(withActiveController: false),
            testHelper.makeSUT(withActiveController: true)
        ]
    }
    
    func testActivate() {
        suts.forEach { sut in
            sut.controller.setActive(true)
            testHelper.checkSUT(sut, active: true, cells: expectedActivateCells())
        }
    }
    
    func testActivateViaProp() {
        suts.forEach { sut in
            sut.controller.active = true
            testHelper.checkSUT(sut, active: true, cells: expectedActivateCells())
        }
    }
    
    func testActivateAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(true, animated: true)
            testHelper.checkSUT(sut, active: true, cells: expectedActivateCells())
        }
    }
    
    func testActivateExplicitNonAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(true, animated: false)
            testHelper.checkSUT(sut, active: true, cells: expectedActivateCells())
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
