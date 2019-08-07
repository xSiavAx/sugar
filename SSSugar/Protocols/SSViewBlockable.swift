import Foundation

public protocol SSInteractionBlockable {
    func blockInteraction()
    func unblockInteraction()
}

public protocol SSViewBlockable: SSInteractionBlockable {
    func blockInteraction(animated : Bool);
    func unblockInteraction(animated : Bool);
}

extension SSViewBlockable {
    public func blockInteraction() {
        blockInteraction(animated: false)
    }
    
    public func unblockInteraction() {
        unblockInteraction(animated: false)
    }
}

public extension SSViewBlockable {
    static func defaultBlockingAnimationDuration() -> TimeInterval {
        return 0.25;
    }
}

public protocol SSViewDelayedBlockable : SSViewBlockable {
    func blockInteraction(animated : Bool, withDelay : Bool);
}

public extension SSViewDelayedBlockable {
    func blockInteraction(animated : Bool) {
        blockInteraction(animated: animated, withDelay: false)
    }
}
