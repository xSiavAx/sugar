import Foundation

struct CGPointTestItems {
    
    let left: CGPoint
    let right: CGPoint
    let expected: CGPoint
    
    init(lX: CGFloat, lY: CGFloat, rX: CGFloat, rY: CGFloat, eX: CGFloat, eY: CGFloat) {
        left = CGPoint(x: lX, y: lY)
        right = CGPoint(x: rX, y: rY)
        expected = CGPoint(x: eX, y: eY)
    }
    
}
