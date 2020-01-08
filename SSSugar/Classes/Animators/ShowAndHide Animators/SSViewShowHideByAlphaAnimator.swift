import Foundation

public class SSViewShowHideByAlphaAnimator {
    public static let defaultDuration = 0.25
    public static let defaultPrepareAlpha = CGFloat(0)
    
    public var prepareAlpha: CGFloat
    public var duration: TimeInterval
    
    private var animator: UIViewPropertyAnimator?
    
    public init(duration mDuration: Double = defaultDuration, alphaOnPrepare: CGFloat = defaultPrepareAlpha) {
        duration = mDuration
        prepareAlpha = alphaOnPrepare
    }
    
    private func stopAnimationIfNeeded() {
        if let mAnimator = animator {
            mAnimator.stopAnimation(false)
            mAnimator.finishAnimation(at: .current)
            animator = nil
        }
    }
    
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
