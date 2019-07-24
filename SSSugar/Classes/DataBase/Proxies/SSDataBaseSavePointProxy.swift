import Foundation

protocol SSDataBaseSavePointProxing : SSDataBaseSavePointProtocol {
    var savePoint : SSDataBaseSavePointProtocol {get}
}

extension SSDataBaseSavePointProxing {
    func rollBack() throws {
        try savePoint.rollBack()
    }
    
    func release() throws {
        try savePoint.release()
    }
}

struct SSDataBaseSavePointProxy : SSDataBaseSavePointProxing {
    let savePoint: SSDataBaseSavePointProtocol
}
