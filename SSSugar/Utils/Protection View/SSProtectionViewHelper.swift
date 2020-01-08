import Foundation

public protocol SSViewProtectingHelped {
    var protectionHelper: SSProtectionViewHelping {get}
}

public protocol SSProtectionViewHelpingDelegate: AnyObject {
    var protectingView: UIView {get}
    var frameForProtView: CGRect {get}
}

public protocol SSProtectionViewHelping: SSViewDelayedBlockable {
    var protectionDelegate: SSProtectionViewHelpingDelegate? {get}
}

public class SSProtectionViewHelper: SSProtectionViewHelping {
    //For alpha lower then this trashold protection view will pass interactions
    private static let minVisibleProtectionViewAlpha = CGFloat(0.02)
    
    public weak private(set) var protectionDelegate: SSProtectionViewHelpingDelegate?
    
    public let protView: UIView
    public let visualDelay: TimeInterval
    public let animator: SSViewShowHideAnimating
    
    public private(set) var protected: Bool = false { didSet { invalidateBlockTimer() } }
    
    private var timer: Timer?
    
    public init(protectionView: UIView = SSActivityProtectionView(), visualDelay delay: TimeInterval, animator mAnimator: SSViewShowHideAnimating) {
        protView = protectionView
        visualDelay = delay
        animator = mAnimator
    }
    
    public convenience init(protectionColor: UIColor, visualDelay: TimeInterval, duration: TimeInterval) {
        let animator = SSViewShowHideByAlphaAnimator(duration: duration, alphaOnPrepare: Self.minVisibleProtectionViewAlpha)
        let protectionView = SSActivityProtectionView()
        
        protectionView.backgroundColor = protectionColor
        
        self.init(protectionView:protectionView, visualDelay: visualDelay, animator: animator)
    }
    
    //MARK: - Public
    public func onProtectingInit(delegate: SSProtectionViewHelpingDelegate) {
        protectionDelegate = delegate
        protView.isHidden = !protected
        protView.alpha    = protected ? 1.0 : 0.0
        
        protectionDelegate?.protectingView.addSubview(protView)
    }
    
    public func onAddSubviewToProtecting(_ view: UIView) {
        if (view !== protView) {
            protectionDelegate?.protectingView.bringSubviewToFront(protView)
        }
    }
    
    public func onProtectingLayout() {
        if let frame = protectionDelegate?.frameForProtView {
            protView.frame = frame
        }
    }
    
    //MARK: - private
    
    private func invalidateBlockTimer() {
        if let timer = timer {
            if (timer.isValid) {
                timer.invalidate()
            }
        }
    }
    
    private func recreateBlockTimer(animated: Bool) {
        func onFire(firedTimer: Timer) {
            timer = nil
            if (protected) {
                animator.show(protView, with: self, animated: animated, complition: nil)
            }
        }
        timer = Timer.scheduledTimer(withTimeInterval: visualDelay, repeats: false, block: onFire(firedTimer:))
    }
}

extension SSProtectionViewHelper: SSViewShowHideContaining {
    public func frameForView() -> CGRect {
        return protectionDelegate?.frameForProtView ?? .zero
    }
}

extension SSProtectionViewHelper {
    public func blockInteraction(animated: Bool, withDelay: Bool) {
        if (!protected) {
            protected = true
            
            animator.prepareToShow(protView, with: self)
            if (withDelay) {
                recreateBlockTimer(animated:animated)
            } else {
                animator.show(protView, with: self, animated: animated, complition: nil)
            }
        }
    }
    
    public func unblockInteraction(animated: Bool) {
        if (protected) {
            protected = false
            animator.hide(protView, with: self, animated: animated, complition: nil)
        }
    }
}

extension SSProtectionViewHelpingDelegate where Self: UIView {
    public var protectingView: UIView { self }
    public var frameForProtView: CGRect { bounds }
}
