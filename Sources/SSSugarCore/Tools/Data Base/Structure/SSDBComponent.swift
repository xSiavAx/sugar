import Foundation

public protocol SSDBComponent: SSDBComponentHelp {
    func createQueries(strictExist: Bool) -> [String]
    func dropQueries(strictExist: Bool) -> [String]
}

public extension SSDBComponent {
    func createQueries() -> [String] {
        return createQueries(strictExist: true)
    }
    
    func dropQueries() -> [String] {
        return dropQueries(strictExist: true)
    }
}

public protocol SSDBStaticComponent: SSDBComponentHelp {
    static func createQueries(strictExist: Bool) -> [String]
    static func dropQueries(strictExist: Bool) -> [String]
}

public extension SSDBStaticComponent {
    static func createQueries() -> [String] {
        return createQueries(strictExist: true)
    }
    
    static func dropQueries() -> [String] {
        return dropQueries(strictExist: true)
    }
}

public protocol SSDBComponentHelp {}

public extension SSDBComponentHelp {
    static func baseCreate(prefixComps: [String]? = nil, component: String, name: String, strictExist: Bool = true) -> String {
        func prefix() -> String {
            if let prefixComps = prefixComps, !prefixComps.isEmpty {
                return " " + prefixComps.joined(separator: " ")
            }
            return ""
        }
        return "create\(prefix()) \(component)\(createComponent(strictExist: strictExist)) `\(name)`"
    }
    
    static func baseDrop(component: String, name: String, strictExist: Bool = true) -> String {
        return "drop \(component)\(dropComponent(strictExist: strictExist)) `\(name)`"
    }
    
    static func createComponent(strictExist: Bool) -> String {
        if (strictExist) {
            return ""
        }
        return " if not exists"
    }
    
    static func dropComponent(strictExist: Bool) -> String {
        if (strictExist) {
            return ""
        }
        return " if exists"
    }
}
