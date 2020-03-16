import XCTest

class SSCollectionViewMarkableControllerMarkNonActiveTC: SSCollectionViewMarkableControllerBaseTC {
    override func setUp() {
        super.setUp()
        collection.viewPortOffset = 1
    }

    func testMarkOneBeforeVP() {
        controller.setCellMarked(true, at: IndexPath(row: 0, section: 0))
        check(active: expectedActive(), cells: expectedMarkOneBeforeVPCells())
    }
    
    func testMarkOne() {
        controller.setCellMarked(true, at: IndexPath(row: 2, section: 0))
        check(active: expectedActive(), cells: expectedMarkOneCells())
    }
    
    func testMarkOneAfterVp() {
        controller.setCellMarked(true, at: IndexPath(row: 4, section: 0))
        check(active: expectedActive(), cells: expectedMarkOneAfterCells())
    }
    
    func testMarkLowerVPBound() {
        controller.setCellsMarked(true, at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
        check(active: expectedActive(), cells: expectedMarkLowerVPBoundCells())
    }
    
    func testMark() {
        controller.setCellsMarked(true, at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)])
        check(active: expectedActive(), cells: expectedMarkCells())
    }
    
    func testMarkUpperVPBound() {
        controller.setCellsMarked(true, at: [IndexPath(row: 3, section: 0), IndexPath(row: 4, section: 0)])
        check(active: expectedActive(), cells: expectedMarkUpperVPBoundCells())
    }
    
    func testMarkAll() {
        controller.setAllCellsMarked(true)
        check(active: expectedActive(), cells: expectedMarkAllCells())
    }
    
    func testUnMarkOneBeforeVP() {
        controller.setCellMarked(false, at: IndexPath(row: 0, section: 0))
        check(active: expectedActive(), cells: expectedUnMarkOneBeforeVPCells())
    }
    
    func testUnMarkOne() {
        controller.setCellMarked(false, at: IndexPath(row: 2, section: 0))
        check(active: expectedActive(), cells: expectedUnMarkOneCells())
    }
    
    func testUnMarkOneAfterVp() {
        controller.setCellMarked(false, at: IndexPath(row: 4, section: 0))
        check(active: expectedActive(), cells: expectedUnMarkOneAfterCells())
    }
    
    func testUnMarkLowerVPBound() {
        controller.setCellsMarked(false, at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
        check(active: expectedActive(), cells: expectedUnMarkLowerVPBoundCells())
    }
    
    func testUnMark() {
        controller.setCellsMarked(false, at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)])
        check(active: expectedActive(), cells: expectedUnMarkCells())
    }
    
    func testUnMarkUpperVPBound() {
        controller.setCellsMarked(false, at: [IndexPath(row: 3, section: 0), IndexPath(row: 4, section: 0)])
        check(active: expectedActive(), cells: expectedUnMarkUpperVPBoundCells())
    }
    
    func testUnMarkAll() {
        controller.setAllCellsMarked(false)
        check(active: expectedActive(), cells: expectedUnMarkAllCells())
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
