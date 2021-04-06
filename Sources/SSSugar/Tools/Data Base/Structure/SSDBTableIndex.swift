import Foundation

public protocol SSDBTableIndexProtocol: SSDBComponent {
    var name: String { get }
    var tableName: String { get }
    var colNames: [String] { get }
    var isUniqeu: Bool { get }
    var prefix: String { get }
}

public extension SSDBTableIndexProtocol {
    static var component: String { "index" }
    
    func createQuery(strictExist: Bool) -> String {
        let base = Self.baseCreate(prefixComps: uniqueComps(), component: Self.component, name: name, strictExist: strictExist)
        return "\(base) on `\(tableName)` (\(colNames()));"
    }
    
    func dropQuery(strictExist: Bool) -> String {
        return "\(Self.baseDrop(component: Self.component, name: name, strictExist: strictExist));"
    }
    
    private func colNames() -> String {
        return colNames.map { "`\($0)`" }.joined(separator: ", ")
    }
    
    private func uniqueComps() -> [String]? {
        if (isUniqeu) {
            return ["unique"]
        }
        return nil
    }
}

public struct SSDBTableIndex<Table: SSDBTable>: SSDBTableIndexProtocol {
    public static var defaultPrefix: String { "index" }
    
    public var name: String { "\(prefix)_\(tableName)_\(nameColSuffix())" }
    public var tableName: String { Table.tableName }
    public let colNames: [String]
    public let isUniqeu: Bool
    public let prefix: String
    
    public init(isUnique uniqeu: Bool, prefix mPrefix: String = defaultPrefix, cols: (Table.Type) -> [SSDBColumnProtocol]) {
        colNames = cols(Table.self).map { $0.name }
        isUniqeu = uniqeu
        prefix = mPrefix
    }
    
    private func nameColSuffix() -> String {
        return colNames.joined(separator: "__")
    }
}
