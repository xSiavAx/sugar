import Foundation

/// Errors may occur during communication.
///
/// - Note: See `Comunicating` for additional info.
///
public enum SSCommunicatorError: Error {
    /// No network conection (device is offline)
    case noConnection
    /// Server has unexpected certificates.
    ///
    /// SDK task has been canceled due to unexpected certificates.
    /// See `URLSession(configuration: pinner: delegateQueue: OperationQueue?)`
    case badCertificates
    /// Some error of Underlied Library has occured.
    ///
    /// * `libError` – occured library error.
    case libError(libError: Error?)
    /// Response has unexpected status code.
    ///
    /// * `code` – code value.
    case unexpectedStatus(status: Int)
}
