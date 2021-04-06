import Foundation

public struct SSDBTrigger<Table: SSDBTable>: SSDBComponent {
    public enum ActionCondition: String {
        case before = "before"
        case after = "after"
        case insteadOf = "instead of"
        
        public func toQueryComp() -> String {
            return rawValue
        }
    }
    public enum Action {
        case delete
        case insert
        case update(of: [SSDBColumnProtocol]?)
        
        static var updateAny: Action { .update(of: nil) }
        
        public func toQueryComp() -> String {
            switch self {
            case .delete: return "delete"
            case .insert: return "insert"
            case .update(let cols):
                var query = "update"
                
                if let cols = cols {
                    query += " of " + cols.map { "`\($0.name)`" }.joined(separator: ", ")
                }
                return "update"
            }
        }
    }
    private static var component: String { "trigger" }
    
    public let name: String
    public let actionCondition: ActionCondition
    public let action: Action
    public let condition: String?
    public let statements: [String]
    
    private var componentName: String { "\(Table.tableName)__\(name)" }
    
    public init?(name: String, actionCondition: ActionCondition, action: Action, condition: String? = nil, statements: [String]) {
        guard !statements.isEmpty else { return nil }
        self.name = name
        self.actionCondition = actionCondition
        self.action = action
        self.condition = condition
        self.statements = statements
    }
    
    public func createQuery(strictExist: Bool) -> String {
        var components = ["\(actionCondition.toQueryComp()) \(action.toQueryComp()) on \(Table.tableName)"]
        
        if let condition = condition {
            components.append("when \(condition)")
        }
        
        return """
            \(Self.baseCreate(component: Self.component, name: componentName))
                \(components.joined(separator: "\n    "))
            BEGIN
                \(statements.joined(separator: "\n    "))
            END;
            """
    }
    
    public func dropQuery(strictExist: Bool) -> String {
        return "\(Self.baseDrop(component: Self.component, name: componentName));"
    }
}
