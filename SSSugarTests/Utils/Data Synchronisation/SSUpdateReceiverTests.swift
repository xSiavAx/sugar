import Foundation
import XCTest

@testable import SSSugar

/// Extensions of `SSUpdateReceiver`, `SSUpdateApplying` protocols tests.
///
/// * One update
/// * Several updates
/// * Update with single argument
/// * Update with multiple arguments
class SSUpdateReceiverTests: XCTestCase {
}

protocol TestUpdateReceiver: SSUpdateReceiver {
    func firstUpdateDidReceive()
    func secondUpdateDidReceive()
    func updateWithArgDidReceive(arg: Bool)
    func updateWithMultipleArgsDidReceive(first: Bool, second: Int, third: [String])
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
