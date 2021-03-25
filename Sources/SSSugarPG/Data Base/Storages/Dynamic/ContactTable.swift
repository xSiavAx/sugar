import Foundation
import SSSugar

extension DynamicStorage {
    struct Contact: SSDBTableWithID {
        static var tableName: String { "contact_phone" }
        static var idColumn: SSDBColumnProtocol = id
        static var idLessColumns: [SSDBColumnProtocol] = [firstName, lastName, birthDay, color, initials, notes, company]
        
        static let id = SSDBColumn<Int>(name: "id", primaryKey: true)
        static let firstName = SSDBColumn<String?>(name: "first_name")
        static let lastName = SSDBColumn<String?>(name: "last_name")
        static let birthDay = SSDBColumn<Date?>(name: "birth_day")
        static let color = SSDBColumn<Int?>(name: "color")
        static let initials = SSDBColumn<String?>(name: "initials")
        static let notes = SSDBColumn<String?>(name: "notes")
        static let company = SSDBColumn<String?>(name: "company")
    }
}

