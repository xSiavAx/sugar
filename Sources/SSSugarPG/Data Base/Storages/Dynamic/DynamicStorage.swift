import Foundation
import SSSugar

struct DynamicStorage: SSDBStoraging {
    static let name = "Dynamic"
    static var tables: [SSDBTable.Type] = [ContactEmail.self,
                                           ContactGroup.self,
                                           ContactPhone.self,
                                           Contact.self,
//                                           Folder.self,
                                           Identity.self,
                                           Variable.self,]
    
    var db: SSDataBase
    
    init(identifier: String) throws {
        db = try .dbWith(name: "dynamic", prefix: identifier)
    }
}

