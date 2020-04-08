import Foundation
import CoreGraphics

struct CGSizeTestItems {
    
    let left: CGSize
    let right: CGSize
    let expected: CGSize
    
    var dx: CGFloat { right.width }
    var dy: CGFloat { right.height }
    
    init(lW: CGFloat, lH: CGFloat, rW: CGFloat, rH: CGFloat, eW: CGFloat, eH: CGFloat) {
        left = CGSize(width: lW, height: lH)
        right = CGSize(width: rW, height: rH)
        expected = CGSize(width: eW, height: eH)
    }
    
}
