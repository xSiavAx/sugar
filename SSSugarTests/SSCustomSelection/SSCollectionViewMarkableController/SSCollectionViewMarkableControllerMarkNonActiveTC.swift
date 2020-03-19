import XCTest

#warning("update the file name")
class SSCollectionViewMarkableControllerMarkTC: XCTestCase {
    enum TestDataCase {
        case active
        case deactive
        case activeMarked
    }
    
    typealias TestDataContainer = (sut: SSCollectionViewMarkableControllerTestsSUT, testDataCase: TestDataCase)
    
    let testsHelper = SSCollectionViewMarkableControllerTestsHelper()
    var testDataContainers = [TestDataContainer]()
    
    override func setUp() {
        testDataContainers = [
            makeDeactiveDataContainer(),
            makeActiveDataContainer(),
            makeActiveMarkedDataContainer(),
        ]
    }

    func testMarkOneBeforeVP() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellMarked(true, at: IndexPath(row: 0, section: 0))
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedMarkOneBeforeVPCells(for: testDataCase))
        }
    }

    func testMarkOne() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellMarked(true, at: IndexPath(row: 2, section: 0))
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedMarkOneCells(for: testDataCase))
        }
    }

    func testMarkOneAfterVp() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellMarked(true, at: IndexPath(row: 4, section: 0))
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedMarkOneAfterCells(for: testDataCase))
        }
    }

    func testMarkLowerVPBound() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellsMarked(true, at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedMarkLowerVPBoundCells(for: testDataCase))
        }
    }

    func testMark() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellsMarked(true, at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)])
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedMarkCells(for: testDataCase))
        }
    }

    func testMarkUpperVPBound() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellsMarked(true, at: [IndexPath(row: 3, section: 0), IndexPath(row: 4, section: 0)])
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedMarkUpperVPBoundCells(for: testDataCase))
        }
    }

    func testMarkAll() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setAllCellsMarked(true)
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedMarkAllCells(for: testDataCase))
        }
    }

    func testUnMarkOneBeforeVP() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellMarked(false, at: IndexPath(row: 0, section: 0))
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedUnMarkOneBeforeVPCells(for: testDataCase))
        }
    }

    func testUnMarkOne() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellMarked(false, at: IndexPath(row: 2, section: 0))
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedUnMarkOneCells(for: testDataCase))
        }
    }

    func testUnMarkOneAfterVp() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellMarked(false, at: IndexPath(row: 4, section: 0))
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedUnMarkOneAfterCells(for: testDataCase))
        }
    }

    func testUnMarkLowerVPBound() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellsMarked(false, at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedUnMarkLowerVPBoundCells(for: testDataCase))
        }
    }

    func testUnMark() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellsMarked(false, at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)])
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedUnMarkCells(for: testDataCase))
        }
    }

    func testUnMarkUpperVPBound() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setCellsMarked(false, at: [IndexPath(row: 3, section: 0), IndexPath(row: 4, section: 0)])
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedUnMarkUpperVPBoundCells(for: testDataCase))
        }
    }

    func testUnMarkAll() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let testDataCase = container.testDataCase
            
            sut.controller.setAllCellsMarked(false)
            testsHelper.checkSUT(sut, active: expectedActive(for: testDataCase), cells: expectedUnMarkAllCells(for: testDataCase))
        }
    }

    func expectedActive(for testDataCase: TestDataCase) -> Bool {
        switch testDataCase {
        case .active, .activeMarked:
            return true
        case .deactive:
            return false
        }
    }
    
    // MARK: - Data Containers
    
    func makeDeactiveDataContainer() -> TestDataContainer {
        let sut = testsHelper.makeSUT {
            $0.collection.viewPortOffset = 1
        }
        
        return (sut, .deactive)
    }
    
    func makeActiveDataContainer() -> TestDataContainer {
        let sut = testsHelper.makeSUT {
            $0.collection.viewPortOffset = 1
            $0.controller.active = true
        }
        
        return (sut, .active)
    }
    
    func makeActiveMarkedDataContainer() -> TestDataContainer {
        let sut = testsHelper.makeSUT {
            $0.collection.viewPortOffset = 1
            $0.controller.active = true
            $0.controller.setAllCellsMarked(true)
        }
        
        return (sut, .activeMarked)
    }
    
    // MARK: - Expected Cell Stub
    
    typealias CellStub = SSCollectionViewMarkableCellStub
    
    func expectedMarkOneBeforeVPCells(for testDataCase: TestDataCase) -> [CellStub]  {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedMarkOneCells(for testDataCase: TestDataCase) -> [CellStub] {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedMarkOneAfterCells(for testDataCase: TestDataCase) -> [CellStub] {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedMarkLowerVPBoundCells(for testDataCase: TestDataCase) -> [CellStub]  {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedMarkCells(for testDataCase: TestDataCase) -> [CellStub] {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedMarkUpperVPBoundCells(for testDataCase: TestDataCase) -> [CellStub] {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedMarkAllCells(for testDataCase: TestDataCase) -> [CellStub] {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedUnMarkOneBeforeVPCells(for testDataCase: TestDataCase) -> [CellStub]  {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedUnMarkOneCells(for testDataCase: TestDataCase) -> [CellStub] {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedUnMarkOneAfterCells(for testDataCase: TestDataCase) -> [CellStub] {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedUnMarkLowerVPBoundCells(for testDataCase: TestDataCase) -> [CellStub]  {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedUnMarkCells(for testDataCase: TestDataCase) -> [CellStub] {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: true),
                CellStub()
            ]
        }
    }
    
    func expectedUnMarkUpperVPBoundCells(for testDataCase: TestDataCase) -> [CellStub] {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: true),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        }
    }
    
    func expectedUnMarkAllCells(for testDataCase: TestDataCase) -> [CellStub] {
        switch testDataCase {
        case .active:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        case .deactive:
            return [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
        case .activeMarked:
            return [
                CellStub(),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub(marking: true, marked: false),
                CellStub()
            ]
        }
    }
}
