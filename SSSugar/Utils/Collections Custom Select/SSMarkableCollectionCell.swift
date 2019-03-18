import Foundation

public protocol SSMarkableCollectionCell {
    var marking : Bool { get set }
    var marked  : Bool { get set }
    
    func setMarking(_ marking : Bool, animated : Bool)
    func setMarked(_ marked : Bool, animated : Bool)
}

extension SSMarkableCollectionCell {
    func setMarking(_ marking : Bool) {
        setMarking(marking, animated: false)
    }
    
    func setMarked(_ marked : Bool) {
        setMarking(marked, animated: false)
    }
}
