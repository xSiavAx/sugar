import Foundation

public protocol SSDBColumnProtocol {
    var name: String { get }
    var unique: Bool { get }
    var optional: Bool { get }
    
    func toCreateComponent() -> String
}
