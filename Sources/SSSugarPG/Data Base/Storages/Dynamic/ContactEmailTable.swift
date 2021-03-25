import Foundation
import SSSugar

extension DynamicStorage {
    struct ContactEmail: SSDBTable {
        static let tableName = "contact_email"
        static var columns: [SSDBColumnProtocol] = [value, contact]
        static var indexCols: [SSDBColumnProtocol]? = [value]
        
        static let value = SSDBColumn<String>(name: "value")
        static let contact = SSDBForeignKey<Contact>() { $0.id }
    }
}

