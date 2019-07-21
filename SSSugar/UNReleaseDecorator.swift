import Foundation

//There is no way to use Generic. Will run into 'Protocol 'Releasable' doesn't conform to protocolo 'Releasable'
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
