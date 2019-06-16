import UIKit

open class SSProgressView : UIView {
    public let progressLayer = CALayer()
    public var progressColor : UIColor = UIColor.orange { didSet { updateProgressLayerColor() } }
    public var progressOpacity : Float { get { return progressLayer.opacity } set { progressLayer.opacity = newValue } }
    public var cornerRadius : CGFloat { get { return layer.cornerRadius } set { setCornerRadius(newValue) } }
    public var paddings : CGFloat = 8.0
    public lazy var label = createLabel()
    open override var frame: CGRect { didSet { updateProgressLayer() } }
    private var progress : CGFloat = 0.0 { didSet { validateProgress() } }
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = .gray
        layer.addSublayer(progressLayer)
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
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        progressColor = tintColor
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return label.sizeThatFits(size).extended(dx: paddings, dy: paddings)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let size = label.sizeThatFits(bounds.size)
        
        label.frame = bounds.inset(toSize: size)
    }
    
    //MARK: - private
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        
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
        progressLayer.frame = bounds.cuted(amount: cutAmount, side: .maxXEdge)
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
