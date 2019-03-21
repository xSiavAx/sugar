import UIKit

/// Apply this controller inside CollectionViewController (like TableViewController, CollectionViewController or any custom one) to manage custom selectable cells (CollectionCellMarkable).
/// Controller don't do any logic, except working with cells – preparing, config, mark activation, mark/unmark;
/// Use controller instance to work with custom selection instead of standart selction methods (tv.editing, tv.selectRow(at:), etc)

public class SSCollectionViewMarkableController {
    //MARK: - private properties
    
    private unowned var collectionView: UIView & SSCollectionViewMarkable
    
    //MARK: - public properties
    
    public var active: Bool = false
    public weak var delegate : SSCollectionViewMarkableControllerDelegate?
    
    //MARK: - init
    
    public init(collectionView mCollectionView : UIView & SSCollectionViewMarkable) {
        collectionView = mCollectionView
    }
    
    //MARK: - public
    
    /// Configurate cell. You usually have to use it inside collections cellForRow(at:) method before return cell
    ///
    /// - Parameters:
    ///   - cell: cell to be configured
    ///   - marked: current custom selection cell state
    public func configCell(_ cell: SSCollectionViewCellMarkable, marked: Bool) {
        if (active) {
            if (!cell.marking) {
                cell.setMarking(true)
            }
            if (marked != cell.marked) {
                cell.setMarked(marked)
            }
        } else {
            if (cell.marking) {
                cell.setMarking(false)
            }
            if (cell.marked) {
                cell.setMarked(false)
            }
        }
    }
    
    /// Start/finish custom selection. Use it instead of tv.editing
    ///
    /// - Parameters:
    ///   - mActive: Selection state
    ///   - animated: Define transition animated or not
    public func setActive(_ mActive: Bool, animated: Bool = false) {
        guard active != mActive else {
            return
        }
        active = mActive
        if (active) {
            prepareAllCells(animated: animated)
            delegate?.markControllerDidActivate(self)
        } else {
            deactivateAllCells(animated: animated)
            delegate?.markControllerDidDeactivate(self)
        }
    }
    
    /// Select/Deselect rows at passed index paths. Use it instead tv.selectRow(at:)
    ///
    /// - Parameters:
    ///   - marked: Select or deselect state
    ///   - indexPaths: Index paths to process
    ///   - animated: Define transition animated or not
    public func setCellstMarked(_ marked: Bool, at indexPaths: [IndexPath], animated: Bool = false) {
        collectionView.indexPathsForVisibleRows().forEach { [unowned self] (indexPath) in
            if (indexPaths.binarySearch(needle: indexPath){$0.compare($1)} != nil) {
                self.setCellMarked(marked, at: indexPath, animated: animated)
            }
        }
    }
    
    /// Select/Deselect row at passed index path. Use it instead tv.selectRow(at:)
    /// Important! Much more faster then use setCellsMarked(_ marked: at indexPaths: animated:)
    ///
    /// - Parameters:
    ///   - marked: Select or deselect state
    ///   - indexPaths: Index path to process
    ///   - animated: Define transition animated or not
    public func setCellMarked(_ marked: Bool, at indexPath: IndexPath, animated: Bool = false) {
        if let cell = collectionView.cellForRow(at: indexPath) {
            if (cell.marked != marked) {
                cell.setMarked(marked, animated: animated);
            }
        }
    }
    
    /// Select/Deselect all rows. Use it instead tv.selectRow(at:)
    /// Important! Much more faster then use setCellsMarked(_ marked: at indexPaths: animated:)
    ///
    /// - Parameters:
    ///   - marked: Select or deselect state
    ///   - animated: Define transition animated or not
    public func setAllCellsMarked(_ marked: Bool, animated: Bool = false) {
        collectionView.indexPathsForVisibleRows().forEach { [unowned self](indexPath) in
            self.setCellMarked(marked, at: indexPath, animated: animated)
        }
    }
    
    //MARK: - private
    
    private func prepareAllCells(animated:Bool) {
        enumerateVisibleCells { $0.setMarking(true, animated: animated) }
    }
    
    private func deactivateAllCells(animated:Bool) {
        enumerateVisibleCells { (cell) in
            if (cell.marked) {
                cell.setMarked(false, animated: false)
            }
            cell.setMarking(false, animated: animated)
        }
    }
    
    private func enumerateVisibleCells(handler: (SSCollectionViewCellMarkable)->Void ) {
        collectionView.indexPathsForVisibleRows().forEach {[unowned self] (indexPath) in
            if let cell = self.collectionView.cellForRow(at: indexPath) {
                handler(cell)
            }
        }
    }
}

//MARK: - 

public protocol SSCollectionViewMarkableControllerDelegate: AnyObject {
    func markControllerDidActivate(_ controller: SSCollectionViewMarkableController)
    func markControllerDidDeactivate(_ controller: SSCollectionViewMarkableController)
}
