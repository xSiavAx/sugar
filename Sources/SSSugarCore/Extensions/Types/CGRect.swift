#if canImport(CoreGraphics)

import Foundation
import CoreGraphics

public extension CGRect {
    /// Returns center of rectangle. Calculated property.
    var center : CGPoint {
        return CGPoint(x:midX, y:midY)
    }
    
    /// Creates rectangle with specified center and size
    ///
    /// - Parameters:
    ///   - center: Point – center for created rectangle
    ///   - size: Size for create rectangle
    init(center : CGPoint, size : CGSize) {
        let x = center.x - size.width / 2
        let y = center.y - size.height / 2
        self.init(x:x, y:y, width:size.width, height:size.height)
    }
    
    /// Returns a rectangle whith specified size and with the same center point as source rectangle.
    ///
    /// If resulting rectangle has negative size, 'nil' will be returned.
    /// - Parameter toSize: Value to use to adjust rectangle's size
    /// - Returns: Resized rectangle
    func inset(toSize: CGSize) -> CGRect {
        return insetBy(dx: (width - toSize.width) / 2, dy: (height - toSize.height) / 2)
    }
    
    
    /// Returns a rectangle whith specified height and/or width and with the same center point as source rectangle.
    ///
    /// If resulting rectangle has negative size, 'nil' will be returned.
    /// - Important: One of parametes has been passed (as not default)
    /// - Parameters:
    ///   - toWidth: Value to use to adjust rectangle's width. Default value is equal to current `width`.
    ///   - toHeight: Value to use to adjust rectangle's height. Default value is equal to current `height`.
    /// - Returns: Resized rectangle
    func inset(toWidth: CGFloat = -1, toHeight: CGFloat = -1) -> CGRect {
        guard toWidth != -1 || toHeight != -1 else {
            fatalError("Invalid usage. Both parameters can't be default same time")
        }
        let toSize = CGSize(width:toWidth == -1 ? width : toWidth,
                            height:toHeight == -1 ? height : toHeight)
        return inset(toSize:toSize)
    }
    
    /// Returns a rectangle whith side cutted by specified amount.
    ///
    /// - Parameters:
    ///   - amount: Value to cut.
    ///   - side: Side to cut from.
    /// - Returns: Cutted rectangle.
    func cuted(amount: CGFloat, side: CGRectEdge) -> CGRect {
        var rect = self
        
        rect.cut(amount: amount, side: side)

        return rect
    }
    
    /// Return rectangles by dividing rect on spicified parts.
    ///
    /// - Parameters:
    ///   - count: number of parts
    ///   - vertically: divide direction
    func divided(count: Int, vertically: Bool) -> [CGRect] {
        guard count > 0 else { fatalError("Invali param") }
        let fCount = CGFloat(count)
        
        if (vertically) {
            let partHeight = height / fCount
            
            return (0..<count).map { return CGRect(x: minX, y: minY + CGFloat($0)*partHeight, width: width, height: partHeight) }
        }
        let partWidth = width / fCount
        
        return (0..<count).map { return CGRect(x: minX + CGFloat($0)*partWidth, y: minY, width: partWidth, height: height) }
    }
    
    /// Cut side by specified amount.
    ///
    /// - Parameters:
    ///   - amount: Value to cut.
    ///   - side: Side to cut from.
    /// - Returns: Cutted rectangle.
    mutating func cut(amount: CGFloat, side: CGRectEdge) {
        switch side {
        case .maxXEdge:
            size.width -= amount
        case .minXEdge:
            origin.x += amount
            size.width -= amount
        case .maxYEdge:
            size.height -= amount
        case .minYEdge:
            origin.y += amount
            size.height -= amount
        }
    }
    
    //MARK: - deprecated
    /// - Warning: **Deprecated**. Use `inset(toWidth:toHeight:)` instead.
    @available(*, deprecated, message: "Use inset(toWidth:toHeight:) instead")
    func inset(toX: CGFloat = -1, toY: CGFloat = -1) -> CGRect {
        let dx = toX == -1 ? 0 : (width - toX) / 2;
        let dy = toY == -1 ? 0 : (height - toY) / 2;
        
        return insetBy(dx: dx, dy: dy)
    }
}

#endif
