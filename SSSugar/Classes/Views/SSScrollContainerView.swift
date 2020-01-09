import UIKit

@available(iOS 13, *)
open class SSScrollContainerView: UIView, SSViewBlocking {
    let scrollView      = UIScrollView()
    var blockingAnimationDuration : TimeInterval
    let protectionView  = SSActivityProtectionView()
    
    private var mContentView : UIView?

    open var contentView : UIView {
        if (mContentView == nil) {
            mContentView = loadContentView()
        }
        return mContentView!
    }
    
    //MARK: - init
    public init(blockingAnimationDuration duration: TimeInterval = defaultBlockingAnimationDuration) {
        blockingAnimationDuration = duration
        
        super.init(frame: .zero)
        
        scrollView.addSubview(contentView)
        
        addSubview(scrollView)
        addSubview(protectionView)
        
        scrollView.contentInsetAdjustmentBehavior = .always
        unblockInteraction(animated: false)
    }
    
    //MARK: - lifecycle
    open override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame        = bounds
        protectionView.frame    = bounds
        placeContentView()
    }
    
    open override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        //TODO: Check async is necessary
        DispatchQueue.main.async {
            [unowned self] in
            self.placeContentView()
        }
    }

    //MARK: - override
    open func loadContentView() -> UIView {
        return UIView()
    }
    
    //MARK: - private
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SSViewBlockable
    func placeContentView() {
        var newContentSize = contentView.sizeThatFits(safeFrame.size);
        
        newContentSize.height = max(newContentSize.height, safeFrame.height)
        
        if (newContentSize != scrollView.contentSize) {
            contentView.frame       = CGRect(origin: .zero, size: newContentSize)
            scrollView.contentSize  = newContentSize
        }
    }
    
    open func blockInteraction(animated: Bool) {
        protectionView.isHidden = false
        
        if (animated) {
            UIView.animate(withDuration: blockingAnimationDuration) {
                [unowned self] in
                self.protectionView.alpha = 1.0
            }
        } else {
            protectionView.alpha = 1.0
        }
    }
    
    open func unblockInteraction(animated: Bool) {
        if (animated) {
            let animation = {[unowned self] in
                self.protectionView.alpha = 0.0
            }
            
            UIView.animate(withDuration: blockingAnimationDuration, animations: animation) {[unowned self](finished) in
                self.protectionView.isHidden = true
            }
        } else {
            protectionView.alpha = 0.0
            protectionView.isHidden = true
        }
    }
}

