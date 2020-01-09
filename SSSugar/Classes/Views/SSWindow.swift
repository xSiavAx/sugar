import UIKit

open class SSWindow: UIWindow, SSViewDelayedBlocking, SSProtectionViewHelpingDelegate {
    public static let kBlockUIDelay = 0.2
    public let helper: SSProtectionViewHelper
    
    //MARK: - init
    
    public init(background: UIColor = .clear,
                tint: UIColor = .orange,
                protectionColor: UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.7),
                blockingAnimationDuration: TimeInterval = defaultBlockingAnimationDuration,
                blockUIDelay: TimeInterval = kBlockUIDelay) {
        helper = SSProtectionViewHelper(protectionColor: protectionColor, visualDelay: blockUIDelay, duration: blockingAnimationDuration)
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = background
        tintColor = tint
        helper.onProtectingInit(delegate: self)
    }
    
    //MARK: - lifecycle
    open override func layoutSubviews() {
        super.layoutSubviews()
        helper.onProtectingLayout()
    }
    
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        helper.onAddSubviewToProtecting(view)
    }
    
    //MARK: - SDK Requierments
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SSWindow: SSViewProtectingHelped {
    public var protectionHelper: SSProtectionViewHelping { helper }
}
