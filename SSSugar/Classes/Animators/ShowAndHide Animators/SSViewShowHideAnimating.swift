import Foundation

public protocol SSViewShowHideContaining {
    /// Frame that show/hide view should fill on animation finish
    func frameForView() -> CGRect
}

public protocol SSViewShowHideAnimating {
    func prepareToShow(_ view: UIView, with containing: SSViewShowHideContaining)
    func show(_ view: UIView, with containing: SSViewShowHideContaining, animated: Bool, complition:((Bool)->Void)?)
    func hide(_ view: UIView, with containing: SSViewShowHideContaining, animated: Bool, complition:((Bool)->Void)?)
}
