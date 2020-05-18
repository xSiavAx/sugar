import Foundation

/// Requirements for Mutator's Entity source.
public protocol SSMutatingEntitySource: AnyObject {
    /// Source Entity type
    associatedtype Entity
    
    /// Returns entity for Mutator
    /// - Parameter updater: Mutator that requiries entity.
    func entity<Mutating: SSBaseEntityMutating>(for mutator: Mutating) -> Entity?
}

/// Addon for Entity Mutator. `newMarker()` has default implementation.
public protocol SSMarkerGenerating {
    static func newMarker() -> String
}

extension SSMarkerGenerating {
    public static func newMarker() -> String { return UUID().uuidString }
}

/// Requirements for Entity Mutator with some addons (like marker generating or dispatching on main queue).
///
/// # Conforms to:
/// `SSMarkerGenerating`, `SSOnMainExecutor`
public protocol SSBaseEntityMutating: SSMarkerGenerating, SSOnMainExecutor {
    /// Mutator's entity Source Type
    associatedtype Source: SSMutatingEntitySource
    /// Mutator's Entity Type (`Source.Entity` shortcut)
    typealias Entity = Source.Entity
    
    /// Object that give's (and potentially own) entity object to mutate.
    var source: Source? {get}
    
    /// Starts `Updater`.
    /// - Parameter source: Entity source.
    ///
    /// Implementation should include source assigning.
    func start(source: Source)
    
    /// Stops `Updater`.
    func stop()
}
