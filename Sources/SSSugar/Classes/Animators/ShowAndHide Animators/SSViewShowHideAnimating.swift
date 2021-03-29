#if canImport(UIKit)
import UIKit

/// Methods that helps provide show/hide animation
public protocol SSViewShowHideContaining {
    /// Frame that show/hide view should have on animation finish
    func frameForView() -> CGRect
}

/// Set of methods for show and hide view animations.
/// - Warning: See `prepareToShow` method docs.
public protocol SSViewShowHideAnimating {
    /// Method prepare view to `show` animation.
    /// - Parameters:
    ///   - view: View to repare
    ///   - containing: Object containing view
    /// - Warning: This method should be called before every `show(with:animated:complition:)
    func prepareToShow(_ view: UIView, with containing: SSViewShowHideContaining)
    
    /// Show passed view
    /// - Parameters:
    ///   - view: View to show
    ///   - containing: Object containing view
    ///   - animated: Should showing be animated or not
    ///   - complition: Complition handler
    /// - Warning: `prepareToSHow(with:)` should be called before this method call
    func show(_ view: UIView, with containing: SSViewShowHideContaining, animated: Bool, complition:((Bool)->Void)?)
    
    /// Hode passed view
    /// - Parameters:
    ///   - view: View to hide
    ///   - containing: Object containing view
    ///   - animated: Should hidding be animated or not
    ///   - complition: Complition handler
    func hide(_ view: UIView, with containing: SSViewShowHideContaining, animated: Bool, complition:((Bool)->Void)?)
}
#endif
