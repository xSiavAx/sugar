import UIKit
import Foundation

public extension UIDevice {
    /// Model name id used to convert to readable string. See [repo](https://gist.github.com/adamawolf/3048717).
    static let modelNameID: String = determineModelNameID()

    private static func determineModelNameID() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
