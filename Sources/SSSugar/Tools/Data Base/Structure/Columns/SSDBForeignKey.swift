import Foundation

public struct SSDBForeignKey<Table: SSDBTable>: SSDBTableComponent {
    private let refCols: [SSDBColumnRefProtocol]
    
    public func toCreate() -> String {
        let names = namesUsing() { $0.name }
        let refNmes = namesUsing() { $0.refname }
        
        return "foreign key(\(names)) references `\(Table.tableName)`(\(refNmes))"
    }
    
    public init(cols: (Table.Type) -> [SSDBColumnRefProtocol]) {
        refCols = cols(Table.self)
    }
    
    public init(col: (Table.Type) -> SSDBColumnRefProtocol) {
        self.init(cols: { [col($0)] } )
    }
    
    private func namesUsing(_ block: (SSDBColumnRefProtocol) -> String) -> String {
        return refCols.map { "`\(block($0))`" }.joined(separator: ", ")
    }
}
