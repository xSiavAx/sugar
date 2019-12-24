import Foundation

#warning("Remove me due new styles")

/// Interface gives view ability to configure it's appearance using some central object calling 'config'.
/// See SSViewConfigReplacable for more info
public protocol SSViewConfigurable: SSViewConfigReplacable {
    /// Store given config
    ///
    /// - Note:
    /// Override this method if you want to store view's 'config'
    /// Note: Usually you may want to store config if you are going to add some subviews or just change apperance sometime in future.
    /// - Parameter config: View's config to store
    func storeConfig(_ config: Any)
    
    /// Configurate self and subviews with given config
    ///
    /// - Note: Override this method for provide custom view and it's subviews configurations with passed config.
    /// Usually there is appearance config – colors, font sizes, paddings etc. All values should be stored in config. Furthermore subviews may be passed to config methods, to incapsulate similar views configuration code.
    /// ````
    /// override configWith(_ config: ConcreateConfig) {
    ///     backgroundColor = config.bgColor
    ///     config.asLogin(textField: loginFieldSubiew)
    ///     config.asLogin(button: forgotPasswordButtonSubview)
    /// }
    /// ````
    /// - Parameter config: Object to config with.
    func configWith(_ config: Any)
}
