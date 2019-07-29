import UIKit

open class SSSelectionMarkView: UIView {
    public var active: Bool {
        didSet {
            updateImageViewsVisibility()
        }
    };
    
    private let markedImageView : UIImageView;
    private let emptyImageView : UIImageView;
    
    public init(markedImage: UIImage, emptyImage: UIImage) {
        markedImageView = UIImageView(image: markedImage.withRenderingMode(.alwaysTemplate))
        emptyImageView  = UIImageView(image: emptyImage.withRenderingMode(.alwaysTemplate))
        active = false
        
        super.init(frame: .zero)
        
        updateImageViewsVisibility()
        addSubviews(markedImageView, emptyImageView)
    }
    
    //MARK: - lifecycle
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let (markedSize, emptySize) = self.imageViewSizesThatFits(size)
        return markedSize.united(with: emptySize)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let (markedSize, emptySize) = self.imageViewSizesThatFits(bounds.size)
        
        markedImageView.frame = bounds.inset(toSize:markedSize)
        emptyImageView.frame = bounds.inset(toSize:emptySize)
    }
    
    //MARK: - private
    func imageViewSizesThatFits(_ size: CGSize) -> (CGSize, CGSize) {
        return (markedImageView.sizeThatFits(size), emptyImageView.sizeThatFits(size))
    }
    
    func updateImageViewsVisibility() {
        markedImageView.isHidden = !active
        emptyImageView.isHidden = active
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
