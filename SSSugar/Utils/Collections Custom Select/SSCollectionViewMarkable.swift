import Foundation

public protocol SSCollectionViewMarkable {
    func cellForRow(at: IndexPath) -> SSCollectionViewCellMarkable?
    func indexPathsForVisibleRows() -> [IndexPath]
}
