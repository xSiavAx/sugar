import Foundation

public protocol SSCollectionViewMarkable {
    func cellForRow(at: NSIndexPath) -> SSCollectionViewMarkable
    func indexPathsForVisibleRows() -> [NSIndexPath]
}
