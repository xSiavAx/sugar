import Foundation

public struct SSDBColumn<ColType: SSDBColType>: SSDBTypedColumnProtocol {
    public let name: String
    public let unique: Bool
    public let defaultVal: ColType?
    public var optional: Bool { ColType.isOptionalCol }
    
    public init(name mName: String, unique mUnique: Bool = false, defaultVal val: ColType? = nil) {
        name = mName
        unique = mUnique
        defaultVal = val
    }
    
    public func toCreate() -> String {
        return "`\(name)` \(ColType.colName)\(createAdditions())"
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
        guard !additions.isEmpty else { return "" }
        
        return " \(additions.joined(separator: " "))"
    }
}
