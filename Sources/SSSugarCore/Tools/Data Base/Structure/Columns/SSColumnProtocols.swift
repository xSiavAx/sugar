import Foundation

public protocol SSDBTableComponent {
    var table: SSDBTable.Type { get }
    
    func toCreate() -> String
}

public enum SSDBTableComponentHelp {
    static func commonTable(_ comps: [SSDBTableComponent]) -> SSDBTable.Type? {
        let table = comps.first?.table
        
        for comp in comps {
            if (comp.table != table) {
                return nil
            }
        }
        return table
    }
}

public protocol SSDBColumnProtocol: SSDBTableComponent {
    var optional: Bool { get }
    
    func nameFor(select: Bool) -> String
}

public protocol SSDBTypedColumnProtocol: SSDBColumnProtocol {
    associatedtype ColType: SSDBColType
}

public protocol SSDBColumnRefProtocol: SSDBColumnProtocol, ForeignKeyProducer {
    var reference: SSDBColumnProtocol { get }
}

public protocol SSDBPrimaryKeyProtocol: SSDBTableComponent {
    var cols: [SSDBColumnProtocol] { get }
}

extension SSDBPrimaryKeyProtocol {
    public func toCreate() -> String {
        let colNames = cols.map { "`\($0.nameFor(select: false))`" }
        
        return "primary key(\(colNames.joined(separator: ", ")))"
    }
}

public protocol ForeignKeyProducer {
    func foreignKey() -> SSDBTableComponent
}
