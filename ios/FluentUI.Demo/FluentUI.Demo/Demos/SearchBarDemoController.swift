//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class SearchBarDemoController: DemoController, SearchBarDelegate {
    private lazy var searchBarWithBadgeView: SearchBar = {
        let searchBar = buildSearchBar(
            autocorrectionType: .yes,
            placeholderText: "Type badge to add a badge"
        )
        return searchBar
    }()

    private var badgeView: UIView = {
        let dataSource = BadgeViewDataSource(text: "Kat Larrson")
        let badge = BadgeView(dataSource: dataSource)
        badge.disabledBackgroundColor = Colors.Palette.blueMagenta20.color
        badge.disabledLabelTextColor = .white
        badge.isActive = false
        return badge
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBarNoAutocorrect = buildSearchBar(autocorrectionType: .no, placeholderText: "no autocorrect")
        let searchBarAutocorrect = buildSearchBar(autocorrectionType: .yes, placeholderText: "autocorrect")

        container.addArrangedSubview(searchBarNoAutocorrect)
        container.addArrangedSubview(searchBarAutocorrect)
        container.addArrangedSubview(searchBarWithBadgeView)
    }

    func buildSearchBar(autocorrectionType: UITextAutocorrectionType, placeholderText: String) -> SearchBar {
        let searchBar = SearchBar(frame: .zero)
        searchBar.delegate = self
        searchBar.style = .darkContent // we want the opposite as we're not embedded in the header
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
    }

    func searchBarDidFinishEditing(_ searchBar: SearchBar) {
    }

    func searchBarDidCancel(_ searchBar: SearchBar) {
        searchBar.progressSpinner.state.isAnimating = false
    }

    func searchBarDidRequestSearch(_ searchBar: SearchBar) {
        searchBar.progressSpinner.state.isAnimating = true
    }

    func searchBar(_ searchBar: SearchBar, didUpdateBadgeView badgeView: BadgeView?) {
        let badgeInfo = badgeView?.dataSource?.text ?? "nil"

        let alert = UIAlertController(title: "Badge view updated: \(badgeInfo)", message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: false)
        }
    }
}
