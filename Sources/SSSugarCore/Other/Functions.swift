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

public func cycledZip<LE, RE>(_ arrayL: [LE], _ arrayR: [RE])
    -> Zip2Sequence<CountingIterator<CycledIterator<[LE]>>,
                    CountingIterator<CycledIterator<[RE]>>> {
    let max = max(arrayL.count, arrayR.count)
    
    return zip(CycledIterator.counting(arrayL, times: max),
               CycledIterator.counting(arrayR, times: max))
}

public func void() -> Void { () }
