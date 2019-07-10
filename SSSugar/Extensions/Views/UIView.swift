import UIKit

public extension UIView {
    var safeFrame: CGRect {
        return bounds.inset(by: safeAreaInsets)
    }
    
    func addSubviews(_ subviews : [UIView]) {
        subviews.forEach { (subview) in
            addSubview(subview)
        }
    }
    
    func hasParent(_ needle: UIView) -> Bool {
        var view = self
        
        while let sView = view.superview {
            if (sView === needle) {
                return true
            }
            view = sView
        }
        return false
    }
}


/// Interface gives view ability to configure it's appearance using some central object calling 'config'.
/// Usually 'config' contains colors/dimensions/font sizes and etc. But fill free to make it as you want.
public protocol UIConfigurableView: UIView {
    /// Replace current view config by new one
    ///
    /// - Parameter config: object that may be used for view configuration
    func replaceConfig(_ config: AnyObject)
    
    /// Store given config
    ///
    /// - Parameter config: object to store
    func setConfig(_ config: AnyObject)
    
    /// Configurate self and subviews with given config
    ///
    /// - Parameter config: object to config with
    func configWith(_ config: AnyObject)
}

extension UIView: UIConfigurableView {
    /// Replace current view config by new one.
    /// Call `setConfig` for storing config and `configWith` to immediately config view. Override these 2 methods if you want store or apply passed config.
    /// - Warning: This method will automatically call 'replaceConfig' for all current subviews, don't do it on your own. Usually there is no reason to override this method at all.
    /// - Complexity: Time O(N), N - total views count and Space O(K), K - deepest subview's tree branch
    ///
    /// - Parameter config: Object that may be used for view configuration
    public func replaceConfig(_ config: AnyObject) {
        for subview in subviews {
            subview.setConfig(config)
        }
        setConfig(config)
        configWith(config)
    }
    
    /// Store given config.
    /// - Note:
    /// Override this method if you want to store view 'config'
    /// Note: Usually you may want to store config if you are going to add some subviews or just change apperance sometime in future.
    /// - Parameter config: View's config to store
    public func setConfig(_ config: AnyObject) {}
    
    /// Configurate self and subviews with given config
    /// - Note: Override this method for make custom view and subviews configurations with passed config.
    /// Usually there is appearance config – colors, font sizes, paddings etc. All values should be stored in config. Furthermore subviews may be passed to config methods, to incapsulate similar views configuration code.
    /// ````
    /// override configWith(_ config: ConcreateConfig) {
    ///     backgroundColor = config.bgColor
    ///     config.asLogin(textField: loginFieldSubiew)
    ///     config.asLogin(button: forgotPasswordButtonSubview)
    /// }
    /// ````
    /// - Parameter config: Object to config with.
    public func configWith(_ config: AnyObject) {}
}
