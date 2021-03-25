import Foundation

public protocol SSDBTableIndexProtocol {
    var name: String { get }
    var tableName: String { get }
    var colNames: [String] { get }
    var isUniqeu: Bool { get }
    var prefix: String { get }
    
    func toCreateComponent() -> String
    func toDropComponent() -> String
}

public extension SSDBTableIndexProtocol {
    func toCreateComponent() -> String {
        return "create \(uniqueComp())index `\(name)` on `\(tableName)` (\(colNames()));"
    }
    
    func toDropComponent() -> String {
        return "drop index `\(name)`;"
    }
    
    private func colNames() -> String {
        return colNames.map { "`\($0)`" }.joined(separator: ", ")
    }
    
    private func uniqueComp() -> String {
        return isUniqeu ? "unique " : ""
    }
}

public struct SSDBTableIndex<Table: SSDBTable>: SSDBTableIndexProtocol {
    public static var defaultPrefix: String { "index" }
    
    public var name: String { "\(prefix)_\(tableName)_\(nameColSuffix())" }
    public var tableName: String { Table.tableName }
    public let colNames: [String]
    public let isUniqeu: Bool
    public let prefix: String
    
    public init(prefix mPrefix: String = defaultPrefix, col: (Table.Type) -> SSDBRegualColumnProtocol) {
        self.init(prefix: mPrefix, col: col(Table.self))
    }
    
    public init(isUnique uniqeu: Bool = true, prefix mPrefix: String = defaultPrefix, cols: (Table.Type) -> [SSDBRegualColumnProtocol]) {
        colNames = cols(Table.self).map { $0.name }
        isUniqeu = uniqeu
        prefix = mPrefix
    }
    
    internal init(prefix mPrefix: String = defaultPrefix, col: SSDBRegualColumnProtocol) {
        colNames = [col.name]
        isUniqeu = col.unique
        prefix = mPrefix
    }
    
    private func nameColSuffix() -> String {
        return colNames.joined(separator: "__")
    }
}
