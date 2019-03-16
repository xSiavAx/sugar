import Foundation

public protocol SSViewBlockable {
    func blockInteraction(animated : Bool);
    func unblockInteraction(animated : Bool);
}

public protocol SSViewDelayedBlockable : SSViewBlockable {
    func blockInteraction(animated : Bool, withDelay : Bool);
}

public extension SSViewBlockable {
    static func defaultBlockingAnimationDuration() -> TimeInterval {
        return 0.25;
    }
}

public extension SSViewDelayedBlockable {
    func blockInteraction(animated : Bool) {
        self.blockInteraction(animated: animated, withDelay: false)
    }
}
