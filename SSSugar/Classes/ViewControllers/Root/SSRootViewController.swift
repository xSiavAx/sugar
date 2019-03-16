import UIKit

open class SSRootViewController: UIViewController {
    private var rootView : SSRootView { return view as! SSRootView }
    private var contentController : UIViewController!
    
    open override var childForStatusBarStyle: UIViewController? {
        return contentController
    }
    
    init(withContentController contentController: UIViewController) {
        self.contentController = contentController
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: public
    
    func replaceContentController(by newController: UIViewController, animated : Bool = false) {
        let oldController = contentController!
        
        contentController = newController
        
        oldController.willMove(toParent: nil)
        addChild(newController)
        rootView.replaceContentView(newController.view, animated: animated)
        oldController.removeFromParent()
        newController.didMove(toParent: self)
    }
    
    //MARK: Controller Life Cycle

    open override func loadView() {
        addChild(self.contentController)
        view = SSRootView(withContentView: contentController.view)
        contentController.didMove(toParent: self)
    }
    
    //MARK: private
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
