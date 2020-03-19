import XCTest
@testable import SSSugar

class SSCollectionViewMarkableControllerActivateTC: XCTestCase {
    let testsHelper = SSCollectionViewMarkableControllerTestsHelper()
    var suts = [SSCollectionViewMarkableControllerTestsSUT]()
    
    override func setUp() {
        let sut = testsHelper.makeSUT()
        let alreadyActiveSUT = testsHelper.makeSUT {
            $0.controller.setActive(true)
        }
        
        suts = [sut, alreadyActiveSUT]
    }
    
    func testActivate() {
        suts.forEach { sut in
            sut.controller.setActive(true)
            testsHelper.checkSUT(sut, active: true, cells: expectedCells())
        }
    }
    
    func testActivateAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(true, animated: true)
            testsHelper.checkSUT(sut, active: true, cells: expectedCells())
        }
    }
    
    func testActivateExplicitNonAnimated() {
        suts.forEach { sut in
            sut.controller.setActive(true, animated: false)
            testsHelper.checkSUT(sut, active: true, cells: expectedCells())
        }
    }
    
    func expectedCells() -> [SSCollectionViewMarkableCellStub] {
        return [SSCollectionViewMarkableCellStub(marking: true, marked: false),
                SSCollectionViewMarkableCellStub(marking: true, marked: false),
                SSCollectionViewMarkableCellStub(marking: true, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false)]
    }
}
