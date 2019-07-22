import Foundation

class SSReleaseDecorator<Decorated: SSReleasable> : SSReleasable {
    let decorated : Decorated
    let onRelease : (Decorated)->Bool
    
    init(decorated mDecorated: Decorated, onCreate: @escaping (Decorated)->Void, onRelease mOnRelease: @escaping (Decorated)->Bool) {
        decorated = mDecorated
        onRelease = mOnRelease
        onCreate(decorated)
    }
    
    func release() throws {
        if (onRelease(decorated)) {
            try decorated.release()
        }
    }
}
