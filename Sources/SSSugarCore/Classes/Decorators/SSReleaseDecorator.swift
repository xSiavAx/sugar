import Foundation

public class SSReleaseDecorator<Decorated: SSReleasable> : SSReleasable {
    public let decorated : Decorated
    public let onRelease : (Decorated) -> Bool
    
    public init(decorated mDecorated: Decorated, onCreate: @escaping (Decorated)->Void, onRelease mOnRelease: @escaping (Decorated)->Bool) {
        decorated = mDecorated
        onRelease = mOnRelease
        onCreate(decorated)
    }
    
    public func release() throws {
        if (onRelease(decorated)) {
            try decorated.release()
        }
    }
}
