import Foundation

public protocol SSDBTableComponent {
    func toCreate() -> String
}

public protocol SSDBTypedTableComponent {
    associatedtype OtherTable: SSDBTable
}

public protocol SSDBColumnProtocol: SSDBTableComponent {
    var name: String { get }
    var optional: Bool { get }
}

public protocol SSDBTypedColumnProtocol: SSDBColumnProtocol {
    associatedtype ColType: SSDBColType
}

public protocol SSDBColumnRefProtocol: SSDBColumnProtocol {
    var refname: String { get }
}

public typealias SSDBTypedTableColumnRef = SSDBTypedTableComponent & SSDBColumnRefProtocol

public protocol SSDBPrimaryKeyProtocol: SSDBTableComponent {
    var cols: [SSDBColumnProtocol] { get }
}

extension SSDBPrimaryKeyProtocol {
    public func toCreate() -> String {
        let colNames = cols.map { "`\($0.name)`" }
        
        return "primary key(\(colNames.joined(separator: ", ")))"
    }
}

public protocol ForeignKeyProducer {
    func foreignKey() -> SSDBTableComponent
}
