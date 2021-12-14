import Foundation

public extension SSDBQueryBuilder {
    enum ColComp {
        case select(Column)
        case update(Column)
        case regular(Column)
        case custom(String)
        
        func toQueryComp() -> String {
            switch self {
            case .select(let col): return col.nameFor(select: true)
            case .update(let col): return "`\(col.nameFor(select: false))` = ?"
            case .regular(let col): return col.nameFor(select: false)
            case .custom(let name): return name
            }
        }
    }
}
