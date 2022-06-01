import Foundation

public extension OptionSet where Self.RawValue == Int, Element == Self {
   func makeIterator() -> OptionSetIterator<Self> {
      return OptionSetIterator(set: self)
   }
}
