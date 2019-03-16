import UIKit

public extension CGRect {
    init(center : CGPoint, size : CGSize) {
        let x = center.x - size.width / 2
        let y = center.y - size.height / 2
        self.init(x:x, y:y, width:size.width, height:size.height)
    }
    
    var center : CGPoint {
        return CGPoint(x:midX, y:midY)
    }
    
    func inset(toX: CGFloat = -1, toY: CGFloat = -1) -> CGRect {
        let dx = toX == -1 ? 0 : (width - toX) / 2;
        let dy = toY == -1 ? 0 : (height - toY) / 2;
        
        return insetBy(dx: dx, dy: dy)
    }
}
