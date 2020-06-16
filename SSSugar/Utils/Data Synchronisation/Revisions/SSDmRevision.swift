import Foundation

/// Represents atomic seria of changes with unique number and optional marker of request caused these changes. Implements SSCopying.
///
/// Requires some `SSDataModifying` as change type.
public class SSDmRevision<Change: SSDataModifying>: SSCopying {
    /// Revision number. Erlier revisions should has lower number.
    public let number: Int
    /// Revision's changes seria
    public let changes: [Change]
    /// Optional marker of request caused creating this revision.
    public let marker: String?
    
    /// Creates new Revision with passed args.
    /// - Parameters:
    ///   - number: Revision's number
    ///   - changes: Revision's chnages seria
    ///   - marker: Revision's marker
    public init(number mNumber: Int, changes mChanges: [Change], marker mMarker: String? = nil) {
        number = mNumber
        changes = mChanges
        marker = mMarker
    }
    
    /// Creates new Revision based on passed one.
    /// - Parameter other: Revision to create new one with.
    public required convenience init(copy other: SSDmRevision<Change>) {
        self.init(number: other.number, changes: other.changes.map { $0.copy() }, marker: other.marker)
    }
}
