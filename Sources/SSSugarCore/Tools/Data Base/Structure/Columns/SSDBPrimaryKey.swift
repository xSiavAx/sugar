import Foundation

enum SSDBPrimaryKeyError: Error {
    case columsHasDifferentTable
}

public struct SSDBPrimaryKey: SSDBPrimaryKeyProtocol {
    typealias TError = SSDBPrimaryKeyError
    public var table: SSDBTable.Type
    
    public let cols: [SSDBColumnProtocol]
    
    public init(_ cols: SSDBColumnProtocol...) throws {
        try self.init(cols: cols)
    }
    
    public init(cols: [SSDBColumnProtocol]) throws {
        guard let table = SSDBTableComponentHelp.commonTable(cols) else { throw TError.columsHasDifferentTable }
        self.table = table
        self.cols = cols
    }
}
