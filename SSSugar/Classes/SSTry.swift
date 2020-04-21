import Foundation

public class SSTry {
    public static func run(job: () throws ->Void ) -> Error? {
        do {
            try job()
            return nil
        } catch {
            return error
        }
    }
    
    public static func cast<CError: Error>(job: () throws ->Void ) -> CError? {
        do {
            try job()
            return nil
        } catch {
            return (error as! CError)
        }
    }
}
