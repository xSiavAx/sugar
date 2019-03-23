import Foundation

public protocol SSCollectionViewCellMarkable {
    var marking : Bool { get set }
    var marked  : Bool { get set }
    
    func setMarking(_ marking : Bool, animated : Bool)
    func setMarked(_ marked : Bool, animated : Bool)
}

extension SSCollectionViewCellMarkable {
    func setMarking(_ marking : Bool) {
        setMarking(marking, animated: false)
    }
    
    func setMarked(_ marked : Bool) {
        setMarked(marked, animated: false)
    }
}
