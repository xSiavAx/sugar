import Foundation
import XCTest

@testable import SSSugarCore

/// `SSUpdater` tests.
///
/// # Test plan
///
/// # As Notifier
/// * One notification -> got on BG -> Apply on Main
/// * Several notifications -> got on BG -> Apply on Main
/// * Two updaters with different identifiers
///
/// # As Receiver Manager
/// * Notify -> Not Received
/// * Subscribe two listeners -> Notify -> Received both
/// * Subscribe -> Unsubscrive -> Notify -> Not Received
/// * Unsubscribe -> Nothing
class SSUpdateCenterTest: XCTestCase {
    let updater = SSUpdater(withIdentifier: "testing")
    var bgQueue: TestQueue!
    var queueKey: DispatchSpecificKey<String>!
    
    override func setUp() {
        bgQueue = TestQueue()
    }
    
    override func tearDown() {
        bgQueue.finilize()
        bgQueue = nil
    }
    
    func testOneNotification() {
        let receiver = createReceiver()
        let update = TestUpdatesReceiver.firstUpdate()
        let expectedUpdates = [update.name]
        
        updater.addReceiver(receiver)
        
        wait { (exp) in
            notify([update]) {
                exp.fulfill()
            }
        }
        XCTAssert(expectedUpdates == receiver.collectedUpdates)
        updater.removeReceiver(receiver)
    }
    
    func testMultipleNotifications() {
        let receiver = createReceiver()
        let updates = [TestUpdatesReceiver.firstUpdate(),
                       TestUpdatesReceiver.secondUpdate(),
                       TestUpdatesReceiver.firstUpdate()]
        let expectedUpdates = updates.map { $0.name }
        
        updater.addReceiver(receiver)
        
        wait { (exp) in
            notify(updates) {
                exp.fulfill()
            }
        }
        XCTAssert(expectedUpdates == receiver.collectedUpdates)
        updater.removeReceiver(receiver)
    }
    
    func testMultipleUpdaters() {
        let otherUpdater = SSUpdater(withIdentifier: "testing_other")
        
        let receiver = createReceiver()
        let otherReceiver = createReceiver()
        let update = TestUpdatesReceiver.firstUpdate()
        let expectedUpdates = [update.name]
        
        updater.addReceiver(receiver)
        otherUpdater.addReceiver(otherReceiver)
        
        wait { (exp) in
            notify([update]) {
                exp.fulfill()
            }
        }
        XCTAssert(expectedUpdates == receiver.collectedUpdates)
        XCTAssert(!otherReceiver.updated)
        receiver.updated = false
        
        wait { (exp) in
            notify(via: otherUpdater, updates: [update]) {
                exp.fulfill()
            }
        }
        
        XCTAssert(expectedUpdates == otherReceiver.collectedUpdates)
        XCTAssert(!receiver.updated)
        
        updater.removeReceiver(receiver)
        otherUpdater.removeReceiver(otherReceiver)
    }
    
    func testNotNotified() {
        let receiver = createReceiver()
        let updates = [TestUpdatesReceiver.firstUpdate(),
                       TestUpdatesReceiver.secondUpdate(),
                       TestUpdatesReceiver.firstUpdate()]
        
        wait { (exp) in
            notify(updates) {
                exp.fulfill()
            }
        }
        XCTAssert(receiver.updated == false)
    }
    
    func testMultipleReceivers() {
        let receiver1 = createReceiver()
        let receiver2 = createReceiver()
        let update = TestUpdatesReceiver.firstUpdate()
        let expectedUpdates = [update.name]
        
        updater.addReceiver(receiver1)
        updater.addReceiver(receiver2)
        
        wait { (exp) in
            notify([update]) {
                exp.fulfill()
            }
        }
        XCTAssert(expectedUpdates == receiver1.collectedUpdates)
        XCTAssert(expectedUpdates == receiver2.collectedUpdates)
        updater.removeReceiver(receiver1)
        updater.removeReceiver(receiver2)
    }
    
    func testUnsubscribe() {
        let receiver = createReceiver()
        let update = TestUpdatesReceiver.firstUpdate()
        
        updater.addReceiver(receiver)
        
        updater.removeReceiver(receiver)
        wait { (exp) in
            notify([update]) {
                exp.fulfill()
            }
        }
        XCTAssert(receiver.updated == false)
    }
    
    func testUnsubscribeUnsubscribed() {
        let receiver = createReceiver()
        let update = TestUpdatesReceiver.firstUpdate()
        
        updater.removeReceiver(receiver)
        wait { (exp) in
            notify([update]) {
                exp.fulfill()
            }
        }
        XCTAssert(receiver.updated == false)
    }
    
    func notify(_ updates: [SSUpdate], onApply: @escaping ()->Void) {
        notify(via: updater, updates: updates, onApply: onApply)
    }
    
    func notify(via updater: SSUpdater, updates: [SSUpdate], onApply: @escaping ()->Void) {
        func notify() {
            if (updates.count == 1) {
                updater.notify(update: updates.first!, onApply: onApply)
            } else {
                updater.notify(updates: updates, onApply: onApply)
            }
        }
        bgQueue.queue.async(execute: notify)
    }
    
    func createReceiver() -> TestUpdatesReceiver {
        let receiver = TestUpdatesReceiver()
        
        func onCheck(condition: Bool) { XCTAssert(condition) }
        func isBG() {
            XCTAssert(bgQueue.isCurrent())
        }
        
        receiver.onCheck = onCheck(condition:)
        receiver.ensureIsBGQueue = isBG
        
        return receiver
    }
}

class TestUpdatesReceiver: SSUpdateReceiver {
    var onCheck: ((Bool)->Void)!
    var ensureIsBGQueue: (()->Void)!
    var collectedUpdates = [String]()
    var updated = false
    
    func process1st(_ update: SSUpdate) {
        ensureIsBGQueue()
        collectedUpdates.append(update.name)
    }
    
    func process2nd(_ update: SSUpdate) {
        ensureIsBGQueue()
        collectedUpdates.append(update.name)
    }
    
    func reactions() -> SSUpdate.ReactionMap {
        return ["test_notification_1" : process1st(_:),
                "test_notification_2" : process2nd(_:)]
    }
    
    func apply() {
        updated = true
        onCheck(OperationQueue.main == OperationQueue.main)
    }
}

extension TestUpdatesReceiver: SSMarkerGenerating {
    static func firstUpdate() -> SSUpdate {
        return SSUpdate(name: "test_notification_1", marker: Self.newMarker())
    }
    
    static func secondUpdate() -> SSUpdate {
        return SSUpdate(name: "test_notification_2", marker: Self.newMarker())
    }
}
