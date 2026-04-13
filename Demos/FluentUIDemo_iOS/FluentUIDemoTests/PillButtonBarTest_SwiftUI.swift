//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class PillButtonBarTestSwiftUI: BaseTest {
    override var controlName: String { "PillButtonBar" }

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.buttons["Show"].firstMatch.tap()
    }

    func testLaunch() throws {
        XCTAssert(app.navigationBars.element(matching: NSPredicate(format: "identifier CONTAINS %@", "Pill Button Bar (SwiftUI)")).exists)
    }

    func testButtons() throws {
        let pillBarNames = [
            "onBrand bar",
            "Primary bar",
            "Bar with deselection",
            "Leading aligned",
            "Center aligned"
        ]

        for pillBarName in pillBarNames {
            try testButtonsInPillBar(pillBarName: pillBarName)
        }
        try enableAllToggles()
    }

    private func testButtonsInPillBar(pillBarName: String) throws {
        print("\n========== Testing pill bar: \(pillBarName) ==========")

        // Find the main vertical scroll view (element 0) and the pill bar scroll view (should have identifier)
        let mainScrollView = app.scrollViews.element(boundBy: 0)
        XCTAssertTrue(mainScrollView.waitForExistence(timeout: 2), "Main scroll view not found")

        // The PillButtonBarView is implemented as a ScrollView, so query it as such
        let pillBar = app.scrollViews[pillBarName]

        // Scroll down the main view to ensure the pill bar is visible and hittable
        var scrollAttempts = 0
        while (!pillBar.exists || !pillBar.isHittable) && scrollAttempts < 11 {
            mainScrollView.swipeUp()
            scrollAttempts += 1
            usleep(500000)
        }

        XCTAssertTrue(pillBar.waitForExistence(timeout: 5), "Pill bar '\(pillBarName)' not found")
        XCTAssertTrue(pillBar.isHittable, "Pill bar '\(pillBarName)' is not hittable")

        // Get all buttons within the pill bar scroll view
        let buttons = pillBar.buttons.allElementsBoundByIndex

        print("Number of buttons in '\(pillBarName)' = \(buttons.count)")
        XCTAssertFalse(buttons.isEmpty, "No buttons found in pill bar '\(pillBarName)'")

        // Scroll the pill bar to the beginning (right) to ensure the first button is visible
        // Some pill bars may have a non-first button selected, causing the first button to be off-screen
        if buttons.count > 2 {
            var resetAttempts = 0
            while resetAttempts < 5 {
                let firstFrame = buttons[0].frame
                let barFrame = pillBar.frame
                // Stop once the first button's left edge is within the pill bar's visible area
                if firstFrame.width > 0 && firstFrame.minX >= barFrame.minX - 5 {
                    break
                }
                pillBar.swipeRight()
                usleep(200000)
                resetAttempts += 1
            }
            if resetAttempts > 0 {
                usleep(300000)
            }
        }

        // Test each button
        for (index, button) in buttons.enumerated() {
            print("Testing button \(index + 1) of \(buttons.count): '\(button.label)'")
            XCTAssertTrue(button.waitForExistence(timeout: 2), "Button \(index + 1) does not exist")

            // Only scroll if the button is NOT already hittable
            if !button.isHittable {
                print("Button \(index + 1) is not hittable, scrolling into view...")
                var attempts = 0
                let maxAttempts = 8

                while !button.isHittable && attempts < maxAttempts {
                    // Ensure pill bar is hittable
                    if !pillBar.isHittable {
                        print("Pill bar not hittable, scrolling main view...")
                        mainScrollView.swipeUp()
                        usleep(300000)
                    } else if buttons.count > 2 {
                        print("Swiping to reveal button \(index + 1) (attempt \(attempts + 1))...")
                        pillBar.swipeLeft()
                        usleep(300000)
                        attempts += 1
                    }
                }

                XCTAssertTrue(button.isHittable, "Button \(index + 1) '\(button.label)' is not hittable after \(attempts) attempts")
            } else {
                print("Button \(index + 1) is already hittable, tapping directly")
            }

            // Tap the button
            button.tap()

            // Dismiss alert if it appears
            let alertButton = app.buttons["OK"].firstMatch
            if alertButton.waitForExistence(timeout: 1) {
                alertButton.tap()
            }
        }

        print("========== Completed testing pill bar: \(pillBarName) ==========\n")
    }

    private func enableAllToggles() throws {
        let customThemeToggle = app.switches["Toggle custom theme"].switches.firstMatch
        let tokenOverridesToggle = app.switches["Toggle token overrides"].switches.firstMatch
        let disablePillsToggle = app.switches["Disable pills"].switches.firstMatch

        XCTAssertTrue(customThemeToggle.waitForExistence(timeout: 5), "Toggle custom theme not found")
        XCTAssertTrue(tokenOverridesToggle.waitForExistence(timeout: 5), "Toggle token overrides not found")
        XCTAssertTrue(disablePillsToggle.waitForExistence(timeout: 5), "Disable pills toggle not found")

        if customThemeToggle.value as? String == "0" {
            customThemeToggle.tap()
        }
        if tokenOverridesToggle.value as? String == "0" {
            tokenOverridesToggle.tap()
        }
        if disablePillsToggle.value as? String == "0" {
            disablePillsToggle.tap()
        }

        XCTAssertEqual(customThemeToggle.value as? String, "1", "Custom theme toggle should be on")
        XCTAssertEqual(tokenOverridesToggle.value as? String, "1", "Token overrides toggle should be on")
        XCTAssertEqual(disablePillsToggle.value as? String, "1", "Disable pills toggle should be on")
    }
}
