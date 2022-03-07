import Foundation
import XCTest

@testable import SSSugarCore

/// Extensions of `SSUpdateReceiver`, `SSUpdateApplying` protocols tests.
///
/// * One update
/// * Several updates
/// * Update with single argument
/// * Update with multiple arguments
class SSUpdateReceiverTests: XCTestCase, TestUpdate {
    var receiver: SomeTestUpdateReceiver!
    var center = SSUpdater()
    
    override func setUp() {
        receiver = SomeTestUpdateReceiver()
        
        center.addReceiver(receiver)
    }
    
    override func tearDown() {
        center.removeReceiver(receiver)
        receiver.applies.removeAll()
        receiver.recives.removeAll()
        receiver = nil
    }
    
    func testUpdate() {
        let receives: [SomeTestUpdateReceiver.Received] = [.first]
        let notifications = [firstUpdate()]
        
        checkNotify(notifications, receives: receives)
    }
    
    func testTwoUpdates() {
        let receives: [SomeTestUpdateReceiver.Received] = [.first, .second]
        let notifications = [firstUpdate(), secondUpdate()]
        
        checkNotify(notifications, receives: receives)
    }
    
    func testSingleArgUpdate() {
        let receives: [SomeTestUpdateReceiver.Received] = [.withArg(arg: true)]
        let notifications = [oneArgUpdate(arg: true)]
        
        checkNotify(notifications, receives: receives)
    }
    
    func testMultipleArgsUpdate() {
        let receives: [SomeTestUpdateReceiver.Received] = [.withMultipleArg(first: false, second: 5, third: ["lol"])]
        let notifications = [multipleArgsUpdate(first: false, second: 5, third: ["lol"])]
        
        checkNotify(notifications, receives: receives)
    }
    
    func checkNotify(_ updates: [SSUpdate], receives: [SomeTestUpdateReceiver.Received]) {
        wait() { exp in
            DispatchQueue.bg.async {
                self.center.notify(updates: updates) {
                    exp.fulfill()
                    XCTAssert(self.receiver.applies == receives)
                }
                XCTAssert(self.receiver.recives == receives)
            }
        }
    }
}

protocol URTUpdateReceiver: SSUpdateReceiver {
    func firstUpdateDidReceive()
    func secondUpdateDidReceive()
    func updateWithArgDidReceive(arg: Bool)
    func updateWithMultipleArgsDidReceive(first: Bool, second: Int, third: [String])
}

class SomeTestUpdateReceiver: URTUpdateReceiver, SSUpdateApplying {
    enum Received: Equatable {
        case first
        case second
        case withArg(arg: Bool)
        case withMultipleArg(first: Bool, second: Int, third: [String])
    }
    
    var recives = [Received]()
    var applies = [Received]()
    var collectedUpdates = [CollectableUpdate]()
    
    func firstUpdateDidReceive() {
        func onApply() {
            applies.append(.first)
        }
        recives.append(.first)
        collect(update: onApply)
    }
    
    func secondUpdateDidReceive() {
        func onApply() {
            applies.append(.second)
        }
        recives.append(.second)
        collect(update: onApply)
    }
    
    func updateWithArgDidReceive(arg: Bool) {
        func onApply() {
            applies.append(.withArg(arg: arg))
        }
        recives.append(.withArg(arg: arg))
        collect(update: onApply)
    }
    
    func updateWithMultipleArgsDidReceive(first: Bool, second: Int, third: [String]) {
        func onApply() {
            applies.append(.withMultipleArg(first: first, second: second, third: third))
        }
        recives.append(.withMultipleArg(first: first, second: second, third: third))
        collect(update: onApply)
    }
    
    func reset() {
        recives.removeAll()
    }
}

protocol TestUpdate: SSMarkerGenerating {
    func firstUpdate() -> SSUpdate
    func secondUpdate() -> SSUpdate
    func oneArgUpdate(arg: Bool) -> SSUpdate
    func multipleArgsUpdate(first: Bool, second: Int, third: [String]) -> SSUpdate
}

struct TestUpdateKeys {
    internal static var fisrt = "test_first_notification"
    internal static var second = "test_second_notification"
    internal static var oneArg = (name: "test_one_arg_notification", arg: "arg")
    internal static var multipleArgs = (name: "test_multiple_args_notification", keys: (first: "first", second: "second", third: "third"))
}

extension TestUpdate {
    func firstUpdate() -> SSUpdate {
        return SSUpdate(name: TestUpdateKeys.fisrt, marker: Self.newMarker())
    }
    
    func secondUpdate() -> SSUpdate {
        return SSUpdate(name: TestUpdateKeys.second, marker: Self.newMarker())
    }
    
    func oneArgUpdate(arg: Bool) -> SSUpdate {
        let keys = TestUpdateKeys.oneArg
        let args = [keys.arg : arg]
        
        return SSUpdate(name: keys.name, marker: Self.newMarker(), args: args)
    }
    
    func multipleArgsUpdate(first: Bool, second: Int, third: [String]) -> SSUpdate {
        let updKeys = TestUpdateKeys.multipleArgs
        let name = updKeys.name
        let keys = updKeys.keys
        
        return SSUpdate(name: name, marker: Self.newMarker(), args: [keys.first : first,
                                                                     keys.second : second,
                                                                     keys.third : third])
    }
}

extension URTUpdateReceiver {
    func reactions() -> SSUpdate.ReactionMap {
        return testReactions()
    }
    
    func testReactions() -> SSUpdate.ReactionMap {
        return [TestUpdateKeys.fisrt : firstReceived,
                TestUpdateKeys.second : secondReceived,
                TestUpdateKeys.oneArg.name : oneArgReceived,
                TestUpdateKeys.multipleArgs.name : multipleArgsReceived]
    }
    
    private func firstReceived(_ update: SSUpdate) {
        firstUpdateDidReceive()
    }
    
    private func secondReceived(_ update: SSUpdate) {
        secondUpdateDidReceive()
    }
    
    private func oneArgReceived(_ update: SSUpdate) {
        let argKey = TestUpdateKeys.oneArg.arg
        
        updateWithArgDidReceive(arg: update.args[argKey] as! Bool)
    }
    
    private func multipleArgsReceived(_ update: SSUpdate) {
        let keys = TestUpdateKeys.multipleArgs.keys
        let args = update.args
        let first = args[keys.first] as! Bool
        let second = args[keys.second] as! Int
        let third = args[keys.third] as! [String]
        
        updateWithMultipleArgsDidReceive(first: first, second: second, third: third)
    }
}

//extension SSUpdate {
//    #warning("Move me to Updater tests")
//    func hasSameArgs(as other: SSUpdate) -> Bool {
//        if name != other.name || args.count != other.args.count {
//            return false
//        }
//        return NSDictionary(dictionary: self.args).isEqual(to: other.args)
//    }
//}
