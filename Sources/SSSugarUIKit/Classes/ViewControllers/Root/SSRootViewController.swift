import UIKit

open class SSRootViewController: UIViewController {
    public enum TransitionType {
        struct Animators {
            let scaleAndAlpha = SSScaleAndAlphaTransitionAnimator()
            let alpha = SSScaleAndAlphaTransitionAnimator(minScale: 1.0)
        }
        
        /// Transition with changing view's scale and alpha
        case scaleAndAlpha
        /// Transition with changing only view's alpha
        case alpha
        
        static let regular = scaleAndAlpha
        private static let animators = Animators()
        
        var animator: SSViewTransitionAnimating {
            switch self {
            case .scaleAndAlpha:
                return Self.animators.scaleAndAlpha
            case .alpha:
                return Self.animators.alpha
            }
        }
    }
    private var rootView : SSRootView { return view as! SSRootView }
    private var contentController : UIViewController!
    
    open override var childForStatusBarStyle: UIViewController? {
        return contentController
    }
    
    public init(withContentController mContentController: UIViewController) {
        contentController = mContentController
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - public
    public func replaceContentController(by newController: UIViewController, animated: Bool = false) {
        replaceContentController(by: newController) {
            rootView.replaceContentView(newController.view, animated: animated)
        }
    }
    
    public func replaceContentController(by newController: UIViewController, animator: SSViewTransitionAnimating) {
        replaceContentController(by: newController) {
            rootView.replaceContentView(newController.view, animator: animator)
        }
    }
    
    public func replaceContentController(by newController: UIViewController, transitionType: TransitionType) {
        replaceContentController(by: newController, animator: transitionType.animator)
    }
    
    //MARK: - Controller Life Cycle
    open override func loadView() {
        addChild(contentController)
        view = SSRootView(withContentView: contentController.view, animator: TransitionType.regular.animator)
        contentController.didMove(toParent: self)
    }
    
    //MARK: - private
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func replaceContentController(by newController: UIViewController, onView: () -> Void) {
        let oldController = contentController!
        
        contentController = newController
        
        oldController.willMove(toParent: nil)
        addChild(newController)
        onView()
        oldController.removeFromParent()
        newController.didMove(toParent: self)
    }
}
