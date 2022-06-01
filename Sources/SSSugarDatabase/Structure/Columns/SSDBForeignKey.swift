import Foundation

enum SSDBForeignKeyError: Error {
    case columsHasDifferentTable
    case columReferencesHasDifferentTable
}

public struct SSDBForeignKey: SSDBTableComponent {
    typealias TError = SSDBForeignKeyError
    public var table: SSDBTable.Type
    public var refTable: SSDBTable.Type
    
    private let refCols: [SSDBColumnRefProtocol]
    
    public func toCreate() -> String {
        let names = namesUsing() { $0.nameFor(select: false) }
        let refNmes = namesUsing() { $0.reference.nameFor(select: false) }
        
        return "foreign key(\(names)) references `\(refTable.tableName)`(\(refNmes))"
    }
    
    public init(_ cols: SSDBColumnRefProtocol...) throws {
        try self.init(cols: cols)
    }
    
    public init(cols: [SSDBColumnRefProtocol]) throws {
        guard let table = SSDBTableComponentHelp.commonTable(cols) else { throw TError.columsHasDifferentTable }
        guard let refTable = SSDBTableComponentHelp.commonTable(cols.map{ $0.reference }) else { throw TError.columsHasDifferentTable }
        
        self.table = table
        self.refTable = refTable
        self.refCols = cols
    }

    private func namesUsing(_ block: (SSDBColumnRefProtocol) -> String) -> String {
        return refCols.map { "`\(block($0))`" }.joined(separator: ", ")
    }
}
