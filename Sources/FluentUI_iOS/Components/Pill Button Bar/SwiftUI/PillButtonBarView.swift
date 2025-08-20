//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

/// `PillButtonBarView` is a horizontal scrollable list of pill shape text buttons.
/// The bar can either have 1 selected pill at all times or allow no selected pills.
public struct PillButtonBarView<Selection: Hashable>: View {
    /// Initializes a new `PillButtonBarView` that allows a the bar to have no selected pill buttons.
    ///
    /// Use this initializer only if you want to allow the pill button bar to have no selected pills. In other words
    /// selecting an already selected pill will deselect it.
    /// - Parameters:
    ///   - style: The style of the pill buttons.
    ///   - viewModels: The view model objects representing the pill buttons data.
    ///   - selected: Optional generic selection binding for the pill bar.
    ///   - centerAlignIfContentFits: If true, centrally aligns the bar if it fits the container.
    ///   - tokenOverrides: The token overrides for the pill buttons.
    public init(style: PillButtonStyle = .primary,
                viewModels: [PillButtonViewModel<Selection>],
                selected: Binding<Selection?>,
                centerAlignIfContentFits: Bool = false,
                tokenOverrides: [PillButtonToken: ControlTokenValue]? = nil) {
        self.style = style
        self.viewModels = viewModels
        self._selected = selected
        self.centerAlignIfContentFits = centerAlignIfContentFits
        self.supportsPillDeselection = true
        self.tokenOverrides = tokenOverrides
    }

    /// Initializes a new `PillButtonBarView` that restricts the bar to 1 selected pill button at all times.
    ///
    /// Use this initializer only if you want to allow the pill button bar to have no selected pills. In other words
    /// selecting an already selected pill will deselect it.
    /// - Parameters:
    ///   - style: The style of the pill buttons.
    ///   - viewModels: The view model objects representing the pill buttons data.
    ///   - selected: The generic selection binding for the pill bar.
    ///   - centerAlignIfContentFits: If true, centrally aligns the bar if it fits the container.
    ///   - tokenOverrides: The token overrides for the pill buttons.
    public init(style: PillButtonStyle = .primary,
                viewModels: [PillButtonViewModel<Selection>],
                selected: Binding<Selection>,
                centerAlignIfContentFits: Bool = false,
                tokenOverrides: [PillButtonToken: ControlTokenValue]? = nil) {
        self.style = style
        self.viewModels = viewModels
        self.centerAlignIfContentFits = centerAlignIfContentFits
        self.supportsPillDeselection = false
        self.tokenOverrides = tokenOverrides
        self._selected = Binding<Selection?>(
            get: { selected.wrappedValue },
            set: { newValue in
                if let value = newValue {
                    selected.wrappedValue = value
                }
            }
        )
    }

    public var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                pillButtonStack()
                    .environment(\.isEnabled, isEnabled)
            }
            .environment(\.isEnabled, true)
            .scrollDisabled(disableScroll)
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ContainerWidthKey.self, value: geometry.size.width)
                        .onAppear {
                            scrollViewFrame = geometry.frame(in: .global)
                        }
                        .onChange_iOS17(of: geometry.size) { _ in
                            scrollViewFrame = geometry.frame(in: .global)
                        }
                }
            }
            .onPreferenceChange(ContentWidthKey.self) {
                contentWidth = $0
            }
            .onPreferenceChange(ContainerWidthKey.self) {
                containerWidth = $0
            }
            .onPreferenceChange(PillFrameKey<Selection>.self) { value in
                pillFrames = value
            }
            .onAppear {
                DispatchQueue.main.async {
                    scrollToSelectedPill(scrollProxy)
                }
            }
            .onChange_iOS17(of: selected) { _ in
                guard !disableScroll,
                      let selected = currentSelection.wrappedValue,
                      let pillFrame = pillFrames[selected] else {
                    return
                }

                let scrollMinX = scrollViewFrame.minX
                let scrollMaxX = scrollViewFrame.maxX

                if pillFrame.maxX > scrollMaxX {
                    withAnimation {
                        scrollProxy.scrollTo(selected,
                                             anchor: UnitPoint(x: Constants.scrollAnchorTrailingX - (Constants.scrollPadding / max(scrollViewFrame.width, Constants.scrollAnchorTrailingX)),
                                                               y: Constants.scrollAnchorY))
                    }
                } else if pillFrame.minX < scrollMinX {
                    withAnimation {
                        scrollProxy.scrollTo(selected,
                                             anchor: UnitPoint(x: Constants.scrollPadding / max(scrollViewFrame.width, Constants.scrollAnchorTrailingX),
                                                               y: Constants.scrollAnchorY))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func pillButtonStack() -> some View {
        HStack(spacing: Constants.pillSpacing) {
            ForEach(viewModels, id: \.id) { item in
                pillButton(for: item)
            }
        }
        .background {
            GeometryReader { geometry in
                Color.clear.preference(key: ContentWidthKey.self, value: geometry.size.width)
            }
        }
        .padding(.vertical, Constants.verticalPadding)
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(minWidth: disableScroll ? max(0, containerWidth - Constants.horizontalPadding * 2) : 0,
               alignment: shouldCenterAlign ? .center : .leading)
    }

    private func pillButton(for item: PillButtonViewModel<Selection>) -> some View {
        let value = item.selectionValue
        let title = item.title
        let isSelected = currentSelection.wrappedValue == value
        let ignoreTap = !supportsPillDeselection && isSelected

        if item.isUnread, isSelected {
            item.isUnread = false
        }

        return SwiftUI.Button {
            if supportsPillDeselection {
                if isSelected {
                    currentSelection.wrappedValue = nil
                } else {
                    currentSelection.wrappedValue = value
                }
            } else if !isSelected {
                currentSelection.wrappedValue = value
            }
        } label: {
            Text(item.title)
        }
        .buttonStyle(pillButtonStyle(isSelected: isSelected,
                                     isUnread: item.isUnread,
                                     leadingImage: item.leadingImage))
        .background {
            GeometryReader { geometry in
                Color.clear
                    .preference(key: PillFrameKey<Selection>.self,
                                value: [value: geometry.frame(in: .global)])
            }
        }
        .allowsHitTesting(!ignoreTap && isEnabled)
        .id(value)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel(item.isUnread ? String(format: "Accessibility.TabBarItemView.UnreadFormat".localized, title) : title)
        .showsLargeContentViewer(text: title)
    }

    private func pillButtonStyle(isSelected: Bool, isUnread: Bool, leadingImage: Image?) -> FluentPillButtonStyle {
        var pillButtonStyle = FluentPillButtonStyle(style: style,
                                                    isSelected: isSelected,
                                                    isUnread: isUnread,
                                                    leadingImage: leadingImage)

        if let tokenOverrides {
            pillButtonStyle.overrideTokens(tokenOverrides)
        }

        return pillButtonStyle
    }

    private func scrollToSelectedPill(_ scrollProxy: ScrollViewProxy) {
        guard scrollViewFrame.width > 0,
              let selected = currentSelection.wrappedValue else {
            return
        }

        let anchorX = Constants.scrollPadding / scrollViewFrame.width
        scrollProxy.scrollTo(selected, anchor: UnitPoint(x: anchorX, y: Constants.scrollAnchorY))
    }

    private var currentSelection: Binding<Selection?> {
        Binding<Selection?>(
            get: {
                if let selected, viewModels.contains(where: { $0.selectionValue == selected }) {
                    return selected
                }
                return supportsPillDeselection ? nil : viewModels.first?.selectionValue
            },
            set: { newValue in
                if supportsPillDeselection {
                    selected = newValue
                } else {
                    selected = newValue ?? viewModels.first?.selectionValue
                }
            }
        )
    }

    @Environment(\.isEnabled) private var isEnabled
    @Binding private var selected: Selection?
    @State private var pillFrames: [Selection: CGRect] = [:]
    @State private var scrollViewFrame: CGRect = .zero
    @State private var contentWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0

    private let style: PillButtonStyle
    private let centerAlignIfContentFits: Bool
    private let supportsPillDeselection: Bool
    private let tokenOverrides: [PillButtonToken: ControlTokenValue]?
    private let viewModels: [PillButtonViewModel<Selection>]

    private var fitsScreen: Bool { contentWidth + Constants.horizontalPadding * 2 <= containerWidth}
    private var shouldCenterAlign: Bool { centerAlignIfContentFits && fitsScreen }
    private var disableScroll: Bool { fitsScreen }
}

private struct ContentWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct ContainerWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct PillFrameKey<T: Hashable>: PreferenceKey {
    static var defaultValue: [T: CGRect] { [:] }
    static func reduce(value: inout [T: CGRect], nextValue: () -> [T: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

private struct Constants {
    static let pillSpacing: CGFloat = 8.0
    static let verticalPadding: CGFloat = 10.0
    static let horizontalPadding: CGFloat = 10.0
    static let scrollPadding: CGFloat = 40.0
    static let scrollAnchorY: CGFloat = 0.5
    static let scrollAnchorTrailingX: CGFloat = 1.0
}
