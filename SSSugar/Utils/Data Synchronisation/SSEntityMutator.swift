import Foundation

/// Requirements for entity source for SSEntityMutator
public protocol SSMutatingEntitySource: AnyObject {
    associatedtype Entity
    
    func entity<Mutating: SSBaseEntityMutating>(for mutator: Mutating) -> Entity?
}

/// Addon for Entity Mutator. `newMarker()` has default implementation.
public protocol SSEntityMutating {
    static func newMarker() -> String
}

extension SSEntityMutating {
    public static func newMarker() -> String { return UUID().uuidString }
}

/// Requirements for Entity Mutator with some addons (like marker generating or dispatching on main queue)
public protocol SSBaseEntityMutating: SSEntityMutating, SSOnMainExecutor {
    associatedtype Source: SSMutatingEntitySource
    typealias Entity = Source.Entity
    
    /// Object that give's (and potentially own) entity object to mutate.
    var source: Source {get}
}
