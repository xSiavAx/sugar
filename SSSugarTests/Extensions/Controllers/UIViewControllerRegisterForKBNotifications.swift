/*
 
 Tests for UIViewController extension registerForKBNotifications()
 
 [Done] keyboard notification
    [Done] did show
    [Done] did hide
 [Done] keyboard rect
    [Done] origin
        [Done] x > 0, y > 0
        [Done] x > 0, y < 0
        [Done] x > 0, y == 0
        [Done] x < 0, y > 0
        [Done] x < 0, y < 0
        [Done] x < 0, y == 0
        [Done] x == 0, y > 0
        [Done] x == 0, y < 0
        [Done] x == 0, y == 0
    [Done] size
        [Done] width > 0, height > 0
        [Done] width > 0, height < 0
        [Done] width > 0, height == 0
        [Done] width < 0, height > 0
        [Done] width < 0, height < 0
        [Done] width < 0, height == 0
        [Done] width == 0, height > 0
        [Done] width == 0, height < 0
        [Done] width == 0, height == 0
 [Done] nil user info
 [Done] after remove observer
        
 */

import XCTest
@testable import SSSugar

class UIViewControllerRegisterForKBNotifications: XCTestCase {
    
    let testHelper = UIViewControllerTestHelper()
    let sut = NotifiableViewController()
    
    override func setUp() {
        sut.registerForKBNotifications()
    }
    
    override func tearDown() {
        NotificationCenter.default.removeObserver(sut)
    }
    
    func testDidShowNotification() {
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            NotificationCenter.default.post(name: UIResponder.keyboardDidShowNotification, object: nil, userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidHideNotification() {
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            NotificationCenter.default.post(name: UIResponder.keyboardDidHideNotification, object: nil, userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfo() {
        sut.isNotified = false
        NotificationCenter.default.post(name: UIResponder.keyboardDidShowNotification, object: nil)
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfo() {
        sut.isNotified = false
        NotificationCenter.default.post(name: UIResponder.keyboardDidHideNotification, object: nil)
        XCTAssertTrue(sut.isNotified)
    }
    
    func testDidShowNotificationAfterRemoveObserver() {
        NotificationCenter.default.removeObserver(sut)
        sut.registerForKBNotifications()
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            NotificationCenter.default.post(name: UIResponder.keyboardDidShowNotification, object: nil, userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidHideNotificationAfterRemoveObserver() {
        NotificationCenter.default.removeObserver(sut)
        sut.registerForKBNotifications()
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            NotificationCenter.default.post(name: UIResponder.keyboardDidHideNotification, object: nil, userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfoAfterRemoveObserver() {
        NotificationCenter.default.removeObserver(sut)
        sut.registerForKBNotifications()
        sut.isNotified = false
        NotificationCenter.default.post(name: UIResponder.keyboardDidShowNotification, object: nil)
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfoAfterRemoveObserver() {
        NotificationCenter.default.removeObserver(sut)
        sut.registerForKBNotifications()
        sut.isNotified = false
        NotificationCenter.default.post(name: UIResponder.keyboardDidHideNotification, object: nil)
        XCTAssertTrue(sut.isNotified)
    }
}
