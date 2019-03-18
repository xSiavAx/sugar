import UIKit

public extension CGSize {
    func union(with size: CGSize) -> CGSize {
        return CGSize(width:max(width, size.width), height:max(height, size.height))
    }
}
