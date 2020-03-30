#if !os(macOS)
import UIKit

public protocol SSViewTransitionContaining {
    /// Frame that content view should fill on animation finish
    func frameForContent() -> CGRect
}

public protocol SSViewTransitionAnimating {
    func transition(from oldView: UIView, to newView: UIView, by container: SSViewTransitionContaining, onFinish: @escaping (UIViewAnimatingPosition)->Void)
}
#endif
