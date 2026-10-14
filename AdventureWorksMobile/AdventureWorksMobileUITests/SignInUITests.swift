//
//  SignInUITests.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/13/26.
//
import XCTest

final class SignInUITests: XCTestCase{
    @MainActor
    func testSignIn() throws {
        guard let userName = ProcessInfo.processInfo.environment["AW_TEST_USERNAME"],
              let passWord = ProcessInfo.processInfo.environment["AW_TEST_PASSWORD"]
        else {
            throw XCTSkip("Missing environment variables")
        }
        let app = XCUIApplication()
        app.launch()
        
        let menu = app.buttons["mainMenuButton"]
        if menu.exists {
            menu.tap()
            
            app.buttons["signOutButton"].tap()
        }
        
        let field = app.textFields["usernamefield"]
        field.tap()
        field.typeText(userName)
        let passwordField = app.secureTextFields["passwordfield"]
        passwordField.tap()
        passwordField.typeText(passWord)
        app.buttons["loginButton"].tap()
        XCTAssertTrue(menu.waitForExistence(timeout: 10))
    }
}


