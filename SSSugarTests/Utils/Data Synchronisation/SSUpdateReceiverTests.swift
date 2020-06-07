import Foundation
import XCTest

@testable import SSSugar

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
    }
    
    func testUpdate() {
        wait { (exp) in
            notify([firstUpdate()], exp: exp)
        }
        check([.first])
    }
    
    func testTwoUpdates() {
        wait { (exp) in
            notify([firstUpdate(), secondUpdate()], exp: exp)
        }
        check([.first, .second])
    }
    
    func testSingleArgUpdate() {
        wait { (exp) in
            notify([oneArgUpdate(arg: true)], exp: exp)
        }
        check([.withArg(arg: true)])
    }
    
    func testMultipleArgsUpdate() {
        wait { (exp) in
            notify([multipleArgsUpdate(first: false, second: 5, third: ["lol"])], exp: exp)
        }
        check([.withMultipleArg(first: false, second: 5, third: ["lol"])])
    }
    
    func notify(_ updates: [SSUpdate], exp: XCTestExpectation) {
        func onBG() {
            center.notify(updates: updates) {
                exp.fulfill()
            }
        }
        DispatchQueue.bg.async(execute: onBG)
    }
    
    func check(_ receives: [SomeTestUpdateReceiver.Received]) {
        XCTAssert(receiver.recives == receives)
        XCTAssert(receiver.applied)
        receiver.reset()
    }
}

protocol TestUpdateReceiver: SSUpdateReceiver {
    func firstUpdateDidReceive()
    func secondUpdateDidReceive()
    func updateWithArgDidReceive(arg: Bool)
    func updateWithMultipleArgsDidReceive(first: Bool, second: Int, third: [String])
}

class SomeTestUpdateReceiver: TestUpdateReceiver {
    enum Received: Equatable {
        case first
        case second
        case withArg(arg: Bool)
        case withMultipleArg(first: Bool, second: Int, third: [String])
    }
    
    var recives = [Received]()
    var applied = false
    
    func firstUpdateDidReceive() {
        recives.append(.first)
    }
    
    func secondUpdateDidReceive() {
        recives.append(.second)
    }
    
    func updateWithArgDidReceive(arg: Bool) {
        recives.append(.withArg(arg: arg))
    }
    
    func updateWithMultipleArgsDidReceive(first: Bool, second: Int, third: [String]) {
        recives.append(.withMultipleArg(first: first, second: second, third: third))
    }
    
    func apply() {
        applied = true
    }
    
    func reset() {
        recives.removeAll()
        applied = false
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

extension TestUpdateReceiver {
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
