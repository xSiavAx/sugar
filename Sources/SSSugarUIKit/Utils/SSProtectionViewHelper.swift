import UIKit

/// Requirements for objects that using Protection Helper
public protocol SSViewProtectingHelped {
    /// Protection Helper property
    var protectionHelper: SSProtectionViewHelping {get}
}

/// Methods provide required data for Protection Helper.
/// - Note: Default implementation provided for UIView – returns bounds as protection view frame and self as protecting view. It fit only if implementing view is protecting view, otherwise inplementation should be provided by user.
public protocol SSProtectionViewHelpingDelegate: AnyObject {
    /// View that should be protected
    var protectingView: UIView {get}
    /// Frame for protection view
    ///
    /// Usually it equals to protecting view bounds
    var frameForProtView: CGRect {get}
}

/// Helper can provide protection view logic
public protocol SSProtectionViewHelping: SSViewDelayedBlocking {
    /// Delegate providing data
    var protectionDelegate: SSProtectionViewHelpingDelegate? {get}
    
    /// Protection state
    var protected: Bool {get}
}

/// Protection Helping implementation.
///
/// Can work with passed protection view and animator or provide default implementations (SSActivityProtectionView and SSActivityProtectionView).
///
/// - Important: This class provides methods that should be called inside coresponding protecting view lifecycle methods.
/// * `onProtectingInit` in init (will add protectionView as subview)
/// * `onAddSubviewToProtecting` in add subview (will bring protection view to front)
/// * `onProtectingLayout` in layout (will layout protection view)
public class SSProtectionViewHelper: SSProtectionViewHelping {
    /// Minimum view's alpha for not hidden state (otherwise system will mark view as hidden)
    ///
    /// Using for prepareAlpha in animator
    private static let minVisibleProtectionViewAlpha = CGFloat(0.02)
    
    public weak private(set) var protectionDelegate: SSProtectionViewHelpingDelegate?
    public var protected: Bool { lockCounter != 0 }
    
    /// View using to protect
    public let protView: UIView
    /// Visual delay wich used in `func blockInteraction(animated:, withDelay:)`
    ///
    /// Interaction protection will apply immidiatly, delay adds only visual effect. It applys for short-time blocking to improove use expirience.
    public let visualDelay: TimeInterval
    /// Animator using for show and hide protection view
    public let animator: SSViewShowHideAnimating
    
    /// Blocks counter. Using to prevent false unblocks.
    private var lockCounter: Int = 0 {
        didSet {
            if (lockCounter == 0 || oldValue == 0) {
                invalidateBlockTimer()
            }
        }
    }
    /// Timer for start delayed animation.
    private var timer: Timer?
    
    /// Creates new helper with provided protection view, visual delay and animator. Protecion view is optional, default value could be used.
    /// - Parameters:
    ///   - protectionView: View using to protect
    ///   - visualDelay: Delay before protection view will appear after `blockInteraction(animated:, withDelay:)` call
    ///   - animator: Animator for show and hide protection view
    ///
    /// Use this constructor if you want to provide your own protection view or animator. Otherwise use convenience initializer.
    public init(protectionView: UIView = SSActivityProtectionView(), visualDelay delay: TimeInterval, animator mAnimator: SSViewShowHideAnimating) {
        protView = protectionView
        visualDelay = delay
        animator = mAnimator
    }
    
    /// Creates new helper providing default values for protection view and animator (SSActivityProtectionView and SSActivityProtectionView) configured with passed color and duration.
    /// - Parameters:
    ///   - protectionColor: Color for Default protection view
    ///   - visualDelay: Delay before protection view will appear after `blockInteraction(animated:, withDelay:)` call
    ///   - duration: Animation duration for default animator
    ///
    /// Use this constructor to avoid creating protection view and animator on your own. To customize helper use designed initializer.
    public convenience init(protectionColor: UIColor, visualDelay: TimeInterval, duration: TimeInterval) {
        let animator = SSViewShowHideByAlphaAnimator(duration: duration, alphaOnPrepare: Self.minVisibleProtectionViewAlpha)
        let protectionView = SSActivityProtectionView()
        
        protectionView.backgroundColor = protectionColor
        
        self.init(protectionView:protectionView, visualDelay: visualDelay, animator: animator)
    }
    
    //MARK: - Public
    /// Assign passed delegate. Config protection view initial state and add it as protecting view subview.
    /// - Parameter delegate: helper's delegate
    /// - Important: Method should be called in prtotecting view init
    public func onProtectingInit(delegate: SSProtectionViewHelpingDelegate) {
        protectionDelegate = delegate
        protView.isHidden = !protected
        protView.alpha    = protected ? 1.0 : 0.0
        
        protectionDelegate?.protectingView.addSubview(protView)
    }
    
    /// Bring protection view to front of protecting view
    /// - Parameter view: adding view
    /// - Important: Method should be called in prtotecting view init
    public func onAddSubviewToProtecting(_ view: UIView) {
        if (view !== protView) {
            protectionDelegate?.protectingView.bringSubviewToFront(protView)
        }
    }
    
    /// Layout protection view
    /// - Important: Method should be called in prtotecting view init
    public func onProtectingLayout() {
        if let frame = protectionDelegate?.frameForProtView {
            protView.frame = frame
        }
    }
    
    //MARK: - private
    
    /// Invalidate current timer if one exist
    private func invalidateBlockTimer() {
        if let timer = timer {
            if (timer.isValid) {
                timer.invalidate()
            }
        }
    }
    
    /// Creates new timer for delayed showing animation start
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
        lockCounter += 1
        if (lockCounter == 1) {
            animator.prepareToShow(protView, with: self)
            if (withDelay) {
                recreateBlockTimer(animated:animated)
            } else {
                animator.show(protView, with: self, animated: animated, complition: nil)
            }
        }
    }
    
    public func unblockInteraction(animated: Bool) {
        lockCounter -= 1
        if (lockCounter == 0) {
            animator.hide(protView, with: self, animated: animated, complition: nil)
        }
    }
}

extension SSProtectionViewHelpingDelegate where Self: UIView {
    public var protectingView: UIView { self }
    public var frameForProtView: CGRect { bounds }
}
