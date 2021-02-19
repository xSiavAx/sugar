import Foundation

/// Requierements for updates receiver. Each updates receiver should be able to build reactions for notifications he interested in.
///
/// Reaction can obtain data, cuz reactions usually calls via Data queue. Reactions should collect modifications to apply em letter on `apply()` call.
public protocol SSUpdateReceiver: AnyObject {
    /// Strategies dict. Keys – notifications names, Values - closures that have to call other receiver's methods.
    ///
    /// - Returns: Strategies dict
    func reactions() -> SSUpdate.ReactionMap
    
    /// Apply modifications collected during reaction calls.
    func apply()
}
