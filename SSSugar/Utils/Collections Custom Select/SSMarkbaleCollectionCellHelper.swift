import UIKit

class SSMarkbaleCollectionCellHelper {
    //MARK: - constants
    private static let kDefaultMarkViewPadding: CGFloat = 16
    private static let kDefaultAnimatioDuration: TimeInterval = 0.25
    
    //MARK: - private properies
    private unowned let cell: UIView //Cell
    private unowned let contentView: UIView //cell's content view, will be used to move content on markView appear/disappear
    private let markView: SSSelectionMarkView
    private var originalContentFrame: CGRect!
    
    //MARK: - public properies
    var marking = false
    var marked = false
    var animationDuration = kDefaultAnimatioDuration
    var markViewPadding = kDefaultMarkViewPadding {
        didSet {
            if (marking) {
                cell.setNeedsLayout()
            }
        }
    }
    
    //MARK - iunit
    
    init(cell mCell: UIView, contentView mContentView: UIView, markedImage : UIImage, emptyImage : UIImage) {
        guard mContentView.hasParent(mCell) else {
            fatalError("Cell has contain Content view in it's hierarchy.\nCell is \(mCell), Content view is \(mContentView)")
        }
        cell = mCell
        contentView = mContentView
        markView = SSSelectionMarkView(markedImage: markedImage, emptyImage: emptyImage)
        
        cell.addSubview(markView)
    }
    
    //MARK: - public
    
    /// Call it just after super call, and before subviews realisation
    func onLayoutSubviews() {
        originalContentFrame = contentView.frame;
        updateContentAndMarkFrames()
    }
    
    //MARK: - private
    
    func updateContentAndMarkFrames() {
        if let contentFrame = originalContentFrame {
            let markWidth = marking ? markView.sizeThatFits(contentFrame.size).width + markViewPadding : 0
            let (markFrame, contentFrame) = contentFrame.divided(atDistance: markWidth, from: .minXEdge)
            
            markView.frame = markFrame.cuted(amount: markViewPadding, side: .minXEdge)
            contentView.frame = contentFrame
        }
    }
}

//MARK: - SSCollectionViewCellMarkable
extension SSMarkbaleCollectionCellHelper: SSCollectionViewCellMarkable {
    func setMarked(_ mMarked: Bool, animated: Bool) {
        guard marking && marked != mMarked else {
            return
        }
        marked = mMarked
        markView.active = marked
    }
    
    func setMarking(_ mMarking: Bool, animated: Bool) {
        guard marking != mMarking else {
            return
        }
        marking = mMarking
        
        if (animated) {
            if (!marking) {
                markView.isHidden = true
            }
            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           options: .layoutSubviews,
                           animations: {[weak self] in self?.updateContentAndMarkFrames()},
                           completion: {[weak self] (finished) in
                            if (self?.marking ?? false) {
                                self?.markView.isHidden = false
                            }
            })
        } else {
            markView.isHidden = true
            updateContentAndMarkFrames()
        }
    }
}

