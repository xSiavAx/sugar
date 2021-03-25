import Foundation

public struct SSDBColumn<Type: SSDBColType>: SSDBColumnProtocol {
    public let name: String
    public let unique: Bool
    public let primaryKey: Bool
    public let defaultVal: Type?
    public var optional: Bool { Type.isOptionalCol }
    
    public init(name mName: String, unique mUnique: Bool = false, primaryKey pk: Bool = false, defaultVal val: Type? = nil) {
        name = mName
        unique = mUnique
        primaryKey = pk
        defaultVal = val
    }
    
    public func toCreateComponent() -> String {
        return "`\(name)` \(Type.colName)\(createAdditions())"
    }
    
    private func createAdditions() -> String {
        var additions = [String]()
        
        if let defaultVal = defaultVal?.asColDefault() {
            additions.append("default `\(defaultVal)`")
        }
        if (!optional) {
            additions.append("not null")
        }
        if (unique) {
            additions.append("unique")
        }
        if (primaryKey) {
            additions.append("primary key")
        }
        guard !additions.isEmpty else { return "" }
        
        return " \(additions.joined(separator: " "))"
    }
}
