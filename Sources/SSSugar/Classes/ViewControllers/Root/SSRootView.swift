#if canImport(UIKit)
import UIKit

open class SSRootView: UIView {
    private var contentView : UIView
    public let animator: SSViewTransitionAnimating
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(withContentView: UIView, animator mAnimator: SSViewTransitionAnimating = SSScaleAndAlphaTransitionAnimator()) {
        contentView = withContentView
        animator = mAnimator
        super.init(frame: .zero)
        
        addSubview(contentView)
    }
    
    public func replaceContentView(_ newView: UIView, animated : Bool = false) {
        let oldView = contentView;
        
        contentView = newView;
        insertSubview(contentView, at: 0)
        
        if (animated) {
            animator.transition(from: oldView, to: contentView, by: self) { (position) in
                oldView.removeFromSuperview()
            }
            
        } else {
            contentView.frame = bounds
            oldView.removeFromSuperview()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = frameForContent()
    }
}

extension SSRootView: SSViewTransitionContaining {
    public func frameForContent() -> CGRect {
        return bounds
    }
}
#endif

