import Foundation

enum SSDBColError: Error {
    case unimplemented
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
        if (try isOptionalCol && stmt.isNull(pos: pos)) {
            return try onGetNil()
        }
        return try onGetNonNil(stmt: stmt, pos: pos)
    }
    
    static func onGetNil() throws -> Self {
        throw SSDBColError.unimplemented
    }
}

extension Int: SSDBColType {
    public static var colName: String { "integer" }
    
    public func asColDefault() -> String { "\(self)" }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> Int {
        return try stmt.getInt(pos: pos)
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        try stmt.bind(int: self, pos: pos)
    }
}

extension Int64: SSDBColType {
    public static var colName: String { "integer" }
    
    public func asColDefault() -> String { "\(self)" }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> Int64 {
        return try stmt.getInt64(pos: pos)
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        try stmt.bind(int64: self, pos: pos)
    }
}

extension Bool: SSDBColType {
    public static var colName: String { Int.colName }
    
    public func asColDefault() -> String { "\(self ? 1 : 0)" }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> Bool {
        return try stmt.getInt(pos: pos) != 0
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        try stmt.bind(int: self ? 1 : 0, pos: pos)
    }
}

extension Date: SSDBColType {
    public static var colName: String { Int.colName }
    
    public func asColDefault() -> String { "\(self.timeIntervalSince1970)" }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> Date {
        return Date(timeIntervalSince1970: try stmt.getDouble(pos: pos))
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        try stmt.bind(double: timeIntervalSince1970, pos: pos)
    }
}

extension String: SSDBColType {
    public static var colName: String { "text" }
    
    public func asColDefault() -> String { "\(self)" }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> String {
        return try stmt.getString(pos: pos)
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        try stmt.bind(string: self, pos: pos)
    }
}

extension Data: SSDBColType {
    public static var colName: String { "blob" }
    
    public func asColDefault() -> String { fatalError("Not implemented") }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> Data {
        return try stmt.getData(pos: pos)
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        try stmt.bind(data: self, pos: pos)
    }
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

public extension RawRepresentable where RawValue: SSDBColType {
    static var colName: String { RawValue.colName }

    static func onGetNonNil(stmt: SSDataBaseStatementProtocol, pos: Int) throws -> Self {
        return Self(rawValue: try RawValue.onGetNonNil(stmt: stmt, pos: pos))!
    }
    
    func bindTo(stmt: SSDataBaseStatementProtocol, pos: Int) throws {
        try rawValue.bindTo(stmt: stmt, pos: pos)
    }
    
    func asColDefault() -> String {
        return rawValue.asColDefault()
    }
}

extension URL: SSDBColType {
    public static var colName: String { String.colName }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> URL {
        return URL(string: try String.onGetNonNil(stmt: stmt, pos: pos))!
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        try path.bindTo(stmt: stmt, pos: pos)
    }
    
    public func asColDefault() -> String {
        return path
    }
}

