import UIKit

open class SSRootView: UIView {
    static private let kDefaultTransitionDuration = 0.25;
    private var contentView : UIView
    private let transitionDuration : TimeInterval
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(withContentView contentView: UIView, transitionDuration mTransitionDuration: TimeInterval = kDefaultTransitionDuration) {
        self.contentView = contentView
        self.transitionDuration = mTransitionDuration
        super.init(frame: .zero)
        
        addSubview(contentView)
    }
    
    func replaceContentView(_ newView: UIView, animated : Bool = false) {
        let oldView = contentView;
        
        contentView = newView;
        insertSubview(contentView, at: 0)
        
        contentView.frame = bounds
        
        if (animated) {
            hideView(view: contentView)
            UIView.animate(withDuration: self.transitionDuration,
                           animations: {
                            [unowned self] in
                            self.showView(view: self.contentView)
                            self.hideView(view: oldView)
            },
                           completion: { (finished) in
                            oldView.removeFromSuperview()
            })
            
            
        } else {
            oldView.removeFromSuperview()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
    
    private func hideView(view : UIView) {
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.alpha = 0
    }
    
    private func showView(view : UIView) {
        view.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.alpha = 1
    }
}
