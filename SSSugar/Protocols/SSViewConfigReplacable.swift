import Foundation

/// Interface gives view ability to replace configs for view.
/// Usually 'config' contains appearance info, such as colors/dimensions/font sizes and etc. But fill free to make it as you want.
public protocol SSViewConfigReplacable: UIView {
    /// Replace current view config by new one
    ///
    /// - Parameter config: object that may be used for view configuration
    func replaceConfig(_ config: Any)
}
