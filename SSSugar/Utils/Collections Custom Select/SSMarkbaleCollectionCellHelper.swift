import UIKit

/// Class that incapsulate cell marking logic. It creates mark view, add it to cell subviews. Can animate mark view.
/// Create it just inside Cell init and pass cell and it's contentview as arguments
/// - Warning: Dont forget call `onLayoutSubviews()`

public class SSMarkbaleCollectionCellHelper {
    //MARK: - constants
    private static let kDefaultMarkViewPadding: CGFloat = 16
    private static let kDefaultAnimatioDuration: TimeInterval = 0.25
    
    //MARK: - private properies
    
    private unowned let cell: UIView
    private unowned let contentView: UIView
    private let markView: SSSelectionMarkView
    private var originalContentFrame: CGRect!
    private var pMarking = false
    private var pMarked = false
    
    //MARK: - public properies
    
    /// Animation transition duration
    public var animationDuration = kDefaultAnimatioDuration
    
    /// Padding for markview
    public var markViewPadding = kDefaultMarkViewPadding {
        didSet {
            if (marking) {
                cell.setNeedsLayout()
            }
        }
    }
    
    //MARK - init

    /// Create and return helper.
    ///
    /// - Parameters:
    ///   - cell: Subject cell. Mark view will be added to it.
    ///   - contentView: Content view of subject cell. It wiil be used for creating space for Mark view.
    ///   - markedImage: Image that will be ued for active checkbox
    ///   - emptyImage: Image that will be ued for empty checkbox
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
    
    /// Layout content and mark subviews
    /// Call it in Cell's layoutSubviews just after super.layoutSubviews and before other realisation
    /// - Important: Don't use it elsewere cuz method rely on content view has it's original frame
    /// - Warning: May cause performance issues (for ex. on insert 100 cells). Cuz cell's contentView frame will change twice (on cell super.layoutSibiews and inside this method). To avoid this problem override contentView getter and return fakeContentView when super.layoutSubviews. Then using fakeContentView frame apply this method. And based on final frame set cell's contentView frame only once.
    ///
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
    /// Marked state of cell
    public var marked   : Bool { get {return self.pMarked}  set {setMarked(newValue, animated: false)} }
    /// Marking state of cell
    public var marking  : Bool { get {return self.pMarking} set {setMarking(newValue, animated: false)} }
    
    /// Switch cell mark. Cell marking has be true, otherwise this method do nothing.
    ///
    /// - Parameters:
    ///   - marked: New state
    ///   - animated: Define transition animated or not
    public func setMarked(_ mMarked: Bool, animated: Bool = false) {
        guard marking && (marked != mMarked) else {
            return
        }
        pMarked = mMarked
        markView.active = marked
    }
    
    /// Switch cell marking/regular state; show/hide marking view.
    ///
    /// - Parameters:
    ///   - marking: New state
    ///   - animated: Define transition animated or not
    public func setMarking(_ mMarking: Bool, animated: Bool = false) {
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

