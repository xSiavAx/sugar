import Foundation
import XCTest

@testable import SSSugar

/// Extensions of `SSBaseEntityUpdating` protocols tests.
///
/// # Tests plan
///
/// * Not started, not received
/// * Started received
/// * Stoped, not received
class SSEntityUpdaterTests: XCTestCase, SSMarkerGenerating {
    var updateCenter: SSUpdater!
    var source: TestSomeEntitySource!
    var delegate: TestSomeUpdaterDelegate!
    var updater: TestUpdater<TestSomeEntitySource, TestSomeUpdaterDelegate>!
    
    override func setUp() {
        updateCenter = SSUpdater(withIdentifier: "updater_tests")
        source = TestSomeEntitySource()
        delegate = TestSomeUpdaterDelegate()
        updater = TestUpdater(receiversManager: updateCenter, source: source, delegate: delegate)
    }
    
    func testNotStartedNotReceived() {
        notify()
        XCTAssert(!updater.received)
        XCTAssert(!updater.applied)
    }
    
    func testStartedReceived() {
        start()
        
        notify()
        XCTAssert(updater.received)
        XCTAssert(updater.applied)
        
        stop()
    }
    
    func testStopedNotReceived() {
        start()
        stop()
        notify()
        XCTAssert(!updater.received)
        XCTAssert(!updater.applied)
    }
    
    private func notify() {
        func onBG(exp: XCTestExpectation) {
            updateCenter.notify(update: newUpdate()) {
                exp.fulfill()
            }
        }
        wait {(exp) in
            DispatchQueue.bg.async {
                onBG(exp: exp)
            }
        }
    }

    private func start() {
        func onBG() {
            updater.start()
        }
        wait {(exp) in
            DispatchQueue.bg.async {
                onBG()
                exp.fulfill()
            }
        }
    }
    
    private func stop() {
        func onBG() {
            updater.stop()
        }
        wait {(exp) in
            DispatchQueue.bg.async {
                onBG()
                exp.fulfill()
            }
        }
    }
    
    private func newUpdate() -> SSUpdate {
        return SSUpdate(name: "test_notification", marker: Self.newMarker())
    }
}

class TestUpdater<TestSource: TestEntitySource, TestDelegate: TestUpdaterDelegate>: SSBaseEntityUpdating {
    typealias Source = TestSource
    typealias Delegate = TestDelegate
    
    var source: TestSource?
    var delegate: TestDelegate?
    var receiversManager: SSUpdateReceiversManaging
    
    var received = false
    var applied = false
    
    init(receiversManager mReceiversManager: SSUpdateReceiversManaging, source mSource: TestSource, delegate mDelegate: TestDelegate) {
        receiversManager = mReceiversManager
        source = mSource
        delegate = mDelegate
    }
}

class TestSomeUpdaterDelegate: TestUpdaterDelegate {
    
}

extension TestUpdater: TestUpdateReceiver {
    func updateDidReceive() {
        received = true
    }
    
    func apply() {
        applied = received
    }
}

protocol TestUpdaterDelegate: SSEntityUpdaterDelegate {}

protocol TestUpdateReceiver: SSUpdateReceiver {
    func updateDidReceive()
}

extension TestUpdateReceiver {
    func reactions() -> SSUpdate.ReactionMap {
        return ["test_notification" : updateReceived(_:)]
    }
    
    private func updateReceived(_ update:SSUpdate) {
        updateDidReceive()
    }
}
