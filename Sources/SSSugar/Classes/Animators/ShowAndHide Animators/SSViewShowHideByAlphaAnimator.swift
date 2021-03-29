#if canImport(UIKit)
import UIKit

/// Class implements `SSViewShowHideAnimating`. It purpose alpha change animation with show/hide view on show start and hide finish. Method `prepareToShow` shows view and change it alpha equals to passed one (`prepareAlpha`).
public class SSViewShowHideByAlphaAnimator {
    /// Default animation duration
    public static let defaultDuration = 0.25
    /// Default alpah value on prepare
    public static let defaultPrepareAlpha = CGFloat(0)
    
    /// Alpha value that view will get on prepare to show
    public var prepareAlpha: CGFloat
    /// Animation duration
    public var duration: TimeInterval
    
    /// Animator using to implement animation
    private var animator: UIViewPropertyAnimator?
    
    /// Create new animator
    /// - Parameters:
    ///   - duration: Animation duration
    ///   - alphaOnPrepare: Alpha value animated view will after prepare to show call
    public init(duration mDuration: Double = defaultDuration, alphaOnPrepare: CGFloat = defaultPrepareAlpha) {
        duration = mDuration
        prepareAlpha = alphaOnPrepare
    }
    
    
    //MARK: - private
    
    /// Stops current animation (if one exist) on its current state
    private func stopAnimationIfNeeded() {
        if let mAnimator = animator {
            mAnimator.stopAnimation(false)
            mAnimator.finishAnimation(at: .current)
            animator = nil
        }
    }
    
    /// Add animation with new `animator`
    private func animate(animations: @escaping ()->Void, complition: @escaping (UIViewAnimatingPosition) -> Void) {
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: animations)
        animator?.addCompletion(complition)
        
        animator?.startAnimation()
    }
}

extension SSViewShowHideByAlphaAnimator: SSViewShowHideAnimating {
    public func prepareToShow(_ view: UIView, with containing: SSViewShowHideContaining) {
        stopAnimationIfNeeded()
        view.isHidden = false
        view.alpha = prepareAlpha
    }
    
    public func show(_ view: UIView, with containing: SSViewShowHideContaining, animated: Bool, complition: ((Bool) -> Void)?) {
        func makeVisible() { view.alpha = 1.0 }
        
        if (animated) {
            animate(animations: makeVisible)  { complition?($0 == .end) }
        } else {
            makeVisible()
            complition?(true)
        }
    }
    
    public func hide(_ view: UIView, with containing: SSViewShowHideContaining, animated: Bool, complition: ((Bool) -> Void)?) {
        func makeInvisible() { view.alpha = 0.0 }
        
        stopAnimationIfNeeded()
        if (animated) {
            animate(animations: makeInvisible) { (pos) in
                view.isHidden = true
                complition?(pos == .end)
            }
        } else {
            makeInvisible()
            complition?(true)
        }
    }
}
#endif
