import Foundation

public protocol SSDBColumnProtocol {
    var name: String { get }
    var unique: Bool { get }
    var optional: Bool { get }
    
    func toCreateComponent() -> String
}

#warning("todo")
//TODO: Could we add ColType to SSDBColumnProtocol, to make binding/getting more strength and based on colums?
