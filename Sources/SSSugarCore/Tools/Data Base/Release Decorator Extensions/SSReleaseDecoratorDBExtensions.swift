import Foundation

extension SSReleaseDecorator: SSDataBaseSavePointProtocol & SSDataBaseSavePointProxing where Decorated : SSDataBaseSavePointProtocol {
    var savePoint : SSDataBaseSavePointProtocol { return decorated }
}

extension SSReleaseDecorator: SSDataBaseStatementProtocol & SSDataBaseBindingStatement & SSDataBaseGettingStatement & SSDataBaseStatementProxing where Decorated : SSDataBaseStatementProtocol {
    var statement: SSDataBaseStatementProtocol { return decorated }
}

