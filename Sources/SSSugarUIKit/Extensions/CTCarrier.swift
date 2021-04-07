import Foundation
import CoreTelephony

/// Requirement for Carrirer info model
///
/// Usually `CTCarrier` used as `CarrierInfo`. But it couldn't be used dirrectly due to unit tests. That's why this protocol applies instead.
public protocol SSCarrierInfo {
    var name: String? { get }
}

extension CTCarrier: SSCarrierInfo {
    public var name: String? { carrierName }
}

public extension CTCarrier {
    /// Returns set of carriers (if available)
    static func current() -> [CTCarrier]? {
        if #available(iOS 12, *) {
            if let carriers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders {
                return Array(carriers.values)
            }
        } else {
            if let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider {
                return [carrier]
            }
        }
        return nil
    }
}

