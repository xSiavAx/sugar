//
//  SSCollectionViewMarkableControllerDeactivateAlreadyDeactiveTC.swift
//  SSCustomSelectionTests
//
//  Created by Stanislav Dmitriyev on 21/3/19.
//  Copyright © 2019 Stanislav Dmitriyev. All rights reserved.
//

import XCTest

class SSCollectionViewMarkableControllerDeactivateAlreadyDeactiveTC: SSCollectionViewMarkableControllerBaseTC {
    func testActivateViaProp() {
        controller.active = false
        check(active: false, cells:expectedCells())
    }
    
    func testActivate() {
        controller.setActive(false)
        check(active: false, cells:expectedCells())
    }
    
    func testActivateAnimated() {
        controller.setActive(false, animated: true)
        check(active: false, cells:expectedCells())
    }
    
    func testActivateExplicitNonAnimated() {
        controller.setActive(false, animated: false)
        check(active: false, cells:expectedCells())
    }
    
    func expectedCells() -> [SSCollectionViewMarkableCellStub] {
        return [SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false),
                SSCollectionViewMarkableCellStub(marking: false, marked: false)]
    }
}
