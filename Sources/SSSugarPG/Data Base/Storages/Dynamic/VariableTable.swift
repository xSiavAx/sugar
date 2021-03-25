import Foundation
import SSSugar

extension DynamicStorage {
    struct Variable: SSDBTableWithID {
        enum Key: String {
            case revision = "revision"
        }
        static let tableName: String = "Variable"
        static var idColumn: SSDBColumnProtocol = id
        static var idLessColumns: [SSDBColumnProtocol] = [ val ]
        static var indexCols: [SSDBColumnProtocol]? = [ val ]
        
        static let id = SSDBColumn<String>(name: "id", primaryKey: true)
        static let val = SSDBColumn<Data>(name: "value")
        
        static func updateRevision() -> SSDBQueryProcessor<Int, Void> {
            return updateWith(key: .revision)
        }
        
        private static func updateWith<T: SSDBColType>(key: Key) -> SSDBQueryProcessor<T, Void> {
            return SSDBQueryProcessor(updateQuery(), onBind: {(processor, val) in
                try processor.bind(val)
                try processor.bind(key.rawValue)
            })
        }
    }
}
