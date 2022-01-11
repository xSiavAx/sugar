import Foundation

enum SSDBColError: Error {
    case unimplemented
    case cantCreateFromBase(SSDBColType)
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

/// Protocol for types, which value may be represented via other type that conforms to `DBColType`.
///
/// Provides default implementation for `DBColType` via proxing calls to `BaseCol` type and `baseCol` property.
public protocol SSDBColTypeBased: SSDBColType {
    associatedtype BaseCol: SSDBColType
    
    var baseCol: BaseCol { get }
    
    init?(baseCol: BaseCol)
}

public extension SSDBColTypeBased {
    static var colName: String { BaseCol.colName }
    
    func asColDefault() -> String { baseCol.asColDefault() }
    
    static func onGetNonNil(stmt: SSDataBaseStatementProtocol, pos: Int) throws -> Self {
        let base = try BaseCol.onGetNonNil(stmt: stmt, pos: pos)
        
        guard let result = Self(baseCol: base) else {
            throw SSDBColError.cantCreateFromBase(base)
        }
        return result
    }
    
    func bindTo(stmt: SSDataBaseStatementProtocol, pos: Int) throws {
        try baseCol.bindTo(stmt: stmt, pos: pos)
    }
}

//MARK: - Base Types

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

extension Double: SSDBColType {
    public static var colName: String { "real" }
    
    public func asColDefault() -> String { "\(self)" }
    
    public static func onGetNonNil(stmt: Statement, pos: Int) throws -> Double {
        return try stmt.getDouble(pos: pos)
    }
    
    public func bindTo(stmt: Statement, pos: Int) throws {
        try stmt.bind(double: self, pos: pos)
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

//MARK: - DBColType based Types

extension RawRepresentable where RawValue: SSDBColType {
    public var baseCol: RawValue { rawValue }
    
    public init?(baseCol: RawValue) {
        self.init(rawValue: baseCol)
    }
}

extension Bool: SSDBColTypeBased {
    public var baseCol: Int { self ? 1 : 0 }
    
    public init(baseCol: Int) {
        self = baseCol != 0
    }
}

extension Date: SSDBColTypeBased {
    public var baseCol: Double { self.timeIntervalSinceReferenceDate }
    
    public init(baseCol: Double) {
        self.init(timeIntervalSinceReferenceDate: baseCol)
    }
}

extension URL: SSDBColTypeBased {
    public var baseCol: String { self.path }
    
    public init?(baseCol: String) {
        self.init(string: baseCol)
    }
}
