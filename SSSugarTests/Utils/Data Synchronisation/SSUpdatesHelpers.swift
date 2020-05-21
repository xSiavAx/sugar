import Foundation
@testable import SSSugar


class TestEntity {}

protocol TestEntitySource: SSUpdaterEntitySource where Entity == TestEntity {}

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
}
