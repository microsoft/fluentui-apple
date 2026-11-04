//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import FluentUI_ios

@MainActor
class PersonaListViewTests: XCTestCase {
    func testPersonaCellWrapsOnlyAboveLargeTextSize() {
        let cell = PersonaCell(style: .default, reuseIdentifier: nil)
        let persona = PersonaData(name: "First Last", subtitle: "Organization")

        for category in [UIContentSizeCategory.extraSmall, .large, .extraLarge, .accessibilityExtraExtraExtraLarge] {
            cell.traitOverrides.preferredContentSizeCategory = category
            cell.updateTraitsIfNeeded()
            cell.setup(persona: persona)

            let expectedNumberOfLines = category > .large ? 0 : 1
            XCTAssertEqual(cell.traitCollection.preferredContentSizeCategory, category)
            XCTAssertEqual(cell.titleNumberOfLines, expectedNumberOfLines)
            XCTAssertEqual(cell.subtitleNumberOfLines, expectedNumberOfLines)
        }
    }

    func testPersonaCellRestoresWrappingAfterReuse() {
        let cell = PersonaCell(style: .default, reuseIdentifier: nil)
        let persona = PersonaData(name: "First Last", subtitle: "Organization")
        cell.traitOverrides.preferredContentSizeCategory = .accessibilityExtraExtraExtraLarge
        cell.updateTraitsIfNeeded()
        cell.setup(persona: persona)
        cell.prepareForReuse()
        cell.setup(persona: persona)

        XCTAssertEqual(cell.titleNumberOfLines, 0)
        XCTAssertEqual(cell.subtitleNumberOfLines, 0)
    }

    func testPersonaRowHeightMatchesWrappingAndAccessoryWidth() {
        let list = PersonaListView(frame: CGRect(x: 0, y: 0, width: 240, height: 600), style: .plain)
        let persona = PersonaData(name: String(repeating: "Long name ", count: 8),
                                  email: String(repeating: "email", count: 12) + "@example.com",
                                  subtitle: String(repeating: "Organization ", count: 8))
        list.personaList = [persona]
        let indexPath = IndexPath(row: 0, section: 0)

        for category in [UIContentSizeCategory.large, .extraLarge, .accessibilityExtraExtraExtraLarge] {
            list.traitOverrides.preferredContentSizeCategory = category
            list.updateTraitsIfNeeded()
            XCTAssertEqual(list.traitCollection.preferredContentSizeCategory, category)
            for accessory in [TableViewCellAccessoryType.none, .disclosureIndicator, .detailButton] {
                list.accessoryType = accessory
                for name in [String(repeating: "Long name ", count: 8), ""] {
                    persona.name = name
                    let numberOfLines = category > .large ? 0 : 1
                    let expectedHeight = TableViewCell.height(tokenSet: .init(customViewSize: { .medium }),
                                                              title: name.isEmpty ? persona.email : name,
                                                              subtitle: persona.subtitle,
                                                              titleFont: list.fluentTheme.typography(.body1, contentSizeCategory: category),
                                                              subtitleFont: list.fluentTheme.typography(.caption1, contentSizeCategory: category),
                                                              customViewSize: .medium,
                                                              accessoryType: accessory,
                                                              titleNumberOfLines: numberOfLines,
                                                              subtitleNumberOfLines: numberOfLines,
                                                              containerWidth: list.bounds.width)
                    XCTAssertEqual(list.tableView(list, heightForRowAt: indexPath), expectedHeight)
                }
            }
        }
    }

    func testLargeTextRowHeightAdaptsToAvailableWidth() {
        let list = PersonaListView(frame: CGRect(x: 0, y: 0, width: 240, height: 600), style: .plain)
        list.personaList = [PersonaData(name: String(repeating: "Long name ", count: 8),
                                        subtitle: String(repeating: "Organization ", count: 8))]
        let indexPath = IndexPath(row: 0, section: 0)
        list.traitOverrides.preferredContentSizeCategory = .large
        list.updateTraitsIfNeeded()
        let defaultHeight = list.tableView(list, heightForRowAt: indexPath)
        list.traitOverrides.preferredContentSizeCategory = .extraLarge
        list.updateTraitsIfNeeded()
        let narrowHeight = list.tableView(list, heightForRowAt: indexPath)
        list.frame.size.width = 600
        let wideHeight = list.tableView(list, heightForRowAt: indexPath)

        XCTAssertGreaterThan(narrowHeight, defaultHeight)
        XCTAssertGreaterThan(narrowHeight, wideHeight)
    }

    func testContentSizeChangeUpdatesDisplayedRowHeight() throws {
        let list = PersonaListView(frame: CGRect(x: 0, y: 0, width: 240, height: 600), style: .plain)
        list.traitOverrides.preferredContentSizeCategory = .large
        list.updateTraitsIfNeeded()
        list.personaList = [PersonaData(name: String(repeating: "Long name ", count: 8),
                                        subtitle: String(repeating: "Organization ", count: 8))]
        list.layoutIfNeeded()
        let indexPath = IndexPath(row: 0, section: 0)
        let defaultHeight = list.rectForRow(at: indexPath).height

        list.traitOverrides.preferredContentSizeCategory = .extraLarge
        list.updateTraitsIfNeeded()
        NotificationCenter.default.post(name: UIContentSizeCategory.didChangeNotification, object: nil)
        list.layoutIfNeeded()

        XCTAssertGreaterThan(list.rectForRow(at: indexPath).height, defaultHeight)
        XCTAssertEqual(list.rectForRow(at: indexPath).height,
                       list.tableView(list, heightForRowAt: indexPath),
                       accuracy: 1)
        let cell = try XCTUnwrap(list.cellForRow(at: indexPath) as? PersonaCell)
        cell.layoutIfNeeded()
        XCTAssertEqual(cell.titleNumberOfLines, 0)
        XCTAssertEqual(cell.subtitleNumberOfLines, 0)
        XCTAssertGreaterThanOrEqual(cell.bounds.height + 1, cell.sizeThatFits(cell.bounds.size).height,
                                    "Cell width: \(cell.bounds.width), content width: \(cell.contentView.bounds.width), title font: \(cell.titleLabel.font.pointSize), subtitle font: \(cell.subtitleLabel.font.pointSize)")

        list.traitOverrides.preferredContentSizeCategory = .large
        list.updateTraitsIfNeeded()
        NotificationCenter.default.post(name: UIContentSizeCategory.didChangeNotification, object: nil)
        list.layoutIfNeeded()

        XCTAssertEqual(list.rectForRow(at: indexPath).height, defaultHeight)
    }

    func testSearchDirectoryRowsKeepAutomaticSizing() {
        let list = PersonaListView(frame: .zero, style: .plain)
        list.showsSearchDirectoryButton = true
        list.traitOverrides.preferredContentSizeCategory = .accessibilityExtraExtraExtraLarge
        list.updateTraitsIfNeeded()

        for state in [PersonaListView.SearchDirectoryState.idle, .searching, .displayingSearchResults] {
            list.searchDirectoryState = state
            XCTAssertEqual(list.tableView(list, heightForRowAt: IndexPath(row: 0, section: 1)),
                           UITableView.automaticDimension)
        }
    }

    func testPersonaSelectionStillInvokesCallback() {
        let list = PersonaListView(frame: .zero, style: .plain)
        let persona = PersonaData(name: "First Last")
        list.personaList = [persona]
        var selectedPersona: Persona?
        list.onPersonaSelected = { selectedPersona = $0 }

        list.tableView(list, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(selectedPersona === persona)
    }
}
