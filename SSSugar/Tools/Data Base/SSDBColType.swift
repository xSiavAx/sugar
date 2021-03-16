import Foundation

enum SSDBColError: Error {
    case unexpectedNull
}

public protocol SSDBColType {
    typealias Statement = SSDataBaseStatementProtocol
    typealias OnBind = (Self, Statement, Int) throws -> Void
    typealias OnGet = (Statement, Int) throws -> Self
    
    static var colName: String { get }
    static var isOptionalCol: Bool { get }
    
    static func onGetNil() throws -> Self
    static func onGetNonNil(stmt: Statement, pos: Int) throws -> Self
    
    func bindTo(stmt: Statement, pos: Int) throws
    func asColDefault() -> String
}

public extension SSDBColType {
    static var isOptionalCol: Bool { false }
    
    static func from(stmt: Statement, pos: Int) throws -> Self {
        if (try stmt.isNull(pos: pos)) {
            return try onGetNil()
        }
        return try onGetNonNil(stmt: stmt, pos: pos)
    }
    
    static func onGetNil() throws -> Self {
        throw SSDBColError.unexpectedNull
    }
}

public extension SSDBColType where Self: CustomStringConvertible {
    func asColDefault() -> String { return "\(self)" }
}

extension Optional: SSDBColType where Wrapped: SSDBColType {
    public typealias Value = Wrapped
    
    public static var colName: String { Wrapped.colName }
    public static var isOptionalCol: Bool { true }
    
    public static func onGetNil() throws -> Optional<Wrapped> {
        return nil
    }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> Optional<Wrapped> {
        try Wrapped.onGetNonNil(stmt: stmt, pos: pos)
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        switch self {
        case .some(let val):
            try val.bindTo(stmt: stmt, pos: pos)
        case .none:
            try stmt.bindNull(pos: pos)
        }
    }
    
    public func asColDefault() -> String {
        return "\(self!)"
    }
}

extension Int: SSDBColType {
    public static var colName: String { "integer" }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> Int {
        return try stmt.getInt(pos: pos)
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        try stmt.bind(int: self, pos: pos)
    }
}

extension String: SSDBColType {
    public static var colName: String { "text" }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> String {
        return try stmt.getString(pos: pos)
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        try stmt.bind(string: self, pos: pos)
    }
}

extension RawRepresentable where RawValue: SSDBColType {
    static var name: String { RawValue.colName }
    
    func asDefault() -> String {
        return rawValue.asColDefault()
    }
}
