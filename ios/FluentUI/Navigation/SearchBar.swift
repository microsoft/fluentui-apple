//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: SearchBarDelegate

/// Various state update methods coming from the SearchBar
@objc(MSFSearchBarDelegate)
public protocol SearchBarDelegate: AnyObject {
    func searchBarDidBeginEditing(_ searchBar: SearchBar)
    func searchBar(_ searchBar: SearchBar, didUpdateSearchText newSearchText: String?)
    @objc optional func searchBarDidFinishEditing(_ searchBar: SearchBar)
    func searchBarDidCancel(_ searchBar: SearchBar)
    @objc optional func searchBarDidRequestSearch(_ searchBar: SearchBar)
    @objc optional func searchBar(_ searchBar: SearchBar, didUpdateLeadingView leadingView: UIView?)
}

// MARK: - SearchBar

/// Drop-in replacement for UISearchBar that allows for more customization
@objc(MSFSearchBar)
open class SearchBar: UIView, TokenizedControlInternal {
    @objc(MSFSearchBarStyle)
    public enum Style: Int {
        case lightContent, darkContent

        func backgroundColor(fluentTheme: FluentTheme) -> UIColor {
            switch self {
            case .darkContent:
                return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background5])
            case .lightContent:
                return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.brandBackground2].light, dark: fluentTheme.aliasTokens.colors[.background5].dark))
            }
        }

        func cancelButtonColor(fluentTheme: FluentTheme) -> UIColor {
            switch self {
            case .darkContent:
                return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1])
            case .lightContent:
                return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.foregroundOnColor].light, dark: fluentTheme.aliasTokens.colors[.foreground1].dark))
            }
        }

        func clearIconColor(fluentTheme: FluentTheme) -> UIColor {
            switch self {
            case .darkContent:
                return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground2])
            case .lightContent:
                return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.foregroundOnColor].light, dark: fluentTheme.aliasTokens.colors[.foreground2].dark))
            }
        }

        func placeholderColor(fluentTheme: FluentTheme) -> UIColor {
            switch self {
            case .darkContent:
                return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground3])
            case .lightContent:
                return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.foregroundOnColor].light, dark: fluentTheme.aliasTokens.colors[.foreground3].dark))
            }
        }

        func searchIconColor(fluentTheme: FluentTheme, isSearching: Bool = false) -> UIColor {
            let searchBrandColor = UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.foregroundOnColor].light, dark: fluentTheme.aliasTokens.colors[.foreground1].dark))
            let idleBrandColor = UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.foregroundOnColor].light, dark: fluentTheme.aliasTokens.colors[.foreground3].dark))

            switch self {
            case .darkContent:
                return isSearching ? UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1]) : UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground3])
            case .lightContent:
                return isSearching ? searchBrandColor : idleBrandColor
            }
        }

        func textColor(fluentTheme: FluentTheme) -> UIColor {
            switch self {
            case .darkContent:
                return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1])
            case .lightContent:
                return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.foregroundOnColor].light, dark: fluentTheme.aliasTokens.colors[.foreground1].dark))
            }
        }

        func tintColor(fluentTheme: FluentTheme) -> UIColor {
            switch self {
            case .darkContent:
                return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground3])
            case .lightContent:
                return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.foregroundOnColor].light, dark: fluentTheme.aliasTokens.colors[.foreground3].dark))
            }
        }

        func progressSpinnerColor(fluentTheme: FluentTheme) -> UIColor {
            switch self {
            case .darkContent:
                return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground3])
            case .lightContent:
                return UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.foregroundOnColor].light, dark: fluentTheme.aliasTokens.colors[.foreground3].dark))
            }
        }
    }

    private struct Constants {
        static let searchTextFieldCornerRadius: CGFloat = 10.0
        static let searchTextFieldBackgroundHeight: CGFloat = 36.0
        static let searchIconImageViewDimension: CGFloat = 20
        static let searchIconInset: CGFloat = 10.0
        static let searchTextFieldLeadingInset: CGFloat = 10.0
        static let searchTextFieldVerticalInset: CGFloat = 2
        static let searchTextFieldInteractionMinWidth: CGFloat = 50
        static let clearButtonLeadingInset: CGFloat = 10
        static let clearButtonWidth: CGFloat = 8 + 16 + 8   // padding + image + padding
        static let clearButtonTrailingInset: CGFloat = 10
        static let cancelButtonLeadingInset: CGFloat = 8.0
        static let fontSize: CGFloat = 17
        static let cancelButtonShowHideAnimationDuration: TimeInterval = 0.25
        static let navigationBarTransitionHidingDelay: TimeInterval = 0.5

        static let defaultStyle: Style = .lightContent

        static var searchIconInsettedWidth: CGFloat {
            searchIconImageViewDimension + searchIconInset
        }
        static var clearButtonInsettedWidth: CGFloat {
            clearButtonLeadingInset + clearButtonWidth + clearButtonTrailingInset
        }
    }

    @objc open var hidesNavigationBarDuringSearch: Bool = true {
        didSet {
            if oldValue != hidesNavigationBarDuringSearch && isActive {
                if hidesNavigationBarDuringSearch {
                    hideNavigationBar(animated: false)
                } else {
                    unhideNavigationBar(animated: false)
                }
            }
        }
    }

    @objc open var cornerRadius: CGFloat = Constants.searchTextFieldCornerRadius {
        didSet {
            searchTextField.layer.cornerRadius = cornerRadius
        }
    }

    @objc open var placeholderText: String? {
        didSet {
            attributePlaceholderText()
        }
    }

    @objc open var style: Style = Constants.defaultStyle {
        didSet {
            updateColorsForStyle()
        }
    }

    /// Indicates when search bar either has focus or contains a search text.
    @objc open private(set) var isActive: Bool = false

    @objc open weak var delegate: SearchBarDelegate?

    weak var navigationController: NavigationController?

    public typealias TokenSetKeyType = EmptyTokenSet.Tokens
    public var tokenSet: EmptyTokenSet = .init()

    // used to hide the cancelButton in non-active states
    private var searchTextFieldBackgroundViewTrailingConstraint: NSLayoutConstraint?
    private var cancelButtonTrailingConstraint: NSLayoutConstraint?
    private var textFieldLeadingConstraint: NSLayoutConstraint?

    private lazy var searchIconImageViewContainerView = UIView()

    // Leading-edge aligned Icon
    private lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.staticImageNamed("search-20x20")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    // user interaction point
    private lazy var searchTextField: SearchBarTextField = {
        let textField = SearchBarTextField()
        textField.font = UIFont.fluent(tokenSet.fluentTheme.aliasTokens.typography[.body1]).withSize(Constants.fontSize)
        textField.delegate = self
        textField.returnKeyType = .search
        textField.enablesReturnKeyAutomatically = true
        textField.accessibilityTraits = .searchField
        textField.addTarget(self, action: #selector(searchTextFieldValueDidChange(_:)), for: .editingChanged)
        textField.showsLargeContentViewer = true

        return textField
    }()

    @objc open var autocorrectionType: UITextAutocorrectionType {
        get { return searchTextField.autocorrectionType }
        set { searchTextField.autocorrectionType = newValue }
    }

    // a "searchTextField" in native iOS is comprised of an inset Magnifying Glass image followed by an inset textfield.
    // backgroundview is used to achive an inset textfield
    private lazy var searchTextFieldBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = style.backgroundColor(fluentTheme: tokenSet.fluentTheme)
        backgroundView.layer.cornerRadius = Constants.searchTextFieldCornerRadius
        return backgroundView
    }()

    // removes text from the searchTextField
    private lazy var clearButton: UIButton = {
        let clearButton = UIButton()
        clearButton.addTarget(self, action: #selector(SearchBar.clearButtonTapped(sender:)), for: .touchUpInside)
        clearButton.setImage(UIImage.staticImageNamed("search-clear"), for: .normal)
        clearButton.isHidden = true

        clearButton.isPointerInteractionEnabled = true
        clearButton.pointerStyleProvider = { button, _, _ in
            let preview = UITargetedPreview(view: button)
            return UIPointerStyle(effect: .lift(preview))
        }

        return clearButton
    }()

    // hidden when the textfield is not active
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.fluent(tokenSet.fluentTheme.aliasTokens.typography[.body1])
        button.setTitle("Common.Cancel".localized, for: .normal)
        button.addTarget(self, action: #selector(SearchBar.cancelButtonTapped(sender:)), for: .touchUpInside)
        button.alpha = 0.0
        button.showsLargeContentViewer = true
        button.isPointerInteractionEnabled = true

        return button
    }()

    @objc public var leadingView: UIView? {
        didSet {
            guard oldValue != leadingView else {
                return
            }

            oldValue?.removeFromSuperview()
            setupLayoutForLeadingView()
            onContentChanged()
            delegate?.searchBar?(self, didUpdateLeadingView: leadingView)
        }
    }

    @objc open var isEditable: Bool = true {
        didSet {
            if !isEditable {
                _ = resignFirstResponder()
            }
            searchTextField.isUserInteractionEnabled = isEditable
        }
    }

    private var originalIsNavigationBarHidden: Bool = false

    /// indicates search in progress
    @objc public lazy var progressSpinner: MSFActivityIndicator = MSFActivityIndicator(size: .medium)

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
        initialize()
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(themeView.fluentTheme)
        updateColorsForStyle()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        setupLayout()
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateColorsForStyle()
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: Constants.searchTextFieldBackgroundHeight)
    }

    private func startSearch() {
        if isActive {
            return
        }
        updateSearchingColors()
        attributePlaceholderText()
        showCancelButton()

        if hidesNavigationBarDuringSearch {
            originalIsNavigationBarHidden = navigationController?.isNavigationBarHidden ?? false

            // Using delayed async to work around a bug on iOS when it restores responder status for the text field when controller appears (due to navigation controller's pop action) even though text field resigned responder status before a detail controller was pushed
            let isTransitioning = navigationController?.transitionCoordinator != nil
            DispatchQueue.main.asyncAfter(deadline: .now() + (isTransitioning ? Constants.navigationBarTransitionHidingDelay : 0)) {
                self.hideNavigationBar(animated: true)
            }
        }

        isActive = true
    }

    @objc open func cancelSearch() {
        if !isActive {
            return
        }

        updateRestingColors()
        isActive = false
        searchTextField.resignFirstResponder()
        searchTextField.text = nil
        leadingView = nil
        searchTextDidChange(shouldUpdateDelegate: false)
        delegate?.searchBarDidCancel(self)
        hideCancelButton()

        if hidesNavigationBarDuringSearch {
            unhideNavigationBar(animated: true)
        }
    }

    private func hideNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func unhideNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(originalIsNavigationBarHidden, animated: animated)
    }

    private func attributePlaceholderText() {
        guard let newPlaceholder = placeholderText else {
            searchTextField.attributedPlaceholder = nil
            return
        }
        let newAttributes = [NSAttributedString.Key.foregroundColor: style.placeholderColor(fluentTheme: tokenSet.fluentTheme)]
        let attributedPlaceholderText = NSAttributedString(string: newPlaceholder, attributes: newAttributes)
        searchTextField.attributedPlaceholder = attributedPlaceholderText
    }

    // MARK: - Layout Construction

    private func setupLayout() {
        addInteraction(UILargeContentViewerInteraction())

        // Autolayout is more efficent if all constraints are activated simultaneously
        var constraints = [NSLayoutConstraint]()

        // textfield background
        addSubview(searchTextFieldBackgroundView)
        searchTextFieldBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        searchTextFieldBackgroundView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        constraints.append(searchTextFieldBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor))
        constraints.append(searchTextFieldBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor))
        constraints.append(searchTextFieldBackgroundView.heightAnchor.constraint(equalToConstant: Constants.searchTextFieldBackgroundHeight))
        let searchTextFieldBackgroundViewTrailing = searchTextFieldBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        searchTextFieldBackgroundViewTrailingConstraint = searchTextFieldBackgroundViewTrailing
        constraints.append(searchTextFieldBackgroundViewTrailing)

        // search icon container
        searchTextFieldBackgroundView.addSubview(searchIconImageViewContainerView)
        searchIconImageViewContainerView.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(searchIconImageViewContainerView.leadingAnchor.constraint(equalTo: searchTextFieldBackgroundView.leadingAnchor, constant: Constants.searchIconInset))
        constraints.append(searchIconImageViewContainerView.widthAnchor.constraint(equalToConstant: Constants.searchIconImageViewDimension))
        constraints.append(searchIconImageViewContainerView.heightAnchor.constraint(equalTo: searchIconImageViewContainerView.widthAnchor))
        constraints.append(searchIconImageViewContainerView.centerYAnchor.constraint(equalTo: searchTextFieldBackgroundView.centerYAnchor))

        // search icon
        searchIconImageViewContainerView.addSubview(searchIconImageView)
        searchIconImageView.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(searchIconImageView.widthAnchor.constraint(equalToConstant: Constants.searchIconImageViewDimension))
        constraints.append(searchIconImageView.heightAnchor.constraint(equalToConstant: Constants.searchIconImageViewDimension))
        constraints.append(searchIconImageView.centerXAnchor.constraint(equalTo: searchIconImageViewContainerView.centerXAnchor))
        constraints.append(searchIconImageView.centerYAnchor.constraint(equalTo: searchIconImageViewContainerView.centerYAnchor))

        // search textfield
        searchTextFieldBackgroundView.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(searchTextField.centerYAnchor.constraint(equalTo: searchTextFieldBackgroundView.centerYAnchor))
        constraints.append(searchTextField.heightAnchor.constraint(equalTo: searchTextFieldBackgroundView.heightAnchor, constant: -2 * Constants.searchTextFieldVerticalInset))
        constraints.append(searchTextField.leadingAnchor.constraint(equalTo: searchIconImageViewContainerView.trailingAnchor, constant: Constants.searchTextFieldLeadingInset))
        textFieldLeadingConstraint = constraints.last

        // progressSpinner
        let progressSpinnerView = progressSpinner
        searchTextFieldBackgroundView.addSubview(progressSpinnerView)
        progressSpinnerView.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(progressSpinnerView.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: Constants.clearButtonLeadingInset))
        constraints.append(progressSpinnerView.heightAnchor.constraint(equalTo: clearButton.widthAnchor))
        constraints.append(progressSpinnerView.trailingAnchor.constraint(equalTo: searchTextFieldBackgroundView.trailingAnchor, constant: -1 * Constants.clearButtonTrailingInset))
        constraints.append(progressSpinnerView.centerYAnchor.constraint(equalTo: searchTextFieldBackgroundView.centerYAnchor))

        // clearButton
        searchTextFieldBackgroundView.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(clearButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: Constants.clearButtonLeadingInset))
        constraints.append(clearButton.heightAnchor.constraint(equalTo: clearButton.widthAnchor))
        constraints.append(clearButton.trailingAnchor.constraint(equalTo: searchTextFieldBackgroundView.trailingAnchor, constant: -1 * Constants.clearButtonTrailingInset))
        constraints.append(clearButton.centerYAnchor.constraint(equalTo: searchTextFieldBackgroundView.centerYAnchor))

        // cancelButton
        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        cancelButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        constraints.append(cancelButton.leadingAnchor.constraint(equalTo: searchTextFieldBackgroundView.trailingAnchor, constant: Constants.cancelButtonLeadingInset))
        constraints.append(cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor))
        let cancelButtonTrailing = cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        cancelButtonTrailingConstraint = cancelButtonTrailing

        NSLayoutConstraint.activate(constraints)
    }

    private func setupLayoutForLeadingView() {
        textFieldLeadingConstraint?.isActive = leadingView == nil

        guard let leadingView = leadingView else {
            return
        }

        searchTextFieldBackgroundView.addSubview(leadingView)

        let leadingViewRenderWidth = searchTextFieldBackgroundView.frame.size.width - Constants.searchIconInsettedWidth - Constants.searchTextFieldLeadingInset - Constants.searchTextFieldInteractionMinWidth - Constants.clearButtonInsettedWidth
        let leadingViewRenderSize = CGSize(width: leadingViewRenderWidth, height: searchTextFieldBackgroundView.frame.size.height)
        let leadingViewSize = leadingView.sizeThatFits(leadingViewRenderSize)
        leadingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingView.leadingAnchor.constraint(equalTo: searchIconImageViewContainerView.trailingAnchor, constant: Constants.searchIconInset),
            leadingView.trailingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: -Constants.searchTextFieldLeadingInset),
            leadingView.centerYAnchor.constraint(equalTo: searchTextFieldBackgroundView.centerYAnchor),
            leadingView.widthAnchor.constraint(equalToConstant: leadingViewSize.width),
            leadingView.heightAnchor.constraint(equalToConstant: leadingViewSize.height)
        ])
    }

    private func updateColorsForStyle() {
        searchTextFieldBackgroundView.backgroundColor = style.backgroundColor(fluentTheme: tokenSet.fluentTheme)
        searchIconImageView.tintColor = style.searchIconColor(fluentTheme: tokenSet.fluentTheme)
        searchTextField.textColor = style.textColor(fluentTheme: tokenSet.fluentTheme)
        // used for cursor or selection handle
        searchTextField.tintColor = style.tintColor(fluentTheme: tokenSet.fluentTheme)
        clearButton.tintColor = style.clearIconColor(fluentTheme: tokenSet.fluentTheme)
        progressSpinner.state.color = style.progressSpinnerColor(fluentTheme: tokenSet.fluentTheme)
        cancelButton.setTitleColor(style.cancelButtonColor(fluentTheme: tokenSet.fluentTheme), for: .normal)
        attributePlaceholderText()
    }

    private func updateSearchingColors() {
        searchIconImageView.tintColor = style.searchIconColor(fluentTheme: tokenSet.fluentTheme, isSearching: true)
    }

    private func updateRestingColors() {
        searchIconImageView.tintColor = style.searchIconColor(fluentTheme: tokenSet.fluentTheme)
    }

    // MARK: - UIActions

    // Target for the search "cancel" button, outside the search text field
    @objc private func cancelButtonTapped(sender: UIButton) {
        cancelSearch()
    }

    // Target for the clearing "X" button within the search text field
    // Clears all text by setting searchText to nil
    @objc private func clearButtonTapped(sender: UIButton) {
        searchTextField.text = nil
        leadingView = nil
        searchTextDidChange(shouldUpdateDelegate: true)
        _ = searchTextField.becomeFirstResponder()
    }

    // MARK: - Search Text Handling

    /// The string value of the search text field
    @objc open var searchText: String? {
        get { return searchTextField.text }
        set { self.searchTextField.text = newValue }
    }

    @objc private func searchTextFieldValueDidChange(_ textField: UITextField) {
        searchTextDidChange(shouldUpdateDelegate: true)
    }

    /// Called after a change in the searchTextField
    /// Optionally updates the searchBarDelegate
    /// Also manipulates various UI properties based on the provided string
    ///
    /// - Parameters:
    ///   - shouldUpdateDelegate: whether to update the SearchBarDelegate with the event (avoided, for instance, if the cancel button is tapped)
    private func searchTextDidChange(shouldUpdateDelegate: Bool) {
        let newSearchText = searchTextField.text

        if shouldUpdateDelegate {
            delegate?.searchBar(self, didUpdateSearchText: newSearchText)
        }

        onContentChanged()
    }

    private func onContentChanged() {
        let hasContent = searchTextField.text?.isEmpty == false || leadingView != nil

        UIView.animate(withDuration: 0.1) {
            self.attributePlaceholderText()
            self.clearButton.isHidden = !hasContent
        }
    }

    // MARK: - Cancel Button Styling Methods

    /// Shows the Cancel button via its layer's alpha property
    /// Also updates the UI to show the Cancel button via autolayout
    private func showCancelButton() {
        UIView.animate(withDuration: Constants.cancelButtonShowHideAnimationDuration, animations: {
            self.cancelButton.alpha = 1.0
            self.searchTextFieldBackgroundViewTrailingConstraint?.isActive = false
            self.cancelButtonTrailingConstraint?.isActive = true
            self.cancelButton.setNeedsLayout()
            self.layoutIfNeeded()
        })
    }

    /// Hides the Cancel button via its layer's alpha property
    /// Also updates the UI to hide the Cancel button via autolayout
    private func hideCancelButton() {
        UIView.animate(withDuration: Constants.cancelButtonShowHideAnimationDuration, animations: {
            self.cancelButton.alpha = 0.0
            self.cancelButtonTrailingConstraint?.isActive = false
            self.searchTextFieldBackgroundViewTrailingConstraint?.isActive = true
            self.cancelButton.setNeedsLayout()
            self.layoutIfNeeded()
        })
    }

    // MARK: - Keyboard Handling

    open override func becomeFirstResponder() -> Bool {
        return searchTextField.becomeFirstResponder()
    }

    open override func resignFirstResponder() -> Bool {
        return searchTextField.resignFirstResponder()
    }

    open override var isFirstResponder: Bool {
        return searchTextField.isFirstResponder
    }

    private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }

    // MARK: - Cancel Button Accessibility Properties

    public var cancelButtonAccessibilityHint: String? {
        get { return cancelButton.accessibilityHint }
        set { cancelButton.accessibilityHint = newValue }
    }

    public var cancelButtonAccessibilityLabel: String? {
        get { return cancelButton.accessibilityLabel }
        set { cancelButton.accessibilityLabel = newValue }
    }

    public var cancelButtonAccessibilityIdentifier: String? {
        get { return cancelButton.accessibilityIdentifier }
        set { cancelButton.accessibilityIdentifier = newValue }
    }

    // MARK: - Clear Button Accessibility Properties

    public var clearButtonAccessibilityHint: String? {
        get { return clearButton.accessibilityHint }
        set { clearButton.accessibilityHint = newValue }
    }

    public var clearButtonAccessibilityLabel: String? {
        get { return clearButton.accessibilityLabel }
        set { clearButton.accessibilityLabel = newValue }
    }

    public var clearButtonAccessibilityIdentifier: String? {
        get { return clearButton.accessibilityIdentifier }
        set { clearButton.accessibilityIdentifier = newValue }
    }

    // MARK: - Search Text Field Accessibility Properties

    public var searchTextFieldAccessibilityHint: String? {
        get { return searchTextField.accessibilityHint }
        set { searchTextField.accessibilityHint = newValue }
    }

    public var searchTextFieldAccessibilityLabel: String? {
        get { return searchTextField.accessibilityLabel }
        set { searchTextField.accessibilityLabel = newValue }
    }

    public var searchTextFieldAccessibilityIdentifier: String? {
        get { return searchTextField.accessibilityIdentifier }
        set { searchTextField.accessibilityIdentifier = newValue }
    }
}

// MARK: - SearchBar: UITextFieldDelegate

extension SearchBar: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        startSearch()
        delegate?.searchBarDidBeginEditing(self)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarDidRequestSearch?(self)
        dismissKeyboard()
        return false
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchTextField && string.isEmpty && range == NSRange(location: 0, length: 0) {
            leadingView = nil
        }
        return true
    }
}

// MARK: - UINavigationItem extension

extension UINavigationItem {
    var accessorySearchBar: SearchBar? { return accessoryView as? SearchBar }
}

// MARK: - SearchBarTextField

private class SearchBarTextField: UITextField {
    override func deleteBackward() {
        // Triggers the delegate method even when the cursor (caret) is in the first postion (regardless of text being empty).
        // Using the zero width space ("\u{200B}") as the emptyTextFieldString instead of this approach will cause Voice Over
        // to read it out loud as "zero width space", which is not desirable.
        if let selectionRange = selectedTextRange,
           selectionRange.isEmpty,
           offset(from: beginningOfDocument, to: selectionRange.start) == 0 {
            _ = self.delegate?.textField?(self,
                                          shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                          replacementString: "")
        }

        super.deleteBackward()
    }
}
