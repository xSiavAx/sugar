import XCTest

class SSCollectionViewMarkableControllerMarkNonActiveTC: XCTestCase {
    let testsHelper = SSCollectionViewMarkableControllerTestsHelper()
    var sut: SSCollectionViewMarkableControllerTestsSUT!
    
    override func setUp() {
        sut = testsHelper.makeSUT()
        sut.collection.viewPortOffset = 1
    }

    func testMarkOneBeforeVP() {
        sut.controller.setCellMarked(true, at: IndexPath(row: 0, section: 0))
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedMarkOneBeforeVPCells())
    }
    
    func testMarkOne() {
        sut.controller.setCellMarked(true, at: IndexPath(row: 2, section: 0))
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedMarkOneCells())
    }
    
    func testMarkOneAfterVp() {
        sut.controller.setCellMarked(true, at: IndexPath(row: 4, section: 0))
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedMarkOneAfterCells())
    }
    
    func testMarkLowerVPBound() {
        sut.controller.setCellsMarked(true, at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedMarkLowerVPBoundCells())
    }
    
    func testMark() {
        sut.controller.setCellsMarked(true, at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)])
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedMarkCells())
    }
    
    func testMarkUpperVPBound() {
        sut.controller.setCellsMarked(true, at: [IndexPath(row: 3, section: 0), IndexPath(row: 4, section: 0)])
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedMarkUpperVPBoundCells())
    }
    
    func testMarkAll() {
        sut.controller.setAllCellsMarked(true)
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedMarkAllCells())
    }
    
    func testUnMarkOneBeforeVP() {
        sut.controller.setCellMarked(false, at: IndexPath(row: 0, section: 0))
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedUnMarkOneBeforeVPCells())
    }
    
    func testUnMarkOne() {
        sut.controller.setCellMarked(false, at: IndexPath(row: 2, section: 0))
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedUnMarkOneCells())
    }
    
    func testUnMarkOneAfterVp() {
        sut.controller.setCellMarked(false, at: IndexPath(row: 4, section: 0))
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedUnMarkOneAfterCells())
    }
    
    func testUnMarkLowerVPBound() {
        sut.controller.setCellsMarked(false, at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedUnMarkLowerVPBoundCells())
    }
    
    func testUnMark() {
        sut.controller.setCellsMarked(false, at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)])
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedUnMarkCells())
    }
    
    func testUnMarkUpperVPBound() {
        sut.controller.setCellsMarked(false, at: [IndexPath(row: 3, section: 0), IndexPath(row: 4, section: 0)])
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedUnMarkUpperVPBoundCells())
    }
    
    func testUnMarkAll() {
        sut.controller.setAllCellsMarked(false)
        testsHelper.checkSUT(sut, active: expectedActive(), cells: expectedUnMarkAllCells())
    }

    func expectedActive() -> Bool {
        return false
    }
    
    func expectedMarkOneBeforeVPCells() -> [SSCollectionViewMarkableCellStub]  {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedMarkOneCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedMarkOneAfterCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedMarkLowerVPBoundCells() -> [SSCollectionViewMarkableCellStub]  {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedMarkCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedMarkUpperVPBoundCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedMarkAllCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedUnMarkOneBeforeVPCells() -> [SSCollectionViewMarkableCellStub]  {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedUnMarkOneCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedUnMarkOneAfterCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedUnMarkLowerVPBoundCells() -> [SSCollectionViewMarkableCellStub]  {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedUnMarkCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedUnMarkUpperVPBoundCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
    
    func expectedUnMarkAllCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub()]
    }
}
