#if !os(macOS)
import UIKit

open class SSProgressView : UIView {
    public var progressColor : UIColor = UIColor.orange { didSet { updateProgressLayerColor() } }
    public var progressOpacity : Float { get { return progressLayer.opacity } set { progressLayer.opacity = newValue } }
    public var cornerRadius : CGFloat { get { return layer.cornerRadius } set { setCornerRadius(newValue) } }
    public var paddings : CGFloat = 8.0
    public lazy var label = createLabel()
    private (set) var labelDidInit = false
    open override var frame: CGRect { didSet { updateProgressLayer() } }
    private let progressLayer = CALayer()
    private let progressBoundsLayer = CALayer()
    private var progress : CGFloat = 0.0 { didSet { validateProgress() } }
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        layer.addSublayer(progressBoundsLayer)
        progressBoundsLayer.addSublayer(progressLayer)
    }
    
    //MARK: - public
    open func setProgress(_ mProgress : CGFloat, animated: Bool = false, duration: TimeInterval = 0.25) {
        progress = mProgress

        if (animated) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .linear))
        }
        updateProgressLayer()
        if (animated) {
            CATransaction.commit()
        }
    }
    
    //MARK: - override
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if (labelDidInit) {
            return label.nonEmptySizeThatFits(size).extended(dy: paddings)
        }
        return CGSize(width: size.width, height: paddings)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        progressBoundsLayer.frame = bounds
        updateProgressLayer()
        if (labelDidInit) {
            label.frame = bounds
        }
    }
    
    //MARK: - private
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        
        label.textAlignment = .center
        labelDidInit = true
        
        addSubview(label)
        return label
    }
    
    private func validateProgress() {
        guard progress <= 1.0 else {
            fatalError("Progress should be less or equal to 1.0")
        }
    }
    
    private func updateProgressLayer() {
        let cutAmount = (1.0 - progress) * bounds.size.width
        progressLayer.frame = progressBoundsLayer.bounds.cuted(amount: cutAmount, side: .maxXEdge)
    }
    
    private func updateProgressLayerColor() {
        progressLayer.backgroundColor = progressColor.cgColor
    }
    
    private func setCornerRadius(_ radius : CGFloat) {
        layer.cornerRadius = radius
        progressLayer.cornerRadius = radius
    }
    
    //MARK: - SDK requirements
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
