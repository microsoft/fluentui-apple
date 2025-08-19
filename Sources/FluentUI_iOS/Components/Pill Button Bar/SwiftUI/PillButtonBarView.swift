//
//  PillButtonBar.swift
//  FluentUI
//
//  Created by Lamine Male on 2025-08-18.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

public struct PillButtonBarView<Selection: Hashable>: View {
    /// - Parameters:
    ///   - datas: The pill data models
    ///   - selected: Binding to the selected value (any Hashable)
    ///   - shouldCenterAlign: Optional. If true, center-aligns the HStack
    public init(style: PillButtonStyle = .primary,
                datas: [PillButtonViewModel<Selection>],
                selected: Binding<Selection>,
                shouldCenterAlign: Bool = false) {
        self.style = style
        self.datas = datas
        self._selected = selected
        self.shouldCenterAlign = shouldCenterAlign
    }

    public var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Constants.pillSpacing) {
                    ForEach(datas, id: \.id) { item in
                        pillButton(for: item)
                    }
                }
                .padding(.vertical, Constants.verticalPadding)
                .padding(.horizontal, Constants.horizontalPadding)
            }
            .scrollDisabled(shouldCenterAlign)
            .onAppear {
                assignSelectionIfNeeded()

                DispatchQueue.main.async {
                    scrollToSelectedOnAppear(scrollProxy)
                }
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            scrollViewFrame = geometry.frame(in: .global)
                        }
                }
            )
            .onPreferenceChange(PillFramePreferenceKey<Selection>.self) { value in
                pillFrames = value
            }
            .onChange(of: selected) { newSelection in
                guard let pillFrame = pillFrames[newSelection] else { return }

                let scrollMinX = scrollViewFrame.minX
                let scrollMaxX = scrollViewFrame.maxX

                if pillFrame.maxX > scrollMaxX {
                    withAnimation {
                        scrollProxy.scrollTo(newSelection,
                                             anchor: UnitPoint(
                                                x: Constants.scrollAnchorTrailingX - (Constants.scrollPadding / max(scrollViewFrame.width, 1)),
                                                y: Constants.scrollAnchorY
                                             ))
                    }
                } else if pillFrame.minX < scrollMinX {
                    withAnimation {
                        scrollProxy.scrollTo(newSelection,
                                             anchor: UnitPoint(
                                                x: Constants.scrollPadding / max(scrollViewFrame.width, 1),
                                                y: Constants.scrollAnchorY
                                             ))
                    }
                }
            }
        }
    }

    private func assignSelectionIfNeeded() {
        guard !datas.isEmpty else {
            return
        }

        for data in datas {
            if selected == data.selectionValue {
                return
            }
        }

        selected = datas[0].selectionValue
    }

    private func pillButton(for item: PillButtonViewModel<Selection>) -> some View {
        let value = item.selectionValue

        if item.isUnread, selected == value {
            item.isUnread = false
        }

        return SwiftUI.Button {
            selected = value
        } label: {
            Text(item.title)
        }
        .buttonStyle(PillButtonViewStyle(style: style,
                                         isSelected: selected == value,
                                         isUnread: item.isUnread,
                                         leadingImage: item.leadingImage))
        .background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: PillFramePreferenceKey<Selection>.self,
                                value: [value: geometry.frame(in: .global)])
            }
        )
        .id(value)
    }

    private func scrollToSelectedOnAppear(_ scrollProxy: ScrollViewProxy) {
        guard scrollViewFrame.width > 0 else {
            return
        }

        let anchorX = Constants.scrollPadding / scrollViewFrame.width
        scrollProxy.scrollTo(selected, anchor: UnitPoint(x: anchorX, y: Constants.scrollAnchorY))
    }

    @Binding private var selected: Selection
    @State private var pillFrames: [Selection: CGRect] = [:]
    @State private var scrollViewFrame: CGRect = .zero

    private let style: PillButtonStyle
    private let shouldCenterAlign: Bool
    private var datas: [PillButtonViewModel<Selection>]
}

private struct Constants {
    static let pillSpacing: CGFloat = 8.0
    static let verticalPadding: CGFloat = 10.0
    static let horizontalPadding: CGFloat = 10.0
    static let scrollPadding: CGFloat = 40.0
    static let scrollAnchorY: CGFloat = 0.5
    static let scrollAnchorTrailingX: CGFloat = 1.0
}

private struct PillFramePreferenceKey<T: Hashable>: PreferenceKey {
    static var defaultValue: [T: CGRect] { [:] }

    static func reduce(value: inout [T: CGRect], nextValue: () -> [T: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

public final class PillButtonViewModel<Selection: Hashable>: ObservableObject, Identifiable {
    @Published public var isUnread: Bool
    public let leadingImage: Image?
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
