import Foundation
import XCTest

@testable import SSSugar

/// # Test plan
///
/// # As Notifier
/// * One notification -> got on BG -> Apply on Main
/// * Several notifications -> got on BG -> Apply on Main
///
/// # As Receiver Manager
/// * Notify -> Not Received
/// * Subscrive -> Notify -> Received
/// * Subscrive two listeners -> Notify -> Received both
/// * Subscrive -> Unsubscrive -> Notify -> Not Received
/// * Unsubscrive -> Nothing
class SSUpdateCenterTest: XCTestCase {
    let updater = SSUpdater(withIdentifier: "testing")
    
    func testOneNotification() {
        let receiver = TestUpdatesReceiver()
        
        updater.addReceiver(receiver)
        
        wait {
            $0.fulfill()
        }
    }
    
    func testMultipleNotifications() {
        
    }
}

class TestUpdatesReceiver: SSUpdateReceiver {
    var onCheck: ((Bool)->Void)!
    var ensureIsBGQueue: ((OperationQueue?)->Void)!
    var collectedUpdates = [String]()
    var expectedUpdates = [String]()
    var updated = false
    
    func process1st(_ update: SSUpdate) {
        ensureIsBGQueue(OperationQueue.current)
        collectedUpdates.append(update.name)
    }
    
    func process2nd(_ update: SSUpdate) {
        ensureIsBGQueue(OperationQueue.current)
        collectedUpdates.append(update.name)
    }
    
    func reactions() -> SSUpdate.ReactionMap {
        return ["test_notification_1" : process1st(_:),
                "test_notification_2" : process2nd(_:)]
    }
    
    func apply() {
        updated = true
        onCheck(OperationQueue.main == OperationQueue.main)
        onCheck(expectedUpdates == collectedUpdates)
    }
}

extension SSUpdate {
    #warning("Move me to Updater tests")
    func hasSameArgs(as other: SSUpdate) -> Bool {
        if name != other.name || args.count != other.args.count {
            return false
        }
        return NSDictionary(dictionary: self.args).isEqual(to: other.args)
    }
}
