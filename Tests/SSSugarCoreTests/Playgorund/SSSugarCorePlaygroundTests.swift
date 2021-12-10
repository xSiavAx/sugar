import XCTest
import Foundation
import Accelerate

@testable import SSSugarCore

class SSSugarCorePlaygroundTests: XCTestCase {
    var groupExecutor: SSGroupExecutor!
    
    override func setUp() {
        groupExecutor = SSGroupExecutor()
    }
    
    override func tearDown() {
        groupExecutor = nil
    }
    
    func testMain() {
        let hiddenBG = DispatchQueue.bg
        
        check(hidden: hiddenBG)
    }
    
    private func check(hidden: SSExecutor) {
        wait(count: 5) { exp in
            groupExecutor.finish(executor: SSExecutorMock()) {
                exp.fulfill()
            }
            
            groupExecutor.finish(executor: DispatchQueue.main) {
                exp.fulfill()
            }
            
            groupExecutor.finish(executor: DispatchQueue.bg) {
                exp.fulfill()
            }
            
            groupExecutor.finish(executor: hidden) {
                exp.fulfill()
            }
            
            groupExecutor.finish() {
                exp.fulfill()
            }
        }
    }
}

class SSExecutorMock: SSExecutor {
    func execute(_ work: @escaping () -> Void) {
        DispatchQueue.bg.execute(work)
    }
}
