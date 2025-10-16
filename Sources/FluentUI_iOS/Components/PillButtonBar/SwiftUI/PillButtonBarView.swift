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
    /// Initializes a new `PillButtonBarView` that allows the bar to have no selected pill buttons and a maximum of 1 selected pill button.
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
        ScrollView(.horizontal, showsIndicators: false) {
            pillButtonStack()
                .environment(\.isEnabled, isEnabled)
                .scrollTargetLayout()
        }
        .environment(\.isEnabled, true)
        .scrollDisabled(disableScroll)
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .global)
        } action: { newFrame in
            scrollViewFrame = newFrame
            containerWidth = newFrame.width
        }
        .scrollPosition(id: $scrollTargetId, anchor: scrollAnchor)
        .onAppear {
            scrollToSelectedPill()
        }
        .onChange(of: scrollViewFrame.width) {
            scrollToSelectedPill()
        }
        .onChange(of: selected) {
            guard !disableScroll,
                  let selected = currentSelection.wrappedValue,
                  let pillFrame = pillFrames[selected] else {
                return
            }

            let scrollMinX = scrollViewFrame.minX
            let scrollMaxX = scrollViewFrame.maxX

            if pillFrame.maxX > scrollMaxX {
                withAnimation {
                    scrollAnchor = UnitPoint(x: Constants.scrollAnchorTrailingX - (Constants.scrollPadding / max(scrollViewFrame.width, Constants.scrollAnchorTrailingX)),
                                             y: Constants.scrollAnchorY)
                    scrollTargetId = selected
                }
            } else if pillFrame.minX < scrollMinX {
                withAnimation {
                    scrollAnchor = UnitPoint(x: Constants.scrollPadding / max(scrollViewFrame.width, Constants.scrollAnchorTrailingX),
                                             y: Constants.scrollAnchorY)
                    scrollTargetId = selected
                }
            }
        }
    }

    @ViewBuilder
    private func pillButtonStack() -> some View {
        HStack(spacing: Constants.pillSpacing) {
            ForEach(viewModels, id: \.id) { viewModel in
                pillButton(for: viewModel)
            }
        }
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.width
        } action: { newWidth in
            contentWidth = newWidth
        }
        .padding(.vertical, Constants.verticalPadding)
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(minWidth: disableScroll ? max(0, containerWidth - Constants.horizontalPadding * 2) : 0,
               alignment: shouldCenterAlign ? .center : .leading)
    }

    private func pillButton(for viewModel: PillButtonViewModel<Selection>) -> some View {
        let value = viewModel.selectionValue
        let title = viewModel.title
        let isSelected = currentSelection.wrappedValue == value
        let ignoreTap = !supportsPillDeselection && isSelected

        if viewModel.isUnread, isSelected {
            viewModel.isUnread = false
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
            Text(viewModel.title)
        }
        .buttonStyle(pillButtonStyle(isSelected: isSelected,
                                     isUnread: viewModel.isUnread,
                                     leadingImage: viewModel.leadingImage))
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .global)
        } action: { rect in
            pillFrames[value] = rect
        }
        .onDisappear {
            pillFrames.removeValue(forKey: value)
        }
        .allowsHitTesting(!ignoreTap && isEnabled)
        .id(value)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel(viewModel.isUnread ? String(format: "Accessibility.TabBarItemView.UnreadFormat".localized, title) : title)
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

    private func scrollToSelectedPill() {
        guard scrollViewFrame.width > 0,
              let selected = currentSelection.wrappedValue else {
            return
        }

        let anchorX = Constants.scrollPadding / scrollViewFrame.width
        scrollAnchor = UnitPoint(x: anchorX, y: Constants.scrollAnchorY)
        scrollTargetId = selected
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
    @State private var scrollTargetId: Selection?
    @State private var scrollAnchor: UnitPoint = .center

    private let style: PillButtonStyle
    private let centerAlignIfContentFits: Bool
    private let supportsPillDeselection: Bool
    private let tokenOverrides: [PillButtonToken: ControlTokenValue]?
    private let viewModels: [PillButtonViewModel<Selection>]

    private var fitsContainer: Bool { contentWidth + Constants.horizontalPadding * 2 <= containerWidth }
    private var shouldCenterAlign: Bool { centerAlignIfContentFits && fitsContainer }
    private var disableScroll: Bool { fitsContainer }
}

private struct Constants {
    static let pillSpacing: CGFloat = GlobalTokens.spacing(.size80)
    static let verticalPadding: CGFloat = GlobalTokens.spacing(.size100)
    static let horizontalPadding: CGFloat = GlobalTokens.spacing(.size100)
    static let scrollPadding: CGFloat = GlobalTokens.spacing(.size400)
    static let scrollAnchorY: CGFloat = 0.5
    static let scrollAnchorTrailingX: CGFloat = 1.0
}
