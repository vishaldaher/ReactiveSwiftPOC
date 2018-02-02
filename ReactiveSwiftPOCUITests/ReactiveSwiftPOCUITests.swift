//
//  ReactiveSwiftPOCUITests.swift
//  ReactiveSwiftPOCUITests
//
//  Created by Vishal D Aher on 29/01/18.
//  Copyright © 2018 SpringCT. All rights reserved.
//

import XCTest
@testable import ReactiveSwiftPOC

class ReactiveSwiftPOCUITests: XCTestCase {
    
    var app: XCUIApplication!
    var textOneTextField: XCUIElement!
    var textTwoTextField: XCUIElement!
    var btnSubmit: XCUIElement!
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        app = XCUIApplication()
        app.launch()
        
        textOneTextField = app.textFields["Text one"]
        textTwoTextField = app.textFields["Text two"]
        btnSubmit = app.buttons["Submit"]
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBothTextFiledContainsText() {

        textOneTextField.tap()
        textOneTextField.typeText("A")
        
        textTwoTextField.tap()
        textTwoTextField.typeText("B")
        
        XCTAssertTrue(btnSubmit.isEnabled)
        
        app.buttons["Submit"].tap()
    
    }
    
    func testOneTextFiledContainsText() {
        
        XCTAssertFalse(btnSubmit.isEnabled)
        
        textOneTextField.tap()
        textOneTextField.typeText("A")

        XCTAssertFalse(btnSubmit.isEnabled)
        
        textOneTextField.clearText()
        textTwoTextField.tap()
        textTwoTextField.typeText("B")
        
        XCTAssertFalse(btnSubmit.isEnabled)
    }
    
    func testTextOneLength() {
        textOneTextField.tap()
        textOneTextField.typeText("ABCD")
        textOneTextField.clearText()
        textOneTextField.typeText("AB")
        textOneTextField.clearText()
        textOneTextField.typeText(" ABC")
    }
    
    func testUIElementInteraction() {
        textOneTextField.tap()
        textOneTextField.typeText("AB")
        textTwoTextField.tap()
        textTwoTextField.typeText("WXYZ")
        app.buttons["Submit"].tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            XCTAssertFalse(self.textOneTextField.isEnabled)
            XCTAssertFalse(self.textTwoTextField.isEnabled)
            XCTAssertFalse(self.btnSubmit.isEnabled)
        })
    }
    
    func testButtonTextChangeOnTap() {
        textOneTextField.tap()
        textOneTextField.typeText("AB")
        textTwoTextField.tap()
        textTwoTextField.typeText("WXYZ")
        app.buttons["Submit"].tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            XCTAssertTrue(self.app.buttons["Submit"].title == "Done")
        })
    }
}

//Extenstion to clear text.
extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        
        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        self.typeText(deleteString)
    }
}
