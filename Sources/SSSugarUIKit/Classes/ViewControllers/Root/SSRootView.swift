import UIKit

open class SSRootView: UIView {
    private var contentView : UIView
    public let animator: SSViewTransitionAnimating
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(withContentView: UIView, animator mAnimator: SSViewTransitionAnimating) {
        contentView = withContentView
        animator = mAnimator
        super.init(frame: .zero)
        
        addSubview(contentView)
    }
    
    public func replaceContentView(_ newView: UIView, animated : Bool = false) {
        replaceContentView(newView, animator: animated ? animator : nil)
    }
    
    public func replaceContentView(_ newView: UIView, animator: SSViewTransitionAnimating?) {
        let oldView = contentView
        
        contentView = newView
        insertSubview(contentView, at: 0)
        
        if let animator = animator {
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
    public func frameForContent() -> CGRect { bounds }
}

