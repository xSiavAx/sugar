import Foundation
@testable import SSSugarCore

class TestEntity {}

class TestDataModifyCore: SSDataModifyCore, TestUpdateProducer, SSMarkerGenerating, SSCopying {
    var identifier: Int?
    
    init() {}
    
    required init(copy other: TestDataModifyCore) {
        identifier = (other as! Self).identifier
    }
    
    func toUpdate() -> SSUpdate {
        return produceUpdate(marker: Self.newMarker(), identifier: identifier)
    }
}

extension TestDataModifyCore: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension TestDataModifyCore: Equatable {
    static func == (lhs: TestDataModifyCore, rhs: TestDataModifyCore) -> Bool {
        return lhs.hashValue == rhs.hashValue && lhs.identifier == rhs.identifier
    }
}

class TestRequest: SSCoredModify<TestDataModifyCore>, SSDmRequest {
    static var title: String = "test_request"
    override var title: String { Self.title }
    var adaptResult = SSDmToChangeAdaptResult.passed
    
    var adapted = false
    
    init() {
        super.init(core: TestDataModifyCore())
    }
    
    required init(copy other: SSModify) {
        super.init(copy: other)
    }
}

extension TestRequest: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(iCore)
        hasher.combine(adaptResult)
        hasher.combine(title)
    }
}

extension TestRequest: Equatable {
    static func == (lhs: TestRequest, rhs: TestRequest) -> Bool {
        return lhs.hashValue == rhs.hashValue &&
            lhs.iCore == rhs.iCore &&
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
        return produceUpdate(marker: marker, identifier: nil)
    }
    
    func produceUpdate(marker: String, identifier: Int?) -> SSUpdate {
        var args = [String : Any]()
        
        args["identifier"] = identifier
        return SSUpdate(name: Self.updateTitle, marker: marker, args: args)
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
    
    func updateEntity<Updater>(by updater: Updater, job: (inout TestEntity?) -> (() -> Void)?) where Updater : SSBaseEntityUpdating {
        job(&entity)?()
    }
    
    func entity<Mutating>(for mutator: Mutating) -> TestEntity? where Mutating : SSBaseEntityMutating {
        return entity
    }
}

enum TestMutatorError: Error {
    case mutatorError
}
