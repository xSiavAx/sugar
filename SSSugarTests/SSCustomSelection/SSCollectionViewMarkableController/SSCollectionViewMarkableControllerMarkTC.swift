import XCTest
@testable import SSSugar

class SSCollectionViewMarkableControllerMarkTC: XCTestCase {
    typealias TestDataContainer = (sut: SSCollectionViewMarkableControllerTestsSUT, expected: SSCollectionViewMarkableControllerMarkExpectedResult)
    
    let testHelper = SSCollectionViewMarkableControllerTestHelper()
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
            let expected = container.expected
            
            sut.controller.setCellMarked(true, at: IndexPath(row: 0, section: 0))
            testHelper.checkSUT(sut, active: expected.active, cells: expected.oneBeforeVPCells)
        }
    }

    func testMarkOne() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellMarked(true, at: IndexPath(row: 2, section: 0))
            testHelper.checkSUT(sut, active: expected.active, cells: expected.oneCells)
        }
    }

    func testMarkOneAfterVP() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellMarked(true, at: IndexPath(row: 4, section: 0))
            testHelper.checkSUT(sut, active: expected.active, cells: expected.oneAfterVPCells)
        }
    }

    func testMarkLowerVPBound() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellsMarked(true, at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
            testHelper.checkSUT(sut, active: expected.active, cells: expected.lowerVPBoundCells)
        }
    }

    func testMark() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellsMarked(true, at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)])
            testHelper.checkSUT(sut, active: expected.active, cells: expected.cells)
        }
    }

    func testMarkUpperVPBound() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellsMarked(true, at: [IndexPath(row: 3, section: 0), IndexPath(row: 4, section: 0)])
            testHelper.checkSUT(sut, active: expected.active, cells: expected.upperVPBoundCells)
        }
    }

    func testMarkAll() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setAllCellsMarked(true)
            testHelper.checkSUT(sut, active: expected.active, cells: expected.allCells)
        }
    }
    
    // MARK: Data Containers
    
    func makeDeactiveDataContainer() -> TestDataContainer {
        let sut = testHelper.makeSUT {
            $0.collection.viewPortOffset = 1
        }
        return (sut, SSCollectionViewMarkableControllerMarkDeactiveExpectedResult())
    }
    
    func makeActiveDataContainer() -> TestDataContainer {
        let sut = testHelper.makeSUT {
            $0.collection.viewPortOffset = 1
            $0.controller.active = true
        }
        return (sut, SSCollectionViewMarkableControllerMarkActiveExpectedResult())
    }
    
    func makeActiveMarkedDataContainer() -> TestDataContainer {
        let sut = testHelper.makeSUT {
            $0.collection.viewPortOffset = 1
            $0.controller.active = true
            $0.controller.setAllCellsMarked(true)
        }
        return (sut, SSCollectionViewMarkableControllerMarkActiveMarkedExpectedResult())
    }
}


// MARK: - Expected Result

protocol SSCollectionViewMarkableControllerMarkExpectedResult {
    typealias CellStub = SSCollectionViewMarkableCellStub
    
    var active: Bool { get }
    var oneBeforeVPCells: [CellStub] { get }
    var oneCells: [CellStub] { get }
    var oneAfterVPCells: [CellStub] { get }
    var lowerVPBoundCells: [CellStub] { get }
    var cells: [CellStub] { get }
    var upperVPBoundCells: [CellStub] { get }
    var allCells: [CellStub] { get }
}

// MARK: Deactive

struct SSCollectionViewMarkableControllerMarkDeactiveExpectedResult: SSCollectionViewMarkableControllerMarkExpectedResult {
    let active = false
    let oneBeforeVPCells = [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
    let oneCells = [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
    let oneAfterVPCells = [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
    let lowerVPBoundCells = [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
    let cells = [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
    let upperVPBoundCells = [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
    let allCells = [CellStub(), CellStub(), CellStub(), CellStub(), CellStub()]
}

// MARK: Active

struct SSCollectionViewMarkableControllerMarkActiveExpectedResult: SSCollectionViewMarkableControllerMarkExpectedResult {
    let active = true
    let oneBeforeVPCells = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let oneCells = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let oneAfterVPCells = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let lowerVPBoundCells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let cells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let upperVPBoundCells = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
    let allCells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
}

// MARK: Active Marked

struct SSCollectionViewMarkableControllerMarkActiveMarkedExpectedResult: SSCollectionViewMarkableControllerMarkExpectedResult {
    let active = true
    let oneBeforeVPCells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
    let oneCells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
    let oneAfterVPCells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
    let lowerVPBoundCells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
    let cells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
    let upperVPBoundCells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
    let allCells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
}

