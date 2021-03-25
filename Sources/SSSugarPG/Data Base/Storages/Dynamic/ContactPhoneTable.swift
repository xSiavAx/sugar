import Foundation
import SSSugar

extension DynamicStorage {
    struct ContactPhone: SSDBTable {
        static let tableName = "contact"
        static var columns: [SSDBColumnProtocol] = [value, contact]
        
        static let value = SSDBColumn<String>(name: "value")
        static let contact = SSDBForeignKey<Contact>() { $0.id }
    }
}
