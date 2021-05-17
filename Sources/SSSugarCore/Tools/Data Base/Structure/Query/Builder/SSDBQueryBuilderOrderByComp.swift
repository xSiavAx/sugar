import Foundation

public extension SSDBQueryBuilder {
    struct OrderByComp {
        public enum Order: String {
            /// 0, 1, 2
            case asc = "asc"
            /// 2, 1, 0
            case desc = "desc"
        }
        public let col: Column
        public let table: TalbeT?
        public let order: Order
        
        public init(col: Column, table: TalbeT? = nil, order: Order = .asc) {
            self.col = col
            self.table = table
            self.order = order
        }

        public func toString() -> String {
            return "\(col.nameFor(select: true)) \(order.rawValue)"
        }
    }
}
