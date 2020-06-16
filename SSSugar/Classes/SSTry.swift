import Foundation

/// Class helper simplifies do/try/catch code to optional error returning.
public class SSTry {
    /// Perform passed job and return error if one has thrown
    /// - Parameter job: Job to perform
    /// - Returns: Error if has thrown during job performing
    public static func run(job: () throws ->Void ) -> Error? {
        return cast(job: job)
    }
    
    /// Perform passed job and return casted error if one has thrown
    /// - Parameter job: Job to perform
    /// - Returns: Casted error if has thrown during job performing
    public static func cast<CError: Error>(job: () throws ->Void ) -> CError? {
        do {
            try job()
            return nil
        } catch {
            return (error as! CError)
        }
    }
}
