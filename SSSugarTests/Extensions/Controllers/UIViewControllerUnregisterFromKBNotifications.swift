/*
 
 Tests for UIViewController extension unregisterForKBNotifications()
 
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
 [Done] after add observer
 
 */

import XCTest
@testable import SSSugar

class UIViewControllerUnregisterFromKBNotifications: XCTestCase {
    
    let testHelper = UIViewControllerTestHelper()
    let sut = NotifiableViewController()
    
    override func setUp() {
        sut.addDidShowNotificationObserver()
        sut.addDidHideNotificationObserver()
        sut.unregisterFromKBNotifications()
    }
    
    override func tearDown() {
        NotificationCenter.default.removeObserver(sut)
    }
    
    func testDidShowNotification() {
        for userInfo in testHelper.makeUserInfos() {
            testHelper.postKeyboardDidShowNotification(userInfo: userInfo)
            XCTAssertFalse(sut.isNotified)
        }
    }
    
    func testDidHideNotification() {
        for userInfo in testHelper.makeUserInfos() {
            testHelper.postKeyboardDidHideNotification(userInfo: userInfo)
            XCTAssertFalse(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfo() {
        testHelper.postKeyboardDidShowNotification()
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfo() {
        testHelper.postKeyboardDidHideNotification()
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidShowNotificationAfterAddObserver() {
        sut.addDidShowNotificationObserver()
        sut.unregisterFromKBNotifications()
        for userInfo in testHelper.makeUserInfos() {
            testHelper.postKeyboardDidShowNotification(userInfo: userInfo)
            XCTAssertFalse(sut.isNotified)
        }
    }
    
    func testDidHideNotificationAfterAddObserver() {
        sut.addDidHideNotificationObserver()
        sut.unregisterFromKBNotifications()
        for userInfo in testHelper.makeUserInfos() {
            testHelper.postKeyboardDidHideNotification(userInfo: userInfo)
            XCTAssertFalse(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfoAfterAddObserver() {
        sut.addDidShowNotificationObserver()
        sut.unregisterFromKBNotifications()
        testHelper.postKeyboardDidShowNotification()
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfoAfterAddObserver() {
        sut.addDidHideNotificationObserver()
        sut.unregisterFromKBNotifications()
        testHelper.postKeyboardDidHideNotification()
        XCTAssertFalse(sut.isNotified)
    }
    
}
