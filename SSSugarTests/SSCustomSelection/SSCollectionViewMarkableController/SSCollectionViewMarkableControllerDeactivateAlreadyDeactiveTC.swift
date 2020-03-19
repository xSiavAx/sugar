import XCTest
@testable import SSSugar

class SSCollectionViewMarkableControllerDeactivateTC: XCTestCase {
    let testsHelper = SSCollectionViewMarkableControllerTestsHelper()
    var suts = [SSCollectionViewMarkableControllerTestsSUT]()
    
    override func setUp() {
        let sut = testsHelper.makeSUT {
            $0.controller.setActive(true)
        }
        let alreadyDeactiveSUT = testsHelper.makeSUT()
        
        suts = [sut, alreadyDeactiveSUT]
    }
    
    func testActivateViaProp() {
        suts.forEach { sut in
            sut.controller.active = false
            testsHelper.checkSUT(sut, active: false, cells: expectedCells())
        }
    }
    
    func testActivate() {
        suts.forEach { sut in
            sut.controller.setActive(false)
            testsHelper.checkSUT(sut, active: false, cells: expectedCells())
        }
    }
    
    func testActivateAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(false, animated: true)
            testsHelper.checkSUT(sut, active: false, cells: expectedCells())
        }
    }
    
    func testActivateExplicitNonAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(false, animated: false)
            testsHelper.checkSUT(sut, active: false, cells:expectedCells())
        }
    }
    
    func expectedCells() -> [SSCollectionViewMarkableCellStub] {
        return [SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false)]
    }
}
