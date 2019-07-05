import Foundation

class SSDataBaseSavePointReleaseDecorator: SSReleaseDecorator {
    var savePoint : SSDataBaseSavePointProtocol { return decorated as! SSDataBaseSavePointProtocol }
    
    init(savePoint: SSDataBaseSavePointProtocol, onCreate: @escaping (SSDataBaseSavePointProtocol) -> Void, onRelease mOnRelease: @escaping (SSDataBaseSavePointProtocol) -> Void) {
        super.init(decorated: savePoint, onCreate: onCreate as! (SSReleasable) -> Void, onRelease: mOnRelease as! (SSReleasable) -> Void)
    }
}

extension SSDataBaseSavePointReleaseDecorator: SSDataBaseSavePointProtocol {
    func rollBack() {
        savePoint.rollBack()
    }
}
