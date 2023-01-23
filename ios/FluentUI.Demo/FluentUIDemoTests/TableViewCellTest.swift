//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest

class TableViewCellTest: BaseTest {
    override var controlName: String { "TableViewCell" }

    let title: String = "\"Contoso Survey\""
    let subtitle: String = "\"Research Notes\""
    let footer: String = "\"22 views\""
    let customTitle: String = "\"Format\""
    let longTitle: String = "\"This is a cell with a long text1 as an example of how this label will render\""
    let longSubtitle: String = "\"This is a cell with a long text2 as an example of how this label will render\""
    let longFooter: String = "\"This is a cell with a long text3 as an example of how this label will render\""

    func assertSingleLine() throws {
        XCTAssertEqual(app.cells.element(boundBy: 0).identifier, "Table View Cell with title \(title), with a leading image")
        XCTAssertEqual(app.cells.element(boundBy: 1).identifier, "Table View Cell with title \(title), with a leading image and a chevron")
        XCTAssertEqual(app.cells.element(boundBy: 2).identifier, "Table View Cell with title \(title), with a leading image and a details button")
        XCTAssertEqual(app.cells.element(boundBy: 3).identifier, "Table View Cell with title \(title), with a leading image and a checkmark")
        XCTAssertEqual(app.cells.element(boundBy: 4).identifier, "Table View Cell with title \(title), with a leading image and a title leading image")
    }

    // launch test that ensures the demo app does not crash and is on the correct control page
    func testLaunch() throws {
        XCTAssertTrue(app.navigationBars[controlName].exists)
    }

    func testSingleLine() throws {
        try assertSingleLine()
    }

    func testDoubleLine() throws {
        XCTAssertEqual(app.cells.element(boundBy: 5).identifier, "Table View Cell with title \(title) and subtitle \(subtitle), with a leading unread dot and a leading image")
        XCTAssertEqual(app.cells.element(boundBy: 6).identifier, "Table View Cell with title \(title) and subtitle \(subtitle), with a leading unread dot, a leading image, and a chevron")
        XCTAssertEqual(app.cells.element(boundBy: 7).identifier, "Table View Cell with title \(title) and subtitle \(subtitle), with a leading unread dot, a leading image, and a details button")
        XCTAssertEqual(app.cells.element(boundBy: 8).identifier, "Table View Cell with title \(title) and subtitle \(subtitle), with a leading unread dot, a leading image, and a checkmark")
        XCTAssertEqual(app.cells.element(boundBy: 9).identifier, "Table View Cell with title \(title) and subtitle \(subtitle), with a leading unread dot, a leading image, and a subtitle leading image")
    }

    func testInvertedDoubleLine() throws {
        XCTAssertEqual(app.cells.element(boundBy: 10).identifier, "Table View Cell with title \(title) and subtitle \(subtitle)")
        XCTAssertEqual(app.cells.element(boundBy: 11).identifier, "Table View Cell with title \(title) and subtitle \(subtitle), with a chevron")
        XCTAssertEqual(app.cells.element(boundBy: 12).identifier, "Table View Cell with title \(title) and subtitle \(subtitle), with a details button")
        XCTAssertEqual(app.cells.element(boundBy: 13).identifier, "Table View Cell with title \(title) and subtitle \(subtitle), with a checkmark")
        XCTAssertEqual(app.cells.element(boundBy: 14).identifier, "Table View Cell with title \(title) and subtitle \(subtitle), with a subtitle leading image")
    }

    func testTripleLine() throws {
        XCTAssertEqual(app.cells.element(boundBy: 15).identifier, "Table View Cell with title \(title), subtitle \(subtitle), and footer \(footer), with a leading image")
        XCTAssertEqual(app.cells.element(boundBy: 16).identifier, "Table View Cell with title \(title), subtitle \(subtitle), and footer \(footer), with a leading image and a chevron")
        XCTAssertEqual(app.cells.element(boundBy: 17).identifier, "Table View Cell with title \(title), subtitle \(subtitle), and footer \(footer), with a leading image and a details button")
        XCTAssertEqual(app.cells.element(boundBy: 18).identifier, "Table View Cell with title \(title), subtitle \(subtitle), and footer \(footer), with a leading image and a checkmark")
        XCTAssertEqual(app.cells.element(boundBy: 19).identifier, "Table View Cell with title \(title), subtitle \(subtitle), and footer, with a leading image, a subtitle trailing image, and a footer trailing image")
    }

    func testCustomView() throws {
        XCTAssertEqual(app.cells.element(boundBy: 25).identifier, "Table View Cell with title \(customTitle)")
        XCTAssertEqual(app.cells.element(boundBy: 26).identifier, "Table View Cell with title \(customTitle), with a chevron")
        XCTAssertEqual(app.cells.element(boundBy: 27).identifier, "Table View Cell with title \(customTitle), with a details button")
        XCTAssertEqual(app.cells.element(boundBy: 28).identifier, "Table View Cell with title \(customTitle), with a checkmark")
        XCTAssertEqual(app.cells.element(boundBy: 29).identifier, "Table View Cell with title \(customTitle)")
    }

    func testLongLabels() throws {
        XCTAssertEqual(app.cells.element(boundBy: 30).identifier, "Table View Cell with title \(longTitle), subtitle \(longSubtitle), and footer \(longFooter), with a leading image")
        XCTAssertEqual(app.cells.element(boundBy: 31).identifier, "Table View Cell with title \(longTitle), subtitle \(longSubtitle), and footer \(longFooter), with a leading image and a chevron")
        XCTAssertEqual(app.cells.element(boundBy: 32).identifier, "Table View Cell with title \(longTitle), subtitle \(longSubtitle), and footer \(longFooter), with a leading image and a details button")
        XCTAssertEqual(app.cells.element(boundBy: 33).identifier, "Table View Cell with title \(longTitle), subtitle \(longSubtitle), and footer \(longFooter), with a leading image and a checkmark")
        XCTAssertEqual(app.cells.element(boundBy: 34).identifier, "Table View Cell with title \(longTitle), subtitle \(longSubtitle), and footer \(longFooter), with a leading image, a title trailing image, a subtitle trailing image, and a footer trailing image")
    }

    func testSelection() throws {
        try assertSingleLine()

        app.buttons["Select"].tap()
        for i in 0...4 {
            app.images.element(boundBy: i).tap()
        }
        app.buttons["Done"].tap()

        XCTAssertEqual(app.cells.element(boundBy: 0).identifier, "Table View Cell with title \(title), with a leading unread dot and a leading image")
        XCTAssertEqual(app.cells.element(boundBy: 1).identifier, "Table View Cell with title \(title), with a leading unread dot, a leading image, and a chevron")
        XCTAssertEqual(app.cells.element(boundBy: 2).identifier, "Table View Cell with title \(title), with a leading unread dot, a leading image, and a details button")
        XCTAssertEqual(app.cells.element(boundBy: 3).identifier, "Table View Cell with title \(title), with a leading unread dot, a leading image, and a checkmark")
        XCTAssertEqual(app.cells.element(boundBy: 4).identifier, "Table View Cell with title \(title), with a leading unread dot, a leading image, and a title leading image")

        app.buttons["Select"].tap()
        for i in 0...4 {
            app.images.element(boundBy: i).tap()
        }
        app.buttons["Done"].tap()

        try assertSingleLine()
    }
}
