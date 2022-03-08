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
    open func expectNotify(updates: SSValueCaptor<[SSUpdate]>, onApply: OnApplyCaptor) -> SSMockCallExpectation {
        return expect() { $0.notify(updates: $1.capture(updates), onApply: $1.capture(onApply)) }
    }
    
    @discardableResult
    open func expectNotifyAndAsync(updates: SSValueCaptor<[SSUpdate]>) -> SSMockCallExpectation {
        let captor = applyCaptor()
        
        return expectNotify(updates: updates, onApply: captor)
            .andAsync() { captor.released?() }
    }
    
    func applyCaptor() -> OnApplyCaptor {
        return .forClosure()
    }
}
