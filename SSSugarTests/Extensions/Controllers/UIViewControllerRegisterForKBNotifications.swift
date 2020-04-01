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
        sut.removeObserver()
    }
    
    func testDidShowNotification() {
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            testHelper.postKeyboardDidShowNotification(userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidHideNotification() {
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            testHelper.postKeyboardDidHideNotification(userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfo() {
        testHelper.postKeyboardDidShowNotification()
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfo() {
        testHelper.postKeyboardDidHideNotification()
        XCTAssertTrue(sut.isNotified)
    }
    
    func testDidShowNotificationAfterRemoveObserver() {
        sut.removeObserver()
        sut.registerForKBNotifications()
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            testHelper.postKeyboardDidShowNotification(userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidHideNotificationAfterRemoveObserver() {
        sut.removeObserver()
        sut.registerForKBNotifications()
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            testHelper.postKeyboardDidHideNotification(userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfoAfterRemoveObserver() {
        sut.removeObserver()
        sut.registerForKBNotifications()
        testHelper.postKeyboardDidShowNotification()
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfoAfterRemoveObserver() {
        sut.removeObserver()
        sut.registerForKBNotifications()
        testHelper.postKeyboardDidHideNotification()
        XCTAssertTrue(sut.isNotified)
    }
}
