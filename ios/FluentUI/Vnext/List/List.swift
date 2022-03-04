//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// Properties that can be used to customize the appearance of the List Section.
@objc public protocol MSFListSectionConfiguration {
    /// Sets the Section title.
    var title: String? { get set }

    /// Sets a custom background color for the List Section.
    // TODO: Remove backgroundColor so that it will only be controlled by the tokens.
    var backgroundColor: UIColor? { get set }

    /// Configuress divider presence within the Section.
    var hasDividers: Bool { get set }

    /// Configuress the Section's `Header` style.
    var style: MSFHeaderStyle { get set }

    /// The number of Cells in the Section.
    var cellCount: Int { get }

    /// Creates a new Cell and appends it to the array of cells in a Section.
    func createCell() -> MSFListCellConfiguration

    /// Creates a new Cell within the Section at a specific index.
    /// - Parameter index: The zero-based index of the Cell that will be inserted into the Section.
    func createCell(at index: Int) -> MSFListCellConfiguration

    /// Retrieves the configuration object for a specific Cell so its appearance can be customized.
    /// - Parameter index: The zero-based index of the Cell in the Section.
    func getCellConfiguration(at index: Int) -> MSFListCellConfiguration

    /// Remove a Cell from the Section.
    /// - Parameter index: The zero-based index of the Cell that will be removed from the Section.
    func removeCell(at index: Int)
}

/// Properties that can be used to customize the appearance of the List.
@objc public protocol MSFListConfiguration {
    /// The number of Sections in the List.
    var sectionCount: Int { get }

    /// Creates a new Section and appends it to the array of sections in a List.
    func createSection() -> MSFListSectionConfiguration

    /// Creates a new Section within the List at a specific index.
    /// - Parameter index: The zero-based index of the Section that will be inserted into the List.
    func createSection(at index: Int) -> MSFListSectionConfiguration

    /// Retrieves the configuration object for a specific Section so its appearance can be customized.
    /// - Parameter index: The zero-based index of the Section in the List.
    func getSectionConfiguration(at index: Int) -> MSFListSectionConfiguration

    /// Remove a Section from the List.
    /// - Parameter index: The zero-based index of the Section that will be removed from the List.
    func removeSection(at index: Int)
}

public struct FluentList: View {
    public init() {
        self.configuration = MSFListConfigurationImpl()
    }

    public var body: some View {
        let sections = self.updateCellDividers()
        ScrollView {
            VStack(spacing: 0) {
                ForEach(sections, id: \.self) { section in
                    if let sectionTitle = section.title, !sectionTitle.isEmpty {
                        Header(configuration: section)
                    }

                    ForEach(section.cells.indices, id: \.self) { index in
                        let cellConfiguration = section.cells[index]
                        MSFListCellView(configuration: cellConfiguration)
                            .frame(maxWidth: .infinity)
                    }

                    if section.hasDividers {
                        FluentDivider()
                    }
                }
            }
        }
        .animation(.default)
        .environment(\.defaultMinListRowHeight, 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ObservedObject var configuration: MSFListConfigurationImpl

    /// Finds the last cell directly adjacent to the end of a list section. This is used to remove the redundant separator that is
    /// inserted between each cell. Used as a fix until we are able to use the new List Separators in iOS 15.
    private func findLastCell(_ lastCell: MSFListCellConfiguration) -> MSFListCellConfiguration {
        let childrenCellCount = lastCell.childrenCellCount
        if childrenCellCount > 0, lastCell.isExpanded {
            let lastChild = lastCell.getChildCellConfiguration(at: childrenCellCount - 1)
            return findLastCell(lastChild)
        }
        return lastCell
    }

    /// Updates the status of dividers presence within the entire List.
    private func updateCellDividers() -> [MSFListSectionConfigurationImpl] {
        configuration.sections.forEach { section in
            section.cells.forEach { cell in
                cell.hasDivider = section.hasDividers
            }
            if section.hasDividers, let lastCell = section.cells.last {
                findLastCell(lastCell).hasDivider = false
            }
        }
        return configuration.sections
    }
}

/// Properties that make up section content
class MSFListSectionConfigurationImpl: NSObject, ObservableObject, Identifiable, ControlConfiguration, MSFListSectionConfiguration {
    init(style: MSFHeaderStyle = .standard) {
        self.style = style
        super.init()
    }

    @Published var overrideTokens: HeaderTokens?
    @Published private(set) var cells: [MSFListCellConfigurationImpl] = []
    @Published var title: String?
    @Published var backgroundColor: UIColor?
    @Published var hasDividers: Bool = false
    var id = UUID()

    // MARK: - MSFListSectionConfigurationImpl accessors

    var cellCount: Int {
        return cells.count
    }

    var style: MSFHeaderStyle

    func createCell() -> MSFListCellConfiguration {
        return createCell(at: cells.endIndex)
    }

    func createCell(at index: Int) -> MSFListCellConfiguration {
        guard index <= cells.count && index >= 0 else {
            preconditionFailure("Index is out of bounds")
        }
        let cell = MSFListCellConfigurationImpl()
        cells.insert(cell, at: index)
        return cell
    }

    func getCellConfiguration(at index: Int) -> MSFListCellConfiguration {
        guard cells.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        return cells[index]
    }

    func removeCell(at index: Int) {
        guard cells.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        cells.remove(at: index)
    }
}

/// Properties that make up list content
class MSFListConfigurationImpl: NSObject, ObservableObject, MSFListConfiguration {
    @Published private(set) var sections: [MSFListSectionConfigurationImpl] = []

    // MARK: - MSFListConfigurationImpl accessors

    var sectionCount: Int {
        return sections.count
    }

    func createSection() -> MSFListSectionConfiguration {
        return createSection(at: sections.endIndex)
    }

    func createSection(at index: Int) -> MSFListSectionConfiguration {
        guard index <= sections.count && index >= 0 else {
            preconditionFailure("Index is out of bounds")
        }
        let section = MSFListSectionConfigurationImpl()
        sections.insert(section, at: index)
        return section
    }

    func getSectionConfiguration(at index: Int) -> MSFListSectionConfiguration {
        guard sections.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        return sections[index]
    }

    func removeSection(at index: Int) {
        guard sections.indices.contains(index) else {
            preconditionFailure("Index is out of bounds")
        }
        sections.remove(at: index)
    }
}
