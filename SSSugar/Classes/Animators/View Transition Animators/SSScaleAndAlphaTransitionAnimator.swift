#if !os(macOS)
import UIKit

/// Animator that change views scale and alpha.
/// - Warning: New subview must be inserted under old one.
public class SSScaleAndAlphaTransitionAnimator {
    public static let defaultDuration = 0.25
    public static let defaultMinScale = CGFloat(0.1)
    
    /// Animation duration
    public var duration: TimeInterval
    /// Scale hidding view scaling to.
    public let minScale: CGFloat
    /// SDK animator. It allows more control over animation.
    private var animator: UIViewPropertyAnimator?
    
    private var scaleTransfrom : CGAffineTransform { CGAffineTransform(scaleX: CGFloat(minScale), y: CGFloat(minScale)) }
    
    public init(duration mDuration: TimeInterval = defaultDuration, minScale mMinScale: CGFloat = defaultMinScale) {
        duration = mDuration
        minScale = mMinScale
    }
    
    private func stopAnimationIfNeeded() {
        if let mAnimator = animator {
            mAnimator.stopAnimation(false)
            mAnimator.finishAnimation(at: .end)
            animator = nil
        }
    }
}

extension SSScaleAndAlphaTransitionAnimator: SSViewTransitionAnimating {
    public func transition(from oldView: UIView, to newView: UIView, by container: SSViewTransitionContaining, onFinish: @escaping (UIViewAnimatingPosition) -> Void) {
        func animation() {
            oldView.transform = scaleTransfrom
            oldView.alpha = 0
            newView.transform = CGAffineTransform(scaleX:1, y:1)
            newView.alpha = 1
        }
        newView.frame = container.frameForContent()
        newView.transform = scaleTransfrom
        newView.alpha = 0

        stopAnimationIfNeeded()
        
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: animation)
        animator?.addCompletion(onFinish)
        
        animator?.startAnimation()
    }
}
#endif
