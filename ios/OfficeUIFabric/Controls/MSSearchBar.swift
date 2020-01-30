//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSSearchBarDelegate

/// Various state update methods coming from the SearchBar
@objc public protocol MSSearchBarDelegate: class, NSObjectProtocol {
    func searchBarDidBeginEditing(_ searchBar: MSSearchBar)
    func searchBar(_ searchBar: MSSearchBar, didUpdateSearchText newSearchText: String?)
    @objc optional func searchBarDidFinishEditing(_ searchBar: MSSearchBar)
    func searchBarDidCancel(_ searchBar: MSSearchBar)
    @objc optional func searchBarDidRequestSearch(_ searchBar: MSSearchBar)
}

// MARK: - MSSearchBar

/// Drop-in replacement for UISearchBar that allows for more customization
@objcMembers
open class MSSearchBar: UIView {
    @objc(MSSearchBarStyle)
    public enum Style: Int {
        case lightContent, darkContent

        var backgroundColor: UIColor {
            switch self {
            case .lightContent:
                return MSColors.SearchBar.LightContent.background
            case .darkContent:
                return MSColors.SearchBar.DarkContent.background
            }
        }

        var cancelButtonColor: UIColor {
            switch self {
            case .lightContent:
                return MSColors.SearchBar.LightContent.cancelButton
            case .darkContent:
                return MSColors.SearchBar.DarkContent.cancelButton
            }
        }

        var clearIconColor: UIColor {
            switch self {
            case .lightContent:
                return MSColors.SearchBar.LightContent.clearIcon
            case .darkContent:
                return MSColors.SearchBar.DarkContent.clearIcon
            }
        }

        var placeholderColor: UIColor {
            switch self {
            case .lightContent:
                return MSColors.SearchBar.LightContent.placeholderText
            case .darkContent:
                return MSColors.SearchBar.DarkContent.placeholderText
            }
        }

        var searchIconColor: UIColor {
            switch self {
            case .lightContent:
                return MSColors.SearchBar.LightContent.searchIcon
            case .darkContent:
                return MSColors.SearchBar.DarkContent.searchIcon
            }
        }

        var textColor: UIColor {
            switch self {
            case .lightContent:
                return MSColors.SearchBar.LightContent.text
            case .darkContent:
                return MSColors.SearchBar.DarkContent.text
            }
        }

        var tintColor: UIColor {
            switch self {
            case .lightContent:
                return MSColors.SearchBar.LightContent.tint
            case .darkContent:
                return MSColors.SearchBar.DarkContent.tint
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
        static let clearButtonLeadingInset: CGFloat = 10
        static let clearButtonWidth: CGFloat = 8 + 16 + 8   // padding + image + padding
        static let clearButtonTrailingInset: CGFloat = 0
        static let cancelButtonLeadingInset: CGFloat = 8.0

        static let searchTextFieldTextStyle: MSTextStyle = .bodyUnscaled
        static let cancelButtonTextStyle: MSTextStyle = .bodyUnscaled

        static let cancelButtonShowHideAnimationDuration: TimeInterval = 0.25
        static let navigationBarTransitionHidingDelay: TimeInterval = 0.5

        static let defaultStyle: Style = .lightContent
    }

    open var cornerRadius: CGFloat = Constants.searchTextFieldCornerRadius {
        didSet {
            searchTextField.layer.cornerRadius = cornerRadius
        }
    }

    open var placeholderText: String? {
        didSet {
            attributePlaceholderText()
        }
    }

    open var style: Style = Constants.defaultStyle {
        didSet {
            updateColorsForStyle()
        }
    }

    /// Indicates when search bar either has focus or contains a search text.
    open private(set) var isActive: Bool = false

    open weak var delegate: MSSearchBarDelegate?

    weak var navigationController: MSNavigationController?

    //used to hide the cancelButton in non-active states
    private var searchTextFieldBackgroundViewTrailingConstraint: NSLayoutConstraint?
    private var cancelButtonTrailingConstraint: NSLayoutConstraint?

    private lazy var searchIconImageViewContainerView = UIView()

    //Leading-edge aligned Icon
    private lazy var searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.staticImageNamed("search-20x20")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    //user interaction point
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = Constants.searchTextFieldTextStyle.font
        textField.delegate = self
        textField.returnKeyType = .search
        textField.enablesReturnKeyAutomatically = true
        textField.accessibilityTraits = .searchField
        textField.addTarget(self, action: #selector(searchTextFieldValueDidChange(_:)), for: .editingChanged)
        return textField
    }()

    //a "searchTextField" in native iOS is comprised of an inset Magnifying Glass image followed by an inset textfield.
    //backgroundview is used to achive an inset textfield
    private lazy var searchTextFieldBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = style.backgroundColor
        backgroundView.layer.cornerRadius = Constants.searchTextFieldCornerRadius
        return backgroundView
    }()

    //removes text from the searchTextField
    private lazy var clearButton: UIButton = {
        let clearButton = UIButton()
        clearButton.addTarget(self, action: #selector(MSSearchBar.clearButtonTapped(sender:)), for: .touchUpInside)
        clearButton.setImage(UIImage.staticImageNamed("search-clear")?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.isHidden = true
        return clearButton
    }()

    //hidden when the textfield is not active
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Constants.cancelButtonTextStyle.font
        button.setTitle("Common.Cancel".localized, for: .normal)
        button.addTarget(self, action: #selector(MSSearchBar.cancelButtonTapped(sender:)), for: .touchUpInside)
        button.alpha = 0.0
        return button
    }()

    private var originalIsNavigationBarHidden: Bool = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        updateColorsForStyle()
        setupLayout()
    }

    private func startSearch() {
        if isActive {
            return
        }
        attributePlaceholderText()
        showCancelButton()
        originalIsNavigationBarHidden = navigationController?.isNavigationBarHidden ?? false
        // Using delayed async to work around a bug on iOS when it restores responder status for the text field when controller appears (due to navigation controller's pop action) even though text field resigned responder status before a detail controller was pushed
        let isTransitioning = navigationController?.transitionCoordinator != nil
        DispatchQueue.main.asyncAfter(deadline: .now() + (isTransitioning ? Constants.navigationBarTransitionHidingDelay : 0)) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        isActive = true
    }

    open func cancelSearch() {
        if !isActive {
            return
        }
        isActive = false
        searchTextField.resignFirstResponder()
        searchTextField.text = nil
        searchTextDidChange(shouldUpdateDelegate: false)
        delegate?.searchBarDidCancel(self)
        hideCancelButton()
        navigationController?.setNavigationBarHidden(originalIsNavigationBarHidden, animated: true)
    }

    private func attributePlaceholderText() {
        guard let newPlaceholder = placeholderText else {
            searchTextField.attributedPlaceholder = nil
            return
        }
        let newAttributes = [NSAttributedString.Key.foregroundColor: style.placeholderColor]
        let attributedPlaceholderText = NSAttributedString(string: newPlaceholder, attributes: newAttributes)
        searchTextField.attributedPlaceholder = attributedPlaceholderText
    }

    // MARK: - Layout Construction

    private func setupLayout() {
        //Autolayout is more efficent if all constraints are activated simultaneously
        var constraints = [NSLayoutConstraint]()

        //textfield background
        addSubview(searchTextFieldBackgroundView)
        searchTextFieldBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        searchTextFieldBackgroundView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        constraints.append(searchTextFieldBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor))
        constraints.append(searchTextFieldBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor))
        constraints.append(searchTextFieldBackgroundView.heightAnchor.constraint(equalToConstant: Constants.searchTextFieldBackgroundHeight))
        let searchTextFieldBackgroundViewTrailing = searchTextFieldBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        searchTextFieldBackgroundViewTrailingConstraint = searchTextFieldBackgroundViewTrailing
        constraints.append(searchTextFieldBackgroundViewTrailing)

        //search icon container
        searchTextFieldBackgroundView.addSubview(searchIconImageViewContainerView)
        searchIconImageViewContainerView.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(searchIconImageViewContainerView.leadingAnchor.constraint(equalTo: searchTextFieldBackgroundView.leadingAnchor, constant: Constants.searchIconInset))
        constraints.append(searchIconImageViewContainerView.widthAnchor.constraint(equalToConstant: Constants.searchIconImageViewDimension))
        constraints.append(searchIconImageViewContainerView.heightAnchor.constraint(equalTo: searchIconImageViewContainerView.widthAnchor))
        constraints.append(searchIconImageViewContainerView.centerYAnchor.constraint(equalTo: searchTextFieldBackgroundView.centerYAnchor))

        //search icon
        searchIconImageViewContainerView.addSubview(searchIconImageView)
        searchIconImageView.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(searchIconImageView.widthAnchor.constraint(equalToConstant: Constants.searchIconImageViewDimension))
        constraints.append(searchIconImageView.heightAnchor.constraint(equalToConstant: Constants.searchIconImageViewDimension))
        constraints.append(searchIconImageView.centerXAnchor.constraint(equalTo: searchIconImageViewContainerView.centerXAnchor))
        constraints.append(searchIconImageView.centerYAnchor.constraint(equalTo: searchIconImageViewContainerView.centerYAnchor))

        //search textfield
        searchTextFieldBackgroundView.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(searchTextField.leadingAnchor.constraint(equalTo: searchIconImageViewContainerView.trailingAnchor, constant: Constants.searchTextFieldLeadingInset))
        constraints.append(searchTextField.centerYAnchor.constraint(equalTo: searchTextFieldBackgroundView.centerYAnchor))
        constraints.append(searchTextField.heightAnchor.constraint(equalTo: searchTextFieldBackgroundView.heightAnchor, constant: -2 * Constants.searchTextFieldVerticalInset))

        //clearButton
        searchTextFieldBackgroundView.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false

        constraints.append(clearButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: Constants.clearButtonLeadingInset))
        constraints.append(clearButton.widthAnchor.constraint(equalToConstant: Constants.clearButtonWidth))
        constraints.append(clearButton.heightAnchor.constraint(equalTo: clearButton.widthAnchor))
        constraints.append(clearButton.trailingAnchor.constraint(equalTo: searchTextFieldBackgroundView.trailingAnchor, constant: -1 * Constants.clearButtonTrailingInset))
        constraints.append(clearButton.centerYAnchor.constraint(equalTo: searchTextFieldBackgroundView.centerYAnchor))

        //cancelButton
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

    private func updateColorsForStyle() {
        searchTextFieldBackgroundView.backgroundColor = style.backgroundColor
        searchIconImageView.tintColor = style.searchIconColor
        searchTextField.textColor = style.textColor
        searchTextField.tintColor = style.tintColor
        clearButton.tintColor = style.clearIconColor
        cancelButton.setTitleColor(style.cancelButtonColor, for: .normal)
        attributePlaceholderText()
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
        searchTextDidChange(shouldUpdateDelegate: true)
        _ = searchTextField.becomeFirstResponder()
    }

    // MARK: - Search Text Handling

    /// The string value of the search text field
    open var searchText: String? {
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

        let hasContent = newSearchText?.isEmpty == false

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
}

// MARK: - MSSearchBar: UITextFieldDelegate

extension MSSearchBar: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        startSearch()
        delegate?.searchBarDidBeginEditing(self)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarDidRequestSearch?(self)
        dismissKeyboard()
        return false
    }
}

// MARK: - UINavigationItem extension

extension UINavigationItem {
    var accessorySearchBar: MSSearchBar? { return accessoryView as? MSSearchBar }
}
