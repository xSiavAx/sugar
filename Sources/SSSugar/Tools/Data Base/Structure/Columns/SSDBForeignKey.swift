import Foundation

public struct SSDBForeignKey<OtherTable: SSDBTable>: SSDBTableComponent, SSDBTypedTableComponent {
    private let refCols: [SSDBColumnRefProtocol]
    
    public func toCreate() -> String {
        let names = namesUsing() { $0.name }
        let refNmes = namesUsing() { $0.refname }
        
        return "foreign key(\(names)) references `\(OtherTable.tableName)`(\(refNmes))"
    }
    
    public init(cols: [SSDBColumnRefProtocol], on: OtherTable.Type) {
        refCols = cols
    }
    
    public init<Col: SSDBTypedTableColumnRef>(col: Col) where Col.OtherTable == OtherTable {
        self.init(cols: [col], on: OtherTable.self)
    }
    
    private func namesUsing(_ block: (SSDBColumnRefProtocol) -> String) -> String {
        return refCols.map { "`\(block($0))`" }.joined(separator: ", ")
    }
    
    public static func +(left: Self, right: Self) -> Self {
        return Self(cols: left.refCols + right.refCols, on: OtherTable.self)
    }
}
