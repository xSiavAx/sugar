import Foundation

/// Type that can provide cell and path and paths for visible cells
/// Used at least by `SSCollectionViewMarkableController`
public protocol SSCollectionViewMarkable {
    func cellForRow(at: IndexPath) -> SSCollectionViewCellMarkable?
    func indexPathsForVisibleRows() -> [IndexPath]
}
