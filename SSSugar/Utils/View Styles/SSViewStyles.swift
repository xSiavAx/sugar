import UIKit

/// Alias for style closure
public typealias SSStyle<T> = (T) -> Void

/// Return Style that is composite of two styles
///
/// New style will do left and righ, one by one on call.
/// Pay attention, if styles alter common properties, right Style will override Left one.
///
/// - Warning:
/// 1. Sum styles only from one inheritance line. Result will be inheritor style not base styel
/// `````
/// let viewStyle = UIView.style{$0.backgroundColor = .white}
/// let labelStyle = UILabel.style{$0.backgroundColor = .white}
/// let buttonStyle = UIButton.style{$0.backgroundColor = .white}
///
/// let totalStyleRight = labelStyle + viewStyle // Will return SSStyle<UILabel>
/// let totalStyleWrong = labelStyle + buttonStyle //Compile time error
/// `````
/// 2. Sum styles from base to more specific, otherwise will get compile error
/// `````
/// let labelStyle1 = UILabel.style{$0.backgroundColor = .white}
/// let labelStyle2 = UILabel.style{$0.backgroundColor = .white}
/// let viewStyle = UIView.style{$0.backgroundColor = .white}

/// let totalStyleRight = viewStyle + labelStyle1 + labelStyle2 //Works
/// let totalStyleWrong = labelStyle1 + labelStyle2 + viewStyle //Compile time error
/// `````
/// - Parameters:
///   - left: Style that will apply first on call
///   - right: Style that will apply second on call
/// - Returns: Composite style
public func +<T>(left: @escaping SSStyle<T>, right: @escaping SSStyle<T>) -> SSStyle<T> {
    return {(styled : T) in
        left(styled)
        right(styled)
    }
}

public protocol Styleable {
}

extension Styleable  {
    public typealias ConcreateStyle = SSStyle<Self>
    
    /// Create style for View
    ///
    /// This method is just for autocoplete. It's much more comfortable then type (by ur hands) something like:
    /// `````
    /// let _ = {(label : UILabel) in
    ///     label.backgroundColor = .white
    /// }
    /// `````
    /// - Warning: Don't use it with `type(of:)`, otherwise type of create Style may conflict with other Style
    /// - Parameter block: Style logic
    /// - Returns: Passed style
    public static func style(_ block: @escaping ConcreateStyle) -> ConcreateStyle {
        return block
    }
    
    /// Apply passed styles, one by one.
    ///
    /// Pay attention, if styles alter common properties, last Style will override previous ones.
    ///
    /// - Parameter styles: Styles to apply
    public func apply(styles: [ConcreateStyle]) {
        for style in styles { apply(style: style) }
    }
    
    /// Apply passed style
    ///
    /// - Parameter styles: Style to apply
    public func apply(style: ConcreateStyle) {
        style(self)
    }
}

extension UIView: Styleable {}
