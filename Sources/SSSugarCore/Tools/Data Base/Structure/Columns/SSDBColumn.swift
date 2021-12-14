import Foundation

public struct SSDBColumn<ColType: SSDBColType>: SSDBTypedColumnProtocol {
    public var table: SSDBTable.Type
    private let name: String
    public let defaultVal: ColType?
    public var optional: Bool { ColType.isOptionalCol }
    
    public init(_ table: SSDBTable.Type, name: String, defaultVal: ColType? = nil) {
        self.table = table
        self.defaultVal = defaultVal
        self.name = name
    }
    
    public func nameFor(select: Bool) -> String {
        if (select) {
            return "\(table.tableName).\(name)"
        }
        return "\(name)"
    }
    
    public func toCreate() -> String {
        return "\(nameFor(select: false)) \(ColType.colName)\(createAdditions())"
    }
    
    private func createAdditions() -> String {
        var additions = [String]()
        
        if let defaultVal = defaultVal?.asColDefault() {
            additions.append("default `\(defaultVal)`")
        }
        if (!optional) {
            additions.append("not null")
        }
        guard !additions.isEmpty else { return "" }
        
        return " \(additions.joined(separator: " "))"
    }
}
