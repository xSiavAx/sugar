import Foundation

class SSDataBaseSavePointReleaseDecorator: SSReleaseDecorator {
    var savePoint : SSDataBaseSavePointProtocol { return decorated as! SSDataBaseSavePointProtocol }
    
    init(savePoint: SSDataBaseSavePointProtocol, onCreate: @escaping (SSDataBaseSavePointProtocol) -> Void, onRelease: @escaping (SSDataBaseSavePointProtocol) -> Void) {
        super.init(decorated: savePoint, onCreate: {onCreate($0 as! SSDataBaseSavePointProtocol)}, onRelease: {onRelease($0 as! SSDataBaseSavePointProtocol)})
    }
}

extension SSDataBaseSavePointReleaseDecorator: SSDataBaseSavePointProtocol {
    func rollBack() throws {
        try savePoint.rollBack()
    }
}
