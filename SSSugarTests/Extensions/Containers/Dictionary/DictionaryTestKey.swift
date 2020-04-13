import Foundation

enum DictionaryTestKey: Int {
    case incorrect = -1
    case one = 1
    case two = 2
    case three = 3
    
    static let defaultDictionary: [Self: Int] = [
        .one : Self.one.value,
        .two : Self.two.value,
        .three : Self.three.value
    ]
    
    var value: Int {
        self.rawValue
    }
}
