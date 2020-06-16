import Foundation
import CoreGraphics

//TODO: Add docs

public prefix func -(point: CGPoint) -> CGPoint {
    return CGPoint(x: -point.x, y: -point.y)
}

public func +(lPoint: CGPoint, rPoint: CGPoint) -> CGPoint {
    return CGPoint(x: lPoint.x + rPoint.x, y: lPoint.y + rPoint.y)
}

public func -(lPoint: CGPoint, rPoint: CGPoint) -> CGPoint {
    return lPoint + (-rPoint)
}
