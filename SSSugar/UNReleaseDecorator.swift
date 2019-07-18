import Foundation

#warning("TODO: Try to use GENERIC to avoid properties and init arguments casts in inheritors")

class SSReleaseDecorator: SSReleasable {
    let decorated : SSReleasable
    let onRelease : (SSReleasable)->Void
    
    init(decorated mDecorated: SSReleasable, onCreate: @escaping (SSReleasable)->Void, onRelease mOnRelease: @escaping (SSReleasable)->Void) {
        decorated = mDecorated
        onRelease = mOnRelease
        onCreate(decorated)
    }
    
    //MARK: - Releasable
    func release() throws {
        try decorated.release()
        onRelease(decorated)
    }
}
