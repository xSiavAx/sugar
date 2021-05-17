import Foundation

public protocol SSDBTableIndexProtocol: SSDBComponent {
    var table: SSDBTable.Type { get }
    var cols: [SSDBColumnProtocol] { get }
    var isUniqeu: Bool { get }
    var prefix: String { get }
}

public extension SSDBTableIndexProtocol {
    static var component: String { "index" }
    
    var name: String { "\(prefix)_\(table.tableName)_\(colNames.joined(separator: "__"))" }
    var colNames: [String] { cols.map { $0.nameFor(select: false) } }
    
    func createQueries(strictExist: Bool) -> [String] {
        let base = Self.baseCreate(prefixComps: uniqueComps(), component: Self.component, name: name, strictExist: strictExist)
        return ["\(base) on \(table.tableName) (\(colNames.joined(separator: ", ")));"]
    }
    
    func dropQueries(strictExist: Bool) -> [String] {
        return ["\(Self.baseDrop(component: Self.component, name: name, strictExist: strictExist));"]
    }
    
    
    private func uniqueComps() -> [String]? {
        if (isUniqeu) {
            return ["unique"]
        }
        return nil
    }
}

enum SSDBTableIndexError: Error {
    case columsFromDifferentTables
}

public struct SSDBTableIndex: SSDBTableIndexProtocol {
    typealias TError = SSDBTableIndexError
    public static var defaultPrefix: String { "index" }
    
    public var table: SSDBTable.Type
    public var cols: [SSDBColumnProtocol]
    public let isUniqeu: Bool
    public let prefix: String
    
    public init(isUnique unique: Bool, prefix mPrefix: String = defaultPrefix, cols: [SSDBColumnProtocol]) throws {
        guard let table = SSDBTableComponentHelp.commonTable(cols) else { throw TError.columsFromDifferentTables }
        self.cols = cols
        self.table = table
        self.isUniqeu = unique
        self.prefix = mPrefix
    }
}
