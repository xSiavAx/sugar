#if !os(macOS)
import UIKit

/// Iteraction blocking requiremetns
public protocol SSInteractionBlocking {
    /// Block iteractions
    func blockInteraction()
    
    /// Unblock iteractions
    func unblockInteraction()
}

/// Requirements for view blocking. Extends SSInteractionBlocking with `animated` option.
public protocol SSViewBlocking: SSInteractionBlocking {
    /// Block interactions
    /// - Parameter animated: Indicates should blocking be animated or not. Default value is `false`
    func blockInteraction(animated : Bool)
    
    /// - Parameter animated: Indicates should blocking be animated or not. Default value is `false`
    func unblockInteraction(animated : Bool)
}

extension SSViewBlocking {
    public func blockInteraction() {
        blockInteraction(animated: false)
    }
    
    public func unblockInteraction() {
        unblockInteraction(animated: false)
    }
}

public extension SSViewBlocking {
    /// Blocking animation duration default value (by design it equals to default animation duration).
    static var defaultBlockingAnimationDuration: TimeInterval { UIView.defaultAnimationDuration }
}

/// Requerements for View Delayed blocking. Extends SSViewBlocking with `delayed` param on block.
///
/// Protocol has default implementation for any entity implementing `SSViewProtectingHelped`.
public protocol SSViewDelayedBlocking: SSViewBlocking {
    /// Block interactions
    /// - Parameters:
    ///   - animated: Indicates should blocking be animated or not. Default value is `false`
    ///   - withDelay: Indicates should blocking be delayed or not. Default values os `false`
    /// Ussually delay used only for "visual" delay (affects animation only), but interaction blocks immediately any  way.
    func blockInteraction(animated : Bool, withDelay : Bool)
}

public extension SSViewDelayedBlocking {
    func blockInteraction(animated : Bool) {
        blockInteraction(animated: animated, withDelay: false)
    }
}

extension SSViewDelayedBlocking where Self: SSViewProtectingHelped {
    public func blockInteraction(animated : Bool = false, withDelay : Bool = false) {
        protectionHelper.blockInteraction(animated: animated, withDelay: withDelay)
    }
    
    public func unblockInteraction(animated: Bool) {
        protectionHelper.unblockInteraction(animated: animated)
    }
}
#endif
