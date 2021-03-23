import Foundation

public protocol SSDBTableIndexProtocol {
    var colNames: [String] { get }
    var isUniqeu: Bool { get }
    var prefix: String { get }
    
    func nameIn(table: String) -> String
    
    func toCreateComponent(table: String) -> String
    func toDropComponent(table: String) -> String
}

public extension SSDBTableIndexProtocol {
    func nameIn(table: String) -> String {
        return "\(prefix)_\(table)_\(nameColSuffix())"
    }
    
    func toCreateComponent(table: String) -> String {
        return "create \(uniqueComp())index `\(nameIn(table: table))` on `\(table)` (\(colNames());"
    }
    
    func toDropComponent(table: String) -> String {
        return "drop index `\(nameIn(table: table))`;"
    }
    
    private func nameColSuffix() -> String {
        return colNames.joined(separator: "__")
    }
    
    private func colNames() -> String {
        return colNames.map { "`\($0)`" }.joined(separator: ", ")
    }
    
    private func uniqueComp() -> String {
        return isUniqeu ? "unique " : ""
    }
}

public struct SSDBTableIndex: SSDBTableIndexProtocol {
    public static let defaultPrefix = "index"
    
    public var colNames: [String]
    public var isUniqeu: Bool
    public var prefix: String
    
    public init(col: SSDBColumnProtocol, prefix mPrefix: String = defaultPrefix) {
        colNames = [col.name]
        isUniqeu = col.unique
        prefix = mPrefix
    }
    
    public init(cols: [SSDBColumnProtocol], isUnique uniqeu: Bool = true, prefix mPrefix: String = defaultPrefix) {
        colNames = cols.map { $0.name }
        isUniqeu = uniqeu
        prefix = mPrefix
    }
}
