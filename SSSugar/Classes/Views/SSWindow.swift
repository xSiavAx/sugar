import UIKit

open class SSWindow: UIWindow {
    //For alpha lower then this trashold protection view will pass interactions
    private static let kMinVisibleProtectionViewAlpha = CGFloat(0.02)
    public static let kBlockUIDelay = 0.2
    
    private var protectionView = SSActivityProtectionView()
    private var blockUITimer : Timer?
    
    var blockingAnimationDuration : TimeInterval
    var blockUIDelay : TimeInterval
    
    //MARK: - init
    
    public init(background: UIColor = .white,
         tint: UIColor = .orange,
         blockingAnimationDuration duration: TimeInterval = defaultBlockingAnimationDuration(),
         blockUIDelay mBlockUIDelay: TimeInterval = kBlockUIDelay) {
        blockingAnimationDuration = duration
        blockUIDelay = mBlockUIDelay
        
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = background
        tintColor = tint
        protectionView.isHidden = true
        protectionView.alpha    = 0.0
        
        addSubview(protectionView)
    }
    
    //MARK: - lifecycle
    open override func layoutSubviews() {
        super.layoutSubviews()
        protectionView.frame = bounds
    }
    
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        if (view !== protectionView) {
            bringSubviewToFront(protectionView)
        }
    }
    
    //MARK: - private
    private func showProtectionView() {
        protectionView.isHidden = false
        protectionView.alpha = SSWindow.kMinVisibleProtectionViewAlpha
    }
    
    private func hideProtectionView() {
        protectionView.isHidden = true
    }
    
    private func makeProtectionViewVisible() {
        protectionView.alpha = 1.0
    }
    
    private func makeProtectionViewInvisible() {
        protectionView.alpha = 0.0
    }
    
    private func makeProtectionViewVisible(animated: Bool) {
        if (animated) {
            UIView.animate(withDuration: blockingAnimationDuration, animations: makeProtectionViewVisible)
        } else {
            makeProtectionViewVisible()
        }
    }
    
    private func makeProtectionViewInvisible(animated: Bool, complition: @escaping ()->Void ) {
        if (animated) {
            UIView.animate(withDuration: blockingAnimationDuration,
                           animations:makeProtectionViewInvisible) { if ($0) { complition() }
            }
        } else {
            makeProtectionViewInvisible()
            complition()
        }
    }
    
    private func invalidateBlockTimer() {
        if let timer = blockUITimer {
            if (timer.isValid) {
                timer.invalidate()
            }
        }
    }
    
    private func recreateBlockTimer(animated: Bool) {
        blockUITimer = Timer.scheduledTimer(withTimeInterval: blockUIDelay, repeats: false, block: {[unowned self] (timer) in
            self.blockUITimer = nil
            self.makeProtectionViewVisible(animated: animated)
        })
    }
    
    //MARK: - SDK Requierments
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SSViewDelayedBlockable
extension SSWindow : SSViewDelayedBlockable {
    public func blockInteraction(animated: Bool, withDelay: Bool) {
        showProtectionView()
        invalidateBlockTimer()
        
        if (withDelay) {
            recreateBlockTimer(animated:animated)
        } else {
            makeProtectionViewVisible(animated: animated)
        }
    }
    
    public func unblockInteraction(animated: Bool) {
        invalidateBlockTimer()
        makeProtectionViewInvisible(animated: animated, complition: hideProtectionView)
    }
}
