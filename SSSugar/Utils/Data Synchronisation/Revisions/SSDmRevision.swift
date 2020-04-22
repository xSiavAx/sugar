import Foundation

public class SSDmRevision<Change: SSDataModifying>: SSCopying {
    public let number: Int
    public let changes: [Change]
    public let marker: String?
    
    public init(number mNumber: Int, changes mChanges: [Change], marker mMarker: String? = nil) {
        number = mNumber
        changes = mChanges
        marker = mMarker
    }
    
    public required convenience init(copy other: SSDmRevision<Change>) {
        self.init(number: other.number, changes: other.changes.map { $0.copy() }, marker: other.marker)
    }
}
