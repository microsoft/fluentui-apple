//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

class PillButtonBarDemoControllerSwiftUI: DemoHostingController {
    init() {
        super.init(rootView: AnyView(PillButtonBarDemoView()), title: "Pill Button Bar (SwiftUI)")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @MainActor required dynamic init(rootView: AnyView) {
        preconditionFailure("init(rootView:) has not been implemented")
    }
}

private struct PillButtonBarDemoView: View {
    fileprivate var body: some View {
        let theme = useCustomTheme ? customTheme : fluentTheme
        let tokenOverrides = showTokenOverrides ? tokenOverrides : nil

        return VStack {
            ScrollView(.vertical) {
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        Text("onBrand bar")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(fluentTheme.swiftUIColor(.foreground1))
                        PillButtonBarView(style: .onBrand,
                                          viewModels: indexSelectionViewModels,
                                          selected: $onBrandSelectedIndex,
                                          centerAlignIfContentFits: true,
                                          tokenOverrides:  tokenOverrides)
                        .disabled(disablePills)
                        .background {
                            fluentTheme.swiftUIColor(.brandBackground1)
                        }
                        
                        Text("Primary bar")
                            .foregroundStyle(fluentTheme.swiftUIColor(.foreground1))
                            .multilineTextAlignment(.center)
                        PillButtonBarView(style: .primary,
                                          viewModels: titleSelectionViewModels,
                                          selected: $primarySelectedTitle,
                                          centerAlignIfContentFits: true,
                                          tokenOverrides:  tokenOverrides)
                        .disabled(disablePills)

                        Text("Bar with deselection")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(fluentTheme.swiftUIColor(.foreground1))
                        Text("This pill button bar supports having no selected pill button. If the currently selected pill button is tapped, it will be deselected.")
                            .foregroundStyle(fluentTheme.swiftUIColor(.foreground1))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption)
                        PillButtonBarView(style: .primary,
                                          viewModels: titleDeselectionViewModels,
                                          selected: $deselectionBarTitle,
                                          tokenOverrides:  tokenOverrides)
                        .disabled(disablePills)

                        Text("Leading aligned")
                            .foregroundStyle(fluentTheme.swiftUIColor(.foreground1))
                        PillButtonBarView(style: .primary,
                                          viewModels: titleSelectionLeadingViewModels,
                                          selected: $leadingAlignedBarSelectedTitle,
                                          tokenOverrides:  tokenOverrides)
                        .disabled(disablePills)

                        Text("Center aligned")
                            .foregroundStyle(fluentTheme.swiftUIColor(.foreground1))
                        PillButtonBarView(style: .primary,
                                          viewModels: titleSelectionCenterViewModels,
                                          selected: $centerAlignedBarSelectedTitle,
                                          centerAlignIfContentFits: true,
                                          tokenOverrides:  tokenOverrides)
                        .disabled(disablePills)
                    }
                    .fluentTheme(theme)
                }
                .background(FluentTheme.shared.swiftUIColor(.background1))
                .onChange_iOS17(of: primarySelectedTitle) { newValue in
                    showAlert = true
                    alertTitle = "Title \(newValue) selected"
                }
                .onChange_iOS17(of: onBrandSelectedIndex) { newValue in
                    showAlert = true
                    alertTitle = "Index \(newValue) selected"
                }
                .onChange_iOS17(of: deselectionBarTitle) { newValue in
                    showAlert = true
                    alertTitle = newValue != nil ? "Title \"\(newValue!)\" selected" : "No pill selected"
                }
                .onChange_iOS17(of: leadingAlignedBarSelectedTitle) { newValue in
                    showAlert = true
                    alertTitle = "Title \(newValue) selected"
                }
                .onChange_iOS17(of: centerAlignedBarSelectedTitle) { newValue in
                    showAlert = true
                    alertTitle = "Title \(newValue) selected"
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text(alertTitle))
                })
            }

            FluentList {
                Toggle("Toggle custom theme", isOn: $useCustomTheme)
                Toggle("Toggle token overrides", isOn: $showTokenOverrides)
                Toggle("Disable pills", isOn: $disablePills)
            }
            .fluentListStyle(.insetGrouped)
            .frame(maxHeight: 200)
        }
    }

    @Environment(\.fluentTheme) private var fluentTheme: FluentTheme
    @State private var selectedDelectedTitle: Int? = nil
    @State private var onBrandSelectedIndex: Int = 0
    @State private var primarySelectedTitle: String = "People"
    @State private var deselectionBarTitle: String? = nil
    @State private var leadingAlignedBarSelectedTitle: String = ""
    @State private var centerAlignedBarSelectedTitle: String = ""

    @State private var alertTitle: String = ""
    @State private var showAlert = false
    @State private var useCustomTheme: Bool = false
    @State private var showTokenOverrides: Bool = false
    @State private var disablePills: Bool = false

    private let indexSelectionViewModels = indexSelectionViewModels(titles: Constants.longTitles)
    private let titleSelectionViewModels = titleSelectionViewModels(titles: Constants.longTitles)
    private let titleDeselectionViewModels = titleSelectionViewModels(titles: Constants.longTitles)
    private let titleSelectionLeadingViewModels = titleSelectionViewModels(titles: Constants.shortTitles)
    private let titleSelectionCenterViewModels = titleSelectionViewModels(titles: Constants.shortTitles)

    private static func indexSelectionViewModels(titles: [String]) -> [PillButtonViewModel<Int>] {
        var viewModels: [PillButtonViewModel<Int>] = []

        for index in 0..<titles.count {
            let leadingImage = Bool.random() ? Constants.leadingImage : nil
            let hasUnreadDot = Bool.random()

            let viewModel = PillButtonViewModel(title: titles[index],
                                                selectionValue: index,
                                                leadingImage: leadingImage,
                                                isUnread: hasUnreadDot)
            viewModels.append(viewModel)
        }

        return viewModels
    }

    private static func titleSelectionViewModels(titles: [String]) -> [PillButtonViewModel<String>] {
        var viewModels: [PillButtonViewModel<String>] = []

        for title in titles {
            let leadingImage = Bool.random() ? Constants.leadingImage : nil
            let hasUnreadDot = Bool.random()

            let viewModel = PillButtonViewModel(title: title,
                                                selectionValue: title,
                                                leadingImage: leadingImage,
                                                isUnread: hasUnreadDot)
            viewModels.append(viewModel)
        }

        return viewModels
    }

    private let customTheme: FluentTheme = {
        let colorOverrides = [
            FluentTheme.ColorToken.brandBackground2: GlobalTokens.sharedSwiftUIColor(.lavender, .shade20),
            FluentTheme.ColorToken.background5: GlobalTokens.sharedSwiftUIColor(.green, .shade10),
            FluentTheme.ColorToken.foreground2: GlobalTokens.sharedSwiftUIColor(.green, .tint40),
            FluentTheme.ColorToken.foreground3: GlobalTokens.sharedSwiftUIColor(.green, .tint40),
            FluentTheme.ColorToken.brandForeground1: GlobalTokens.sharedSwiftUIColor(.hotPink, .tint40),
            FluentTheme.ColorToken.foregroundOnColor: GlobalTokens.sharedSwiftUIColor(.hotPink, .tint40),
            FluentTheme.ColorToken.foregroundDisabled1: GlobalTokens.sharedSwiftUIColor(.hotPink, .tint40),
            FluentTheme.ColorToken.brandForegroundDisabled1: GlobalTokens.sharedSwiftUIColor(.hotPink, .tint40),
        ]
        return FluentTheme(colorOverrides: colorOverrides)
    }()

    private let tokenOverrides: [PillButtonToken: ControlTokenValue] = [
        .backgroundColor: .uiColor { GlobalTokens.sharedColor(.lime, .shade10) },
        .backgroundColorDisabled: .uiColor { GlobalTokens.sharedColor(.hotPink, .primary) }
    ]

    private struct Constants {
        static let longTitles = ["All", "Documents", "People", "Other", "Templates", "Actions", "More", "Miscellaneous"]
        static let shortTitles = ["All", "Documents"]
        static let leadingImage = Image(systemName: "circle.fill")
    }
}
