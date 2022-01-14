import Foundation
import XCTest

@testable import SSSugarCore

/// `SSDmBatchAdapting` protocol extension tests.
///
/// All cases should contains chnage seria to avoid cases producing (for single and seria).
///
/// # Test plan
///
/// * Passed
/// * Adapt
/// * Canceled one
/// * Canceled all
/// * Invalid
/// * No strategy for change
class SSDmBatchAdapterTests: XCTestCase {
    typealias Change = SSModify
    typealias Request = SSModify
    typealias Revision = SSDmRevision<Change>
    typealias Batch = SSDmBatch<Request>
    
    var adapter: TestBatchAdapter!
    
    var revisions: [Revision]!
    var batch: Batch!
    var firstRevisionChanges: [TestChange]!
    var secondRevisionChanges: [TestChange]!
    var batchRequests: [TestRequest]!
    
    var expectedRequests: [TestRequest]!
    var expectedError: SSDmBatchAdaptError?
    
    override func setUp() {
        adapter = TestBatchAdapter()
        
        createModyfies()
        
        revisions = [Revision(number: 0, changes: firstRevisionChanges),
                     Revision(number: 1, changes: secondRevisionChanges)]
        batch = Batch(requests: batchRequests)
    }
    
    override func tearDown() {
        revisions = nil
        batch = nil
    }
    
    func testPassed() {
        check()
    }
    
    func testAdapted() {
        batchRequests.first?.adaptResult = .adapted
        batchRequests.last?.adaptResult = .adapted
        expectedRequests.first?.adaptResult = .adapted
        expectedRequests.last?.adaptResult = .adapted
        expectedRequests.first?.adapted = true
        expectedRequests.last?.adapted = true
        
        check()
    }
    
    func testSingleCancel() {
        batchRequests[1].adaptResult = .canceled
        expectedRequests.remove(at: 1)
        
        check()
    }
    
    func testAllCancel() {
        batchRequests.forEach { $0.adaptResult = .canceled }
        expectedRequests.removeAll()
        
        check()
    }
    
    func testInvalid() {
        batchRequests.last?.adaptResult = .invalid
        expectedRequests.last?.adaptResult = .invalid
        
        expectedError = .cantAdapt
        
        check()
    }
    
    func testNoStrategy() {
        let number = revisions.last!.number + 1
        revisions.append(Revision(number: number, changes: [TestAnotherChange()]))
        
        check()
    }
    
    //MARK: private
    
    func check() {
        let error = adapter.adaptBatch(batch, by: revisions)
        let requests = batch.requests as! [TestRequest]
        
        XCTAssert(expectedRequests == requests)
        XCTAssert(expectedError == error)
    }
    
    func createModyfies() {
        batchRequests = [TestRequest(), TestRequest(), TestRequest()]
        firstRevisionChanges = [TestChange(), TestChange()]
        secondRevisionChanges = [TestChange()]
        
        batchRequests.forEach { idx, req in req.iCore.identifier = idx }
        firstRevisionChanges.forEach { $0.affectsAdaptation = true }
        secondRevisionChanges.forEach { $0.affectsAdaptation = true }
        
        expectedRequests = batchRequests.deepCopy()
    }
}

class TestBatchAdapter: SSDmBatchAdapting {
    typealias Change = SSModify
    typealias Request = SSModify
    
    typealias Builder = SSDMAdaptStrategyBuilder<Change, Request>
    
    var strategies = Strategies()
    
    init() {
        typealias Creator = Builder.Adapting<ToTestChangeAdapating>
        
        let strategy = Creator.To<TestChange>.strategy { (adapting, change) -> SSDmToChangeAdaptResult in
            return adapting.adaptToTestChange(change)
        }
        
        strategies[strategy.title] = strategy.adapt
    }
}
