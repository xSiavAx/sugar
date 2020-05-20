import Foundation
@testable import SSSugar


class TestEntity {}

protocol TestEntitySource: SSUpdaterEntitySource where Entity == TestEntity {}

protocol TestUpdaterDelegate: SSEntityUpdaterDelegate {}

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

class TestUpdater<TestSource: TestEntitySource, TestDelegate: TestUpdaterDelegate>: SSBaseEntityUpdating {
    typealias Source = TestSource
    typealias Delegate = TestDelegate
    
    var source: TestSource?
    var delegate: TestDelegate?
    var receiversManager: SSUpdateReceiversManaging
    
    var started = false
    var onStart: (()->Void)?
    var onStop: (()->Void)?
    
    init(receiversManager mReceiversManager: SSUpdateReceiversManaging, source mSource: TestSource, delegate mDelegate: TestDelegate) {
        receiversManager = mReceiversManager
        source = mSource
        delegate = mDelegate
    }
    
    func start() {
        started = true
        onStart?()
    }
    
    func stop() {
        started = false
        onStop?()
    }
}

class TestMutator<TestSource: SSMutatingEntitySource>: SSBaseEntityMutating {
    var source: TestSource?
    
    var started = false
    
    var onStart: (()->Void)?
    var onStop: (()->Void)?
    
    init(source mSource: TestSource) {
        source = mSource
    }
    
    func start() {
        started = true
        onStart?()
    }
    
    func stop() {
        started = false
        onStop?()
    }
}

class TestProcessor<UpdateDelegate: TestUpdaterDelegate> {
    typealias Entity = TestEntity
    
    var entity: TestEntity?
    let executor: SSExecutor
    let obtainer: TestEnityObtainer
    private(set) var updater: TestUpdater<TestProcessor, UpdateDelegate>?
    private(set) var mutator: TestMutator<TestProcessor>?
    let updateCenter: SSUpdateCenter
    weak var updateDelegate: UpdateDelegate?
    
    var startOnEmptyEntity: Bool = true
    
    var onUtilStart: (()->Void)?
    var onUtilStop: (()->Void)?
    
    init(obtainer mObtainer: TestEnityObtainer, executor mExecutor: SSExecutor, updateCenter mUpdateCenter: SSUpdateCenter) {
        obtainer = mObtainer
        executor = mExecutor
        updateCenter = mUpdateCenter
    }
}

extension TestProcessor: TestEntitySource {}

extension TestProcessor: SSSingleEntityProcessing {
    func createUpdaterAndMutator() {
        updater = TestUpdater(receiversManager: updateCenter, source: self, delegate: updateDelegate!)
        mutator = TestMutator(source: self)
        
        updater?.onStart = onUtilStart
        updater?.onStop = onUtilStop
        mutator?.onStart = onUtilStart
        mutator?.onStop = onUtilStop
        
        updater?.delegate = updateDelegate
        updater?.source = self
        mutator?.source = self
    }
}
