import XCTest

class SSCollectionViewMarkableControllerMarkAlreadyMarkedTC: SSCollectionViewMarkableControllerMarkNonActiveTC {
    override func setUp() {
        super.setUp()
        controller.active = true
        controller.setAllCellsMarked(true)
    }
    
    override func expectedActive() -> Bool {
        return true
    }
    
    override func expectedMarkOneBeforeVPCells() -> [SSCollectionViewMarkableCellStub]  {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedMarkOneCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedMarkOneAfterCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedMarkLowerVPBoundCells() -> [SSCollectionViewMarkableCellStub]  {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedMarkCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedMarkUpperVPBoundCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedMarkAllCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedUnMarkOneBeforeVPCells() -> [SSCollectionViewMarkableCellStub]  {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedUnMarkOneCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: false),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedUnMarkOneAfterCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedUnMarkLowerVPBoundCells() -> [SSCollectionViewMarkableCellStub]  {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: false),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedUnMarkCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: false),
            SSCollectionViewMarkableCellStub(marking: true, marked: false),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedUnMarkUpperVPBoundCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: true),
            SSCollectionViewMarkableCellStub(marking: true, marked: false),
            SSCollectionViewMarkableCellStub()]
    }
    
    override func expectedUnMarkAllCells() -> [SSCollectionViewMarkableCellStub] {
        return [
            SSCollectionViewMarkableCellStub(),
            SSCollectionViewMarkableCellStub(marking: true, marked: false),
            SSCollectionViewMarkableCellStub(marking: true, marked: false),
            SSCollectionViewMarkableCellStub(marking: true, marked: false),
            SSCollectionViewMarkableCellStub()]
    }
}
