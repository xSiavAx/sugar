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

class TestRequest: SSCoredModify<TestDataModifyCore> {
    override var title: String { "test_request" }
    
    init() {
        super.init(core: TestDataModifyCore())
    }
    
    required init(copy other: SSModify) {
        super.init(copy: other)
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
