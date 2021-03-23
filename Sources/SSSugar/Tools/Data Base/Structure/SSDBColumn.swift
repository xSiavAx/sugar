import Foundation

public protocol SSDBColumnProtocol {
    var name: String { get }
    var unique: Bool { get }
    var optional: Bool { get }
    var primaryKey: Bool { get }
    
    var colName: String { get }
    var defaultValComponent: String? { get }
    
    func toCreateComponent() -> String
}

public extension SSDBColumnProtocol {
    func toCreateComponent() -> String {
        return "`\(name)` \(colName)\(createAdditions())"
    }
    
    private func createAdditions() -> String {
        var additions = [String]()
        
        if let defaultVal = defaultValComponent {
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

public struct SSDBColumn<Type: SSDBColType>: SSDBColumnProtocol {
    public let name: String
    public let unique: Bool
    public let primaryKey: Bool
    public let defaultVal: Type?
    public var optional: Bool { Type.isOptionalCol }
    
    public var colName: String { Type.colName }
    public var defaultValComponent: String? { defaultVal?.asColDefault() }
    
    public init(name mName: String, unique mUnique: Bool = false, primaryKey pk: Bool = false, defaultVal val: Type? = nil) {
        name = mName
        unique = mUnique
        primaryKey = pk
        defaultVal = val
    }
}
