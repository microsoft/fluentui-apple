//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class SearchBarDemoController: DemoController, SearchBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBarNoAutocorrect = buildSearchBar(autocorrectionType: .no, placeholderText: "no autocorrect")
        let searchBarAutocorrect = buildSearchBar(autocorrectionType: .yes, placeholderText: "autocorrect")

        container.addArrangedSubview(searchBarNoAutocorrect)
        container.addArrangedSubview(searchBarAutocorrect)
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
        searchBar.placeholderText = newSearchText ?? "search"
    }
    
    func searchBarDidFinishEditing(_ searchBar: SearchBar) {
    }
    
    func searchBarDidCancel(_ searchBar: SearchBar) {
        searchBar.progressSpinner.stopAnimating()
    }
    
    func searchBarDidRequestSearch(_ searchBar: SearchBar) {
        searchBar.progressSpinner.startAnimating()
    }
}
