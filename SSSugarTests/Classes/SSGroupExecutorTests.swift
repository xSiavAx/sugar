/*
 
 Tests for SSGroupExecutor class
 
 [done] init
 [done] add
 [done] finish
 [done] finish several
 
 */

import XCTest
@testable import SSSugar

class SSGroupExecutorTests: XCTestCase {
    let sut = SSGroupExecutor()

    func testInit() {
        XCTAssertNotNil(SSGroupExecutor())
    }
    
    func testAdd() {
        XCTAssertEqual(sut.tasks.count, 0)
        for index in 1...100 {
            sut.add(makeTask())
            XCTAssertEqual(sut.tasks.count, index)
        }
    }
    
    func testFinish() {
        var trafficLight = TrafficLight.red
        
        sut.add(makeTask { trafficLight = .green })
        sut.finish { XCTAssertEqual(trafficLight, .green) }
    }
    
    func testFinishSeveral() {
        var trafficLight = TrafficLight.red
        
        sut.add(makeTask())
        sut.add(makeTask { trafficLight = .yellow })
        sut.add(makeTask())
        sut.add(makeTask { trafficLight = .green })
        sut.add(makeTask())
        sut.finish { XCTAssertEqual(trafficLight, .green) }
    }
    
    func makeTask(work: @escaping () -> Void = {}) -> SSGroupExecutor.Task {
        return { handler in
            work()
            handler()
        }
    }
}


// MARK: - Trafic Light

extension SSGroupExecutorTests {
    private enum TrafficLight {
        case red
        case green
        case yellow
    }
}
