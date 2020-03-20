import XCTest
@testable import SSSugar

class SSCollectionViewMarkableControllerUnmarkTC: XCTestCase {
    typealias TestDataContainer = (sut: SSCollectionViewMarkableControllerTestsSUT, expected: SSCollectionViewMarkableControllerUnmarkExpectedResult)
    
    let testHelper = SSCollectionViewMarkableControllerTestHelper()
    var testDataContainers = [TestDataContainer]()
    
    override func setUp() {
        testDataContainers = [
            makeDeactiveDataContainer(),
            makeActiveDataContainer(),
            makeActiveMarkedDataContainer(),
        ]
    }

    func testUnmarkOneBeforeVP() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellMarked(false, at: IndexPath(row: 0, section: 0))
            testHelper.checkSUT(sut, active: expected.active, cells: expected.oneBeforeVPCells)
        }
    }

    func testUnmarkOne() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellMarked(false, at: IndexPath(row: 2, section: 0))
            testHelper.checkSUT(sut, active: expected.active, cells: expected.oneCells)
        }
    }

    func testUnmarkOneAfterVP() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellMarked(false, at: IndexPath(row: 4, section: 0))
            testHelper.checkSUT(sut, active: expected.active, cells: expected.oneAfterVPCells)
        }
    }

    func testUnmarkLowerVPBound() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellsMarked(false, at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
            testHelper.checkSUT(sut, active: expected.active, cells: expected.lowerVPBoundCells)
        }
    }

    func testUnmark() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellsMarked(false, at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)])
            testHelper.checkSUT(sut, active: expected.active, cells: expected.cells)
        }
    }

    func testUnmarkUpperVPBound() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setCellsMarked(false, at: [IndexPath(row: 3, section: 0), IndexPath(row: 4, section: 0)])
            testHelper.checkSUT(sut, active: expected.active, cells: expected.upperVPBoundCells)
        }
    }

    func testUnmarkAll() {
        testDataContainers.forEach { container in
            let sut = container.sut
            let expected = container.expected
            
            sut.controller.setAllCellsMarked(false)
            testHelper.checkSUT(sut, active: expected.active, cells: expected.allCells)
        }
    }
    
    // MARK: Data Containers
    
    func makeDeactiveDataContainer() -> TestDataContainer {
        let sut = testHelper.makeSUT {
            $0.collection.viewPortOffset = 1
        }
        return (sut, SSCollectionViewMarkableControllerUnmarkDeactiveExpectedResult())
    }
    
    func makeActiveDataContainer() -> TestDataContainer {
        let sut = testHelper.makeSUT {
            $0.collection.viewPortOffset = 1
            $0.controller.active = true
        }
        return (sut, SSCollectionViewMarkableControllerUnmarkActiveExpectedResult())
    }
    
    func makeActiveMarkedDataContainer() -> TestDataContainer {
        let sut = testHelper.makeSUT {
            $0.collection.viewPortOffset = 1
            $0.controller.active = true
            $0.controller.setAllCellsMarked(true)
        }
        return (sut, SSCollectionViewMarkableControllerUnmarkActiveMarkedExpectedResult())
    }
}


// MARK: - Expected Result

typealias SSCollectionViewMarkableControllerUnmarkExpectedResult = SSCollectionViewMarkableControllerMarkExpectedResult

// MARK: Deactive

struct SSCollectionViewMarkableControllerUnmarkDeactiveExpectedResult: SSCollectionViewMarkableControllerUnmarkExpectedResult {
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

struct SSCollectionViewMarkableControllerUnmarkActiveExpectedResult: SSCollectionViewMarkableControllerUnmarkExpectedResult {
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
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let oneAfterVPCells: [Self.CellStub] = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let lowerVPBoundCells = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let cells = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let upperVPBoundCells = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let allCells = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
}

// MARK: Active Marked

struct SSCollectionViewMarkableControllerUnmarkActiveMarkedExpectedResult: SSCollectionViewMarkableControllerUnmarkExpectedResult {
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
        CellStub(marking: true, marked: false),
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
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
    let cells = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: true),
        CellStub()
    ]
    let upperVPBoundCells = [
        CellStub(),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: true),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
    let allCells = [
        CellStub(),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub(marking: true, marked: false),
        CellStub()
    ]
}

