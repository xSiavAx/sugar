import Foundation

public protocol SSDBComponent: SSDBComponentHelp {
    func createQuery(strictExist: Bool) -> String
    func dropQuery(strictExist: Bool) -> String
}

public extension SSDBComponent {
    func createQuery() -> String {
        return createQuery(strictExist: true)
    }
    
    func dropQuery() -> String {
        return dropQuery(strictExist: true)
    }
}

public protocol SSDBStaticComponent: SSDBComponentHelp {
    static func createQuery(strictExist: Bool) -> String
    static func dropQuery(strictExist: Bool) -> String
}

public extension SSDBStaticComponent {
    static func createQuery() -> String {
        return createQuery(strictExist: true)
    }
    
    static func dropQuery() -> String {
        return dropQuery(strictExist: true)
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
