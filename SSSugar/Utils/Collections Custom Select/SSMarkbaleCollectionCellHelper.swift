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
    private var pMarking = false
    private var pMarked = false
    
    //MARK: - public properies
    public var animationDuration = kDefaultAnimatioDuration
    public var markViewPadding = kDefaultMarkViewPadding {
        didSet {
            if (marking) {
                cell.setNeedsLayout()
            }
        }
    }
    
    //MARK - iunit
    
    public init(cell mCell: UIView, contentView mContentView: UIView, markedImage : UIImage, emptyImage : UIImage) {
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
    public func onLayoutSubviews() {
        originalContentFrame = contentView.frame;
        updateContentAndMarkFrames()
    }
    
    //MARK: - private
    
    private func updateContentAndMarkFrames() {
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
    public var marked   : Bool { get {return self.pMarked}  set {setMarked(newValue, animated: false)} }
    public var marking  : Bool { get {return self.pMarking} set {setMarking(newValue, animated: false)} }
    
    func setMarked(_ mMarked: Bool, animated: Bool = false) {
        guard marking && marked != mMarked else {
            return
        }
        marked = mMarked
        markView.active = marked
    }
    
    func setMarking(_ mMarking: Bool, animated: Bool = false) {
        guard marking != mMarking else {
            return
        }
        pMarking = mMarking
        
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

