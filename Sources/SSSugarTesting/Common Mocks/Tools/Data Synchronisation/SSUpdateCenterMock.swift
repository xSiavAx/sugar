import Foundation
import SSSugarCore

open class SSUpdateCenterMock: SSMock, SSUpdateCenter {
    public typealias OnApplyCaptor = SSValueShortCaptor<(() -> Void)?>
    
    open func addReceiver(_ receiver: SSUpdateReceiver) {
        try! super.call(receiver)
    }
    
    open func removeReceiver(_ receiver: SSUpdateReceiver) {
        try! super.call(receiver)
    }
    
    open func notify(updates: [SSUpdate], onApply: (() -> Void)?) {
        try! super.call(updates, onApply)
    }
    
    @discardableResult
    open func expectAdd(receiver: SSUpdateReceiver & AnyObject) -> SSMockCallExpectation {
        return expect() {
            let _ = $1.same(receiver as AnyObject)
            $0.addReceiver(receiver)
        }
    }
    
    @discardableResult
    open func expectRemove(receiver: SSUpdateReceiver & AnyObject) -> SSMockCallExpectation {
        return expect() {
            let _ = $1.same(receiver as AnyObject)
            $0.removeReceiver(receiver)
        }
    }
    
    @discardableResult
    open func expectNotify(updates: [SSUpdateCompare], onApply: OnApplyCaptor) -> SSMockCallExpectation {
        return expect() {
            let _ = $1.match(updates) { compares, updates in
                guard let updates = updates as? [SSUpdate] else { return false }
                return compares.elementsEqual(updates) { $0.isMatch($1) }
            }
            return $0.notify(updates: updates.map { $0.update }, onApply: $1.capture(onApply))
        }
    }
    
    @discardableResult
    open func expectNotifyAndAsync(updates: [SSUpdateCompare]) -> SSMockCallExpectation {
        let captor = applyCaptor()
        
        return expectNotify(updates: updates, onApply: captor)
            .andAsync() { captor.released?() }
    }
    
    open func applyCaptor() -> OnApplyCaptor {
        return .forClosure()
    }
}

open class SSUpdateCompare {
    let update: SSUpdate
    let checkArgs: ([AnyHashable : Any]) -> Bool
    
    public init(update: SSUpdate, checkArgs: @escaping ([AnyHashable : Any]) -> Bool) {
        self.update = update
        self.checkArgs = checkArgs
    }
    
    open func isMatch(_ update: SSUpdate) -> Bool {
        return update.name == update.name &&
        update.marker == update.marker &&
        update.args.count == update.args.count &&
        checkArgs(update.args)
    }
}
