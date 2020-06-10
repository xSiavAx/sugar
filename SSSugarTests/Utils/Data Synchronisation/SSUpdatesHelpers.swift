import Foundation
@testable import SSSugar

class TestEntity {}

class TestDataModifyCore: SSDataModifyCore, TestUpdateProducer, SSMarkerGenerating, SSCopying {
    init() {}
    
    required init(copy other: TestDataModifyCore) {}
    
    func toUpdate() -> SSUpdate {
        return produceUpdate(marker: Self.newMarker())
    }
}

class TestRequest: SSCoredModify<TestDataModifyCore>, SSDmRequest {
    static var title: String = "test_request"
    override var title: String { Self.title }
    var adaptResult = SSDmToChangeAdaptResult.passed
    var identifier: Int?
    var adapted = false
    
    init() {
        super.init(core: TestDataModifyCore())
    }
    
    required init(copy other: SSModify) {
        super.init(copy: other)
        identifier = (other as! Self).identifier
    }
}

extension TestRequest: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(adaptResult)
        hasher.combine(title)
    }
}

extension TestRequest: Equatable {
    static func == (lhs: TestRequest, rhs: TestRequest) -> Bool {
        return lhs.hashValue == rhs.hashValue &&
            lhs.identifier == rhs.identifier &&
            lhs.adaptResult == rhs.adaptResult &&
            lhs.title == rhs.title
    }
}

class TestChange: SSCoredModify<TestDataModifyCore>, SSDmChange {
    static var title: String = "test_change"
    override var title: String { Self.title }
    var affectsAdaptation = true
    
    init() {
        super.init(core: TestDataModifyCore())
    }
    
    required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

class TestAnotherChange: SSCoredModify<TestDataModifyCore>, SSDmChange {
    static var title: String = "test_another_change"
    override var title: String { Self.title }
    
    init() {
        super.init(core: TestDataModifyCore())
    }
    
    required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

protocol ToTestChangeAdapating {
    func adaptToTestChange(_ change: TestChange) -> SSDmToChangeAdaptResult
}

extension TestRequest: ToTestChangeAdapating {
    func adaptToTestChange(_ change: TestChange) -> SSDmToChangeAdaptResult {
        if (change.affectsAdaptation) {
            if (adaptResult == .adapted) {
                adapted = true
            }
            return adaptResult
        }
        return .passed
    }
}

protocol TestUpdateProducer {
    func produceUpdate(marker: String) -> SSUpdate
}

extension TestUpdateProducer {
    static var updateTitle: String {"test_update"}
    
    func produceUpdate(marker: String) -> SSUpdate {
        return SSUpdate(name: Self.updateTitle, marker: marker)
    }
}

protocol TestEntitySource: SSUpdaterEntitySource, SSMutatingEntitySource where Entity == TestEntity {}

protocol TestUpdateReceiver: SSUpdateReceiver, TestUpdateProducer {
    func onUpdate(marker: String)
}

extension TestUpdateReceiver {
    private func onReceive(_ update: SSUpdate) {
        onUpdate(marker: update.marker)
    }
    
    func reactions() -> SSUpdate.ReactionMap {
        return testReactions()
    }
    
    func testReactions() -> SSUpdate.ReactionMap {
        return [Self.updateTitle : onReceive]
    }
}

protocol TPUpdaterDelegate: SSEntityUpdaterDelegate {}

class TestEnityObtainer: SSEntityObtainer {
    var entity: TestEntity?
    var onObtain: (()->Void)?
    
    init(entity mEntity: TestEntity? = TestEntity()) {
        entity = mEntity
    }
    
    func obtain() -> TestEntity? {
        onObtain?()
        return entity
    }
}

class TestSomeEntitySource: TestEntitySource {
    var entity: TestEntity? = TestEntity()
    
    func entity<Updater : SSBaseEntityUpdating>(for updater: Updater) -> TestEntity? {
        return entity
    }
    
    func entity<Mutating>(for mutator: Mutating) -> TestEntity? where Mutating : SSBaseEntityMutating {
        return entity
    }
}

enum TestMutatorError: Error {
    case mutatorError
}
