//
//  ListomaniaUITests.swift
//  ListomaniaUITests
//
//  Created by Dylan Elliott on 17/12/2022.
//

import XCTest

class ListomaniaUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        addUIInterruptionMonitor(withDescription: "Location Services") { (alert) -> Bool in
            if alert.buttons["Allow"].exists {
                alert.buttons["Allow"].tap()
            }
            return true
        }
        
        app.launch()
    }
    
    func testScreenshots() throws {
        let table = app!
        
        table.waitForExistence(timeout: 5)
        
        snapshot("01-Home")
        
        table.staticTexts["Going Out"].tap()
        snapshot("02-Blueprint Detail")
        
        let back = app.buttons["Lists"]
        
        if back.exists {
            back.tap()
        }
        
        table.staticTexts["Going Out"].swipeLeft()
        app.buttons["Make Manifest"].tap()
        snapshot("03-Home with Manifest")
        
        table.staticTexts["Going Out"].firstMatch.tap()
        snapshot("04-Manifest Detail")
    }
}

extension XCUIElement
{
    enum SwipeDirection {
        case left, right
    }

    func longSwipe(_ direction : SwipeDirection) {
        let startOffset: CGVector
        let endOffset: CGVector

        switch direction {
        case .right:
            startOffset = CGVector.zero
            endOffset = CGVector(dx: 1.0, dy: 0.0)
        case .left:
            startOffset = CGVector(dx: 1.0, dy: 0.0)
            endOffset = CGVector.zero
        }

        let startPoint = self.coordinate(withNormalizedOffset: startOffset)
        let endPoint = self.coordinate(withNormalizedOffset: endOffset)
        startPoint.press(forDuration: 0, thenDragTo: endPoint)
    }
}
