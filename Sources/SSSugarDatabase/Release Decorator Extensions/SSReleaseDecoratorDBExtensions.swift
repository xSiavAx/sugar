import Foundation
import SSSugarCore

extension SSReleaseDecorator: SSDataBaseSavePointProtocol & SSDataBaseSavePointProxing where Decorated : SSDataBaseSavePointProtocol {
    public var savePoint : SSDataBaseSavePointProtocol { return decorated }
}

extension SSReleaseDecorator: SSDataBaseStatementProtocol & SSDataBaseBindingStatement & SSDataBaseGettingStatement & SSDataBaseStatementProxing where Decorated : SSDataBaseStatementProtocol {
    public var statement: SSDataBaseStatementProtocol { return decorated }
}

