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

extension UIView: SSViewConfigReplacable {
    /// Replace current view config by new one.
    /// Call `setConfig` for storing config and `configWith` to immediately config view. Override these 2 methods if you want store or apply passed config.
    /// - Warning: This method will automatically call 'replaceConfig' for all current subviews, don't do it on your own. Usually there is no reason to override this method at all.
    /// - Complexity: Time O(N), N - total subviews count and Space O(K), K - deepest subview's tree branch
    ///
    /// - Parameter config: Object that may be used for view configuration
    public func replaceConfig(_ config: Any) {
        if let configurable = self as? SSViewConfigurable {
            configurable.storeConfig(config)
            configurable.configWith(config)
        }
        for subview in subviews {
            subview.replaceConfig(config)
        }
    }
}
