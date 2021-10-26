import XCTest
import Foundation
import Accelerate

@testable import SSSugarCore

class SSSugarCorePlaygroundTests: XCTestCase {
    @SSAtomic(nil)
    var atomic: Data!
    
    @SSMultiReadAtomic(nil)
    var mrAtomic: Data!
    
    override func setUp() {
        let data = Data(Array(size: 100_000_000, buildBlock: { _ in UInt8.random(in: (0...255)) }))
        
        _atomic.mutate { $0 = data }
        
        _mrAtomic.mutate { $0 = data }
    }
    
    func testMain() {
        let ratios = (0...100).map { _ in check() }
        print("Avarage increase is \(vDSP.mean(ratios))")
    }
    
    func check() -> Double {
        print("Started")
        let start = Date()
//        check(label: "MR Atomic", mutate: { self._mrAtomic.mutate() { $0 += 1 }  }, access: { self.mrAtomic })
        check(label: "MR Atomic", iteration: { let _ = self.mrAtomic  }, access: { self.mrAtomic })
        let mrAtomicF = Date()
//  check(label: "Atomic", mutate: { self._atomic.mutate() { $0 += 1 }  }, access: { self.atomic })
        check(label: "Atomic", iteration: { let _ = self.atomic  }, access: { self.atomic })
        let atomicF = Date()
        
        let mrDonIn = mrAtomicF.timeIntervalSince(start)
        let aDoneIn = atomicF.timeIntervalSince(mrAtomicF)
        print("MR Atomic done in \(mrDonIn)")
        print("Atomic done in \(aDoneIn)")
        let ratio = aDoneIn / mrDonIn - 1
        print("MR is \(ratio * 100)% faster")
        
        return ratio
    }
    
    func check<T>(label: String, iteration: @escaping () -> Void) {
        wait(timeout: 100.0) { exp in
            let group = SSGroupExecutor()
            
            (0..<1_000_000).forEach() { _ in
                group.add { handler in
                    DispatchQueue.global().execute {
                        iteration()
                        handler()
                    }
                }
            }
            
            group.finish {
                exp.fulfill()
            }
        }
    }
    
    func testSecond() {
    }
}
