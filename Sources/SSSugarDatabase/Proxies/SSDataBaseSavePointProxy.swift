import Foundation

public protocol SSDataBaseSavePointProxing : SSDataBaseSavePointProtocol {
    var savePoint : SSDataBaseSavePointProtocol {get}
}

public extension SSDataBaseSavePointProxing {
    func rollBack() throws {
        try savePoint.rollBack()
    }
    
    func release() throws {
        try savePoint.release()
    }
}

public struct SSDataBaseSavePointProxy : SSDataBaseSavePointProxing {
    public let savePoint: SSDataBaseSavePointProtocol
}
