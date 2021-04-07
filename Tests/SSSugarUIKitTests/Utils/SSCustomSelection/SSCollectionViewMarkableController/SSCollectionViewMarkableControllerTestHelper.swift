import XCTest
@testable import SSSugarUIKit

struct SSCollectionViewMarkableControllerTestHelper {
    func makeSUT(setupClosure: (inout SSCollectionViewMarkableControllerTestsSUT) -> Void) -> SSCollectionViewMarkableControllerTestsSUT {
        var item = SSCollectionViewMarkableControllerTestsSUT()
        
        setupClosure(&item)
        
        return item
    }
    
    func makeSUT(withActiveController isActive: Bool) -> SSCollectionViewMarkableControllerTestsSUT {
        let sut = SSCollectionViewMarkableControllerTestsSUT()
        
        sut.controller.active = isActive
        
        return sut
    }
    
    func checkSUT(_ sut: SSCollectionViewMarkableControllerTestsSUT, active: Bool, cells: [SSCollectionViewMarkableCellStub]) {
        XCTAssertEqual(sut.controller.active, active)
        XCTAssertEqual(sut.collection.cells, cells)
        XCTAssertEqual(sut.delegate.active, active)
    }
}

class SSCollectionViewMarkableControllerTestsSUT {
    var collection = SSMarkableCollectionViewStub()
    var delegate = SSCollectionViewMarkableControllerDelegateStub()
    var controller: SSCollectionViewMarkableController
    
    init() {
        controller = SSCollectionViewMarkableController(collectionView: collection)
        controller.delegate = delegate
    }
}

class SSMarkableCollectionViewStub: UIView, SSCollectionViewMarkable {
    static let cellsCount = 5
    var cells = [SSCollectionViewMarkableCellStub](size: cellsCount) { _ in SSCollectionViewMarkableCellStub() }
    var viewPortRows = cellsCount - 2
    var viewPortOffset = 0
    var viewPortRange: Range<Int> { get { return viewPortOffset..<viewPortOffset + viewPortRows } }
    
    func cellForRow(at: IndexPath) -> SSCollectionViewCellMarkable? {
        guard viewPortRange.contains(at.row) else { return nil }
        
        return cells[at.row % SSMarkableCollectionViewStub.cellsCount]
    }
    
    func indexPathsForVisibleRows() -> [IndexPath] {
        (viewPortOffset..<viewPortOffset + viewPortRows).map { IndexPath(row: $0, section: 0) }
    }
}

class SSCollectionViewMarkableCellStub: UIView {
    var marking: Bool
    var marked: Bool
    
    override var description: String {
        return "\(super.description) \(marking) \(marked)"
    }
    
    init(marking mMarking: Bool = false, marked mMarked: Bool = false) {
        marking = mMarking
        marked = mMarked
        super.init(frame: .zero)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SSCollectionViewMarkableCellStub else { return false }
        
        return self == other
    }

    static func ==(lhs: SSCollectionViewMarkableCellStub, rhs: SSCollectionViewMarkableCellStub) -> Bool {
        return lhs.marking == rhs.marking && lhs.marked == rhs.marked
    }
    
    static func !=(lhs: SSCollectionViewMarkableCellStub, rhs: SSCollectionViewMarkableCellStub) -> Bool {
        return !(lhs == rhs)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SSCollectionViewMarkableCellStub: SSCollectionViewCellMarkable{
    func setMarking(_ marking: Bool, animated: Bool) {
        self.marking = marking
    }
    
    func setMarked(_ marked: Bool, animated: Bool) {
        self.marked = marked
    }
}

class SSCollectionViewMarkableControllerDelegateStub: SSCollectionViewMarkableControllerDelegate {
    var active : Bool = false
    
    func markControllerDidActivate(_ controller: SSCollectionViewMarkableController) {
        guard !active else { fatalError() }
        
        active = true
    }
    
    func markControllerDidDeactivate(_ controller: SSCollectionViewMarkableController) {
        guard active else { fatalError() }
        
        active = false
    }
}
