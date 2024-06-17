//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class SearchBarDemoController: DemoController, SearchBarDelegate {
    private struct Constants {
        static let badgeViewCornerRadius: CGFloat = 10
        static let badgeViewSideLength: CGFloat = 20
        static let badgeViewMaxFontSize: CGFloat = 40
        static let searchBarStackviewMargin: CGFloat = 16
    }

    private lazy var searchBarWithBadgeView: SearchBar =
        buildSearchBar(autocorrectionType: .yes, placeholderText: "Type \"badge\" to add a leading badge")
    private lazy var searchBarWithAvatarBadgeView: SearchBar =
        buildSearchBar(autocorrectionType: .yes, placeholderText: "Type \"badge\" to add a leading badge with avatar")

    private lazy var badgeView: UIView = buildBadgeView(text: "Kat Larsson")

    private lazy var avatarBadgeView: UIView = {
        let imageView = UIImageView(image: UIImage(named: "avatar_kat_larsson"))
        imageView.frame.size = CGSize(width: Constants.badgeViewSideLength, height: Constants.badgeViewSideLength)
        imageView.layer.cornerRadius = Constants.badgeViewCornerRadius
        imageView.layer.masksToBounds = true
        return buildBadgeView(text: "Kat Larsson", customView: imageView)
    }()

    private var searchBars: [SearchBar] = []

    let segmentedControl: SegmentedControl = {
        let segmentedControl = SegmentedControl(items: [SegmentItem(title: "OnCanvas"),
                                                        SegmentItem(title: "OnSystem"),
                                                        SegmentItem(title: "OnBrand")],
                                                style: .neutralOverNavBarPill)

        return segmentedControl
    }()

    @objc private func updateSearchbars() {
        if segmentedControl.selectedSegmentIndex == 2 {
            searchBarsStackView.backgroundColor = NavigationBar.backgroundColor(for: .primary, theme: view.fluentTheme)
            updateSearchBarsStyles(to: .onBrandNavigationBar)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            searchBarsStackView.backgroundColor = NavigationBar.backgroundColor(for: .system, theme: view.fluentTheme)
            updateSearchBarsStyles(to: .onSystemNavigationBar)
        } else {
            searchBarsStackView.backgroundColor = UIColor(light: view.fluentTheme.color(.background5).light,
                                                          dark: view.fluentTheme.color(.background1))
            updateSearchBarsStyles(to: .onCanvas)
        }
    }

    private func updateSearchBarsStyles(to style: SearchBar.Style) {
        for searchBar in searchBars {
            searchBar.style = style
        }
    }

    // Used to change the SearchBars' background color between brand and system styles
    private let searchBarsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.layoutMargins = UIEdgeInsets(top: Constants.searchBarStackviewMargin,
                                               left: Constants.searchBarStackviewMargin,
                                               bottom: Constants.searchBarStackviewMargin,
                                               right: Constants.searchBarStackviewMargin)
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = Constants.searchBarStackviewMargin
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBarNoAutocorrect = buildSearchBar(autocorrectionType: .no, placeholderText: "No autocorrect")
        let searchBarAutocorrect = buildSearchBar(autocorrectionType: .yes, placeholderText: "Autocorrect")
        let numberSearchBar = buildSearchBar(autocorrectionType: .no, placeholderText: "Numberpad search")
        numberSearchBar.keyboardType = .numberPad

        searchBars = [searchBarNoAutocorrect, searchBarAutocorrect, numberSearchBar, searchBarWithBadgeView, searchBarWithAvatarBadgeView]

        container.addArrangedSubview(segmentedControl)
        container.addArrangedSubview(UIView())

        for searchBar in searchBars {
            searchBarsStackView.addArrangedSubview(searchBar)
        }

        container.addArrangedSubview(searchBarsStackView)

        segmentedControl.onSelectAction = { [weak self] (_, _) in
            guard let strongSelf = self else {
                return
            }

            strongSelf.updateSearchbars()
        }

        updateSearchbars()
    }

    func buildBadgeView(text: String, customView: UIView? = nil) -> UIView {
        let dataSource = BadgeViewDataSource(text: text, customView: customView)
        let badge = BadgeView(dataSource: dataSource)
        badge.lineBreakMode = .byTruncatingTail
        badge.tokenSet[.backgroundDisabledColor] = .uiColor { .init(light: GlobalTokens.sharedColor(.purple, .primary)) }
        badge.tokenSet[.foregroundDisabledColor] = .uiColor { .init(light: GlobalTokens.neutralColor(.white)) }
        badge.isActive = false
        badge.maxFontSize = Constants.badgeViewMaxFontSize
        return badge
    }

    func buildSearchBar(autocorrectionType: UITextAutocorrectionType, placeholderText: String) -> SearchBar {
        let searchBar = SearchBar(frame: .zero)
        searchBar.delegate = self
        searchBar.style = .onCanvas
        searchBar.placeholderText = placeholderText
        searchBar.hidesNavigationBarDuringSearch = false
        searchBar.autocorrectionType = autocorrectionType
        return searchBar
    }

    // MARK: SearchBarDelegate

    func searchBarDidBeginEditing(_ searchBar: SearchBar) {
    }

    func searchBar(_ searchBar: SearchBar, didUpdateSearchText newSearchText: String?) {
        if searchBar == searchBarWithBadgeView && searchBar.searchText?.lowercased() == "badge" && searchBarWithBadgeView.leadingView == nil {
            searchBarWithBadgeView.leadingView = badgeView
            searchBar.searchText = ""
        }
        if searchBar == searchBarWithAvatarBadgeView && searchBar.searchText?.lowercased() == "badge" && searchBarWithAvatarBadgeView.leadingView == nil {
            searchBarWithAvatarBadgeView.leadingView = avatarBadgeView
            searchBar.searchText = ""
        }
    }

    func searchBarDidFinishEditing(_ searchBar: SearchBar) {
    }

    func searchBarDidCancel(_ searchBar: SearchBar) {
        searchBar.progressSpinner.state.isAnimating = false
    }

    func searchBarDidRequestSearch(_ searchBar: SearchBar) {
        searchBar.progressSpinner.state.isAnimating = true
    }

    func searchBar(_ searchBar: SearchBar, didUpdateLeadingView leadingView: UIView?) {
        let badgeInfo = (leadingView as? BadgeView)?.dataSource?.text ?? "nil"

        let alert = UIAlertController(title: "Badge view updated: \(badgeInfo)", message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: false)
        }
    }
}

// MARK: DemoAppearanceDelegate

extension SearchBarDemoController: DemoAppearanceDelegate {
    func themeWideOverrideDidChange(isOverrideEnabled: Bool) {
        guard let fluentTheme = self.view.window?.fluentTheme else {
            return
        }

        fluentTheme.register(tokenSetType: SearchBarTokenSet.self, tokenSet: isOverrideEnabled ? themeWideOverrideSearchBarTokens : nil)
    }

    func perControlOverrideDidChange(isOverrideEnabled: Bool) {
        for searchBar in searchBars {
            searchBar.tokenSet.replaceAllOverrides(with: isOverrideEnabled ? perControlOverrideSearchBarTokens : nil)
        }
    }

    func isThemeWideOverrideApplied() -> Bool {
        return self.view.window?.fluentTheme.tokens(for: SearchBarTokenSet.self)?.isEmpty == false
    }

    // MARK: - Custom tokens
    private var themeWideOverrideSearchBarTokens: [SearchBarTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.berry, .shade30),
                               dark: GlobalTokens.sharedColor(.berry, .tint40))
            },
            .textColor: .uiColor {
                return UIColor(light: GlobalTokens.neutralColor(.white),
                               dark: GlobalTokens.neutralColor(.grey98))
            },
            .font: .uiFont {
                return self.view.fluentTheme.typography(.body1Strong)
            },
            .progressSpinnerColor: .uiColor {
                return .green
            },
            .activeSearchIconColor: .uiColor {
                return UIColor(light: GlobalTokens.neutralColor(.white),
                               dark: GlobalTokens.sharedColor(.lime, .tint40))
            }
        ]
    }

    private var perControlOverrideSearchBarTokens: [SearchBarTokenSet.Tokens: ControlTokenValue] {
        return [
            .backgroundColor: .uiColor {
                return self.view.fluentTheme.color(.dangerBackground1)
            },
            .textColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.lime, .shade30),
                               dark: GlobalTokens.sharedColor(.lime, .tint40))
            },
            .cancelButtonColor: .uiColor {
                return .red
            },
            .placeholderColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.berry, .shade30),
                               dark: GlobalTokens.sharedColor(.berry, .tint40))
            },
            .inactiveSearchIconColor: .uiColor {
                return UIColor(light: GlobalTokens.sharedColor(.lime, .shade30),
                               dark: GlobalTokens.sharedColor(.lime, .tint40))
            },
            .font: .uiFont {
                return UIFont(descriptor: .init(name: "Papyrus", size: 12), size: 12)
            }
        ]
    }
}
