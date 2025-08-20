//
//  PillButtonViewModel.swift
//  FluentUI
//
//  Created by Lamine Male on 2025-08-19.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

public final class PillButtonViewModel<Selection: Hashable>: ObservableObject, Identifiable {
    @Published public var isUnread: Bool
    @Published public var leadingImage: Image?
    public let title: String
    public let id = UUID()
    public let selectionValue: Selection

    public init(title: String,
                selectionValue: Selection,
                leadingImage: Image? = nil,
                isUnread: Bool = false) {
        self.title = title
        self.selectionValue = selectionValue
        self.leadingImage = leadingImage
        self.isUnread = isUnread
    }
}
