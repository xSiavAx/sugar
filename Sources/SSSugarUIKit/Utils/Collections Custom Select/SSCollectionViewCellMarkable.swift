import Foundation

/// The type that can store and change its state components like marking and marked
/// Marking indicate is  object ready to change marked or not
public protocol SSCollectionViewCellMarkable {
    var marking : Bool { get set }
    var marked  : Bool { get set }
    
    func setMarking(_ marking : Bool, animated : Bool)
    func setMarked(_ marked : Bool, animated : Bool)
}

/// Extension for `SSCollectionViewCellMarkable` that allow use `` and `setMarked(_,animated:)` with default value `false` for `animtaed`
extension SSCollectionViewCellMarkable {
    /// Method provides default value 'false' for `animated` argument in `setMarking(_,animated:)`
    ///
    /// - Parameter marking: value that will be passed to setMarking(_,animated:)
    func setMarking(_ marking : Bool) {
        setMarking(marking, animated: false)
    }
    
    /// Method provides default value 'false' for `animated` argument in `setMarking(_,animated:)`
    ///
    /// - Parameter marked: value that will be passed to `setMarked(_,animated:)`
    func setMarked(_ marked : Bool) {
        setMarked(marked, animated: false)
    }
}
