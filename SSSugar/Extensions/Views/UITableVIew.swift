#if !os(macOS)
import UIKit

extension UITableView {
    func fixedIndexPathsForVisibleRows() -> [IndexPath] {
        let paths = indexPathsForVisibleRows ?? []
        return paths.count == visibleCells.count ? paths : visibleCells.compactMap(indexPath(for:));
    }
}
#endif
