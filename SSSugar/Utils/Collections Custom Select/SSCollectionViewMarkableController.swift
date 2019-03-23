import UIKit

/// Controller for custom selection realisation on any Collection thats implements `SSCollectionViewMarkable` and whose cells implements `SSCollectionViewCellMarkable`
///
/// Apply this controller inside CollectionViewController (like `UITableViewController`, `CollectionViewController` or any custom one) to manage custom selectable cells (`CollectionCellMarkable`).
/// Controller don't do any logic, except working with cells – preparing, config, mark activation, mark/unmark;
/// Use controller instance to work with custom selection instead of standart selction methods (`tv.editing`, `tv.selectRow(at:)`, etc)
///
/// - Important:
/// Store selected indexes or entites in some model, cuz controller don't allow getting positions for selected rows (like standart tableview do).
///

public class SSCollectionViewMarkableController {
    //MARK: - private properties
    
    private unowned var collectionView: UIView & SSCollectionViewMarkable
    private var pActive = false
    
    //MARK: - public properties
    
    /// State for control selection. Set true to start selection and false for end it.
    public var active: Bool { get {return pActive} set{setActive(newValue, animated:false)} }
    
    /// The object that acts as the delegate of SSCollectionViewMarkableController
    public weak var delegate : SSCollectionViewMarkableControllerDelegate?
    
    //MARK: - init
    
    /// Initializes and returns a controller object having the given view as Markable Collection.
    ///
    /// - Parameter mCollectionView: Markable Collection to control
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
    ///   - animated: Define transition animated or not, default is `false`
    public func setActive(_ mActive: Bool, animated: Bool = false) {
        guard active != mActive else {
            return
        }
        pActive = mActive
        if (active) {
            prepareAllCells(animated: animated)
            delegate?.markControllerDidActivate(self)
        } else {
            deactivateAllCells(animated: animated)
            delegate?.markControllerDidDeactivate(self)
        }
    }
    
    /// Select/Deselect rows at passed index paths. Use it instead `tv.selectRow(at:)`
    ///
    /// - Important:
    /// Use `setCellMarked` or `setAllCellsMarked` instead if possible
    /// - Complexity: O(log(N)*k), N - number of index paths to select, k - number of visible rows
    ///
    /// - Parameters:
    ///   - marked: Select or deselect state
    ///   - indexPaths: Index paths to process
    ///   - animated: Define transition animated or not, default is `false`
    public func setCellsMarked(_ marked: Bool, at indexPaths: [IndexPath], animated: Bool = false) {
        guard active else {
            return
        }
        collectionView.indexPathsForVisibleRows().forEach { [unowned self] (indexPath) in
            if (indexPaths.binarySearch(indexPath){$0.compare($1)} != nil) {
                self.pSetCellMarked(marked, at: indexPath, animated: animated)
            }
        }
    }
    
    /// Select/Deselect row at passed index path. Use it instead `tv.selectRow(at:)`
    /// **Important!** Much more faster then use `setCellsMarked(_ marked: at indexPaths: animated:)`
    ///
    /// - Important:
    /// Much more faster then use setCellsMarked(_ marked: at indexPaths: animated:)
    /// - Complexity: O(1)
    ///
    /// - Parameters:
    ///   - marked: Select or deselect state
    ///   - indexPaths: Index path to process
    ///   - animated: Define transition animated or not, default is `false`
    public func setCellMarked(_ marked: Bool, at indexPath: IndexPath, animated: Bool = false) {
        guard active else {
            return
        }
        self.pSetCellMarked(marked, at: indexPath, animated: animated)
    }
    
    /// Select/Deselect all rows. Use it instead `tv.selectRow(at:)`
    ///
    /// - Important:
    /// Much more faster then use `setCellsMarked(_ marked: at indexPaths: animated:)`
    /// - Complexity: O(k), k - number of visible rows
    /// - Parameters:
    ///   - marked: Select or deselect state
    ///   - animated: Define transition animated or not, default is `false`
    public func setAllCellsMarked(_ marked: Bool, animated: Bool = false) {
        guard active else {
            return
        }
        collectionView.indexPathsForVisibleRows().forEach { [unowned self](indexPath) in
            self.pSetCellMarked(marked, at: indexPath, animated: animated)
        }
    }
    
    //MARK: - private
    
    private func pSetCellMarked(_ marked: Bool, at indexPath: IndexPath, animated: Bool) {
        if let cell = collectionView.cellForRow(at: indexPath) {
            if (cell.marked != marked) {
                cell.setMarked(marked, animated: animated);
            }
        }
    }
    
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
