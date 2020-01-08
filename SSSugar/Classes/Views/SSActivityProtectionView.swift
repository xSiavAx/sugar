import UIKit

open class SSActivityProtectionView: UIView {
    private var indicator = UIActivityIndicatorView(style: .whiteLarge)
    open override var isHidden: Bool {
        didSet {
            isHidden ? indicator.stopAnimating() : indicator.startAnimating()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        addSubview(indicator)
    }
    
    //MARK: Lifecycle
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        indicator.color = tintColor
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let indicatorSize = indicator.sizeThatFits(bounds.size)
        indicator.frame = CGRect(center:bounds.center, size:indicatorSize)
    }
}
