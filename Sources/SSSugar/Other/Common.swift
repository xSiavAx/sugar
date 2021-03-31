import Foundation

public func log(_ str: String, tag: String? = nil, file: String = #file, line : Int = #line, funcName : String = #function) {
    print("\(String(file.split(separator: "/").last!)) #\(line); \(funcName):")
    if let cTag = tag {
        print("[\(cTag)]: \(str)")
    } else {
        print("\(str)")
    }
}

public func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

#if canImport(UIKit)
import UIKit

public func pixelSize() -> CGFloat {
    return 1.0 / UIScreen.main.scale
}

#endif

