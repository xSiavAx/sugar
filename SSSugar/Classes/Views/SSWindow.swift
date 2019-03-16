import UIKit

open class SSWindow: UIWindow {
    private var protectionView = SSActivityProtectionView()
    private var blockUITimer : Timer?
    private var protectionViewVisible = false
    
    var blockingAnimationDuration : TimeInterval
    
    private let kBlockUIDelay = 0.2
    
    //MARK: - init
    
    public init(background: UIColor = .white,
         tint: UIColor = .orange,
         blockingAnimationDuration duration: TimeInterval = defaultBlockingAnimationDuration()) {
        blockingAnimationDuration = duration
        
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = background
        tintColor = tint
        protectionView.isHidden = !protectionViewVisible
        protectionView.alpha    = protectionViewVisible ? 1.0 : 0.0
        
        addSubview(protectionView)
    }
    
    //MARK: - lifecycle
    open override func layoutSubviews() {
        super.layoutSubviews()
        protectionView.frame = safeFrame
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
    }
    
    private func hideProtectionView() {
        protectionView.isHidden = true
    }
    
    private func makeProtectionViewVisible(animated: Bool) {
        if (animated) {
            UIView.animate(withDuration: blockingAnimationDuration) {
                [unowned self] in
                self.protectionView.alpha = 1.0
            }
        } else {
            protectionView.alpha = 1.0
        }
    }
    
    private func makeProtectionViewInvisible(animated: Bool, completion: @escaping (Bool) -> Void) {
        if (animated) {
            let animation = {[unowned self] in
                self.protectionView.alpha = 0.0
            }
            
            UIView.animate(withDuration: blockingAnimationDuration,
                           animations:animation,
                           completion: completion)
        } else {
            protectionView.alpha = 0.0
        }
    }
    
    func invalidateBlockTimer() {
        if let timer = blockUITimer {
            if (timer.isValid) {
                timer.invalidate()
            }
        }
    }
    
    func recreateBlockTimer(animated: Bool) {
        blockUITimer = Timer(timeInterval: kBlockUIDelay, repeats: false, block: {[unowned self] (timer) in
            self.blockUITimer = nil
            self.makeProtectionViewVisible(animated: animated)
        })
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SSViewDelayedBlockable
extension SSWindow : SSViewDelayedBlockable {
    public func blockInteraction(animated: Bool, withDelay: Bool) {
        protectionView.isHidden = false
        
        invalidateBlockTimer()
        recreateBlockTimer(animated:animated)
    }
    
    public func unblockInteraction(animated: Bool) {
        invalidateBlockTimer()
        makeProtectionViewInvisible(animated: animated) { [unowned self](finished) in
            if (finished) {
                self.protectionView.isHidden = true
            }
        }
    }
}
