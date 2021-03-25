import Foundation

public protocol SSDBTableComponent {
    func toCreate() -> String
}

public protocol SSDBColumnProtocol: SSDBTableComponent {
    var name: String { get }
}

public protocol SSDBRegualColumnProtocol: SSDBColumnProtocol {
    var unique: Bool { get }
    var optional: Bool { get }
}

public protocol SSDBTypedColumnProtocol: SSDBRegualColumnProtocol {
    associatedtype ColType: SSDBColType
}

public protocol SSDBColumnRefProtocol: SSDBColumnProtocol {
    var name: String { get }
    var refname: String { get }
}

public typealias SSDBTypedTableColumnRef = SSDBTypedTableComponent & SSDBColumnRefProtocol

public protocol SSDBTypedTableComponent {
    associatedtype OtherTable: SSDBTable
}
