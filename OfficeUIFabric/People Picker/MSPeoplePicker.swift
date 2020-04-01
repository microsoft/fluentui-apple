//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSPeoplePickerDelegate

@objc public protocol MSPeoplePickerDelegate: MSBadgeFieldDelegate {
    // Suggested personas
    /// Called when text is entered into the text field. Provides an opportunity to return a list of personas based on the entered text to populate the suggested list.
    @objc optional func peoplePicker(_ peoplePicker: MSPeoplePicker, getSuggestedPersonasForText text: String, completion: @escaping ((_ personas: [MSPersona]) -> Void))
    /// Determines whether or not the suggested persona should be picked. Called when selecting a persona from the suggested list or returning text from the text field.
    @objc optional func peoplePicker(_ peoplePicker: MSPeoplePicker, shouldPickPersona persona: MSPersona) -> Bool
    /// Called after `shouldPickPersona` when a persona is picked from the suggested list or when text is returned from the text field.
    @objc optional func peoplePicker(_ peoplePicker: MSPeoplePicker, didPickPersona persona: MSPersona)
    /// Called when text is returned from the text field. Opportunity to match entered text to a persona (e.g. from an email address) and return that persona to be picked.
    @objc optional func peoplePicker(_ peoplePicker: MSPeoplePicker, personaFromText text: String) -> MSPersona

    // Picked personas
    /// Determines whether or not the picked persona is "valid". If invalid the corresponding badge added to the badge field will display in an error state.
    @objc optional func peoplePicker(_ peoplePicker: MSPeoplePicker, personaIsValid persona: MSPersona) -> Bool
    /// Called when an already picked persona appearing as a badge in the badge field is selected.
    @objc optional func peoplePicker(_ peoplePicker: MSPeoplePicker, didSelectPersona persona: MSPersona)
    /// Called when an already selected and picked persona appearing as a badge in the badge field is tapped.
    @objc optional func peoplePicker(_ peoplePicker: MSPeoplePicker, didTapSelectedPersona persona: MSPersona)
    /// Called when a picked persona is removed from the badge field.
    @objc optional func peoplePicker(_ peoplePicker: MSPeoplePicker, didRemovePersona persona: MSPersona)

    // Search directory button
    /// Called when the search directory button is tapped.
    @objc optional func peoplePicker(_ peoplePicker: MSPeoplePicker, searchDirectoryWithCompletion completion: @escaping (_ personas: [MSPersona], _ success: Bool) -> Void)
}

// MARK: - MSPeoplePicker

/**
 `MSPeoplePicker` is used to select one or more personas from a list which is populated according to the text entered into its text field. Selected personas are added to a list of `pickedPersonas` and represented visually as "badges" which can be interacted with and removed.

 Set `availablePersonas` to provide a list of personas to filter from and populate the `suggestedPersonas` list which is shown in the persona list view based on the text field content provided. The delegate method `getSuggestedPersonasForText` can be used instead of filtering `availablePersonas` to provide custom filtering or calls to other services to return a list of `suggestedPersonas` to display in the persona list.

 The `suggestedPersonas` are shown in a list either above or below the control based on the position of `MSPeoplePicker` on screen. If more space is available below the text field than above it then the persona list view will be positioned below, if not it will be positioned above the control.
 */
@objcMembers
open class MSPeoplePicker: MSBadgeField {
    private struct Constants {
        static let personaSuggestionsVerticalMargin: CGFloat = 8
    }

    /// Use `availablePersonas` to provide a list of personas that may be filtered and appear as `suggestedPersonas`in the persona list.
    open var availablePersonas: [MSPersona] = [] {
        didSet {
            personaListView.personaList = availablePersonas
        }
    }

    /// Use `pickedPersonas` to provide a list of personas that have been picked. These personas are displayed as interactable badges next to the text field. When a persona from the persona list is picked it gets added here.
    open var pickedPersonas: [MSPersona] = [] {
        didSet {
            updatePickedPersonaBadges()
        }
    }

    /// Set `showsSearchDirectoryButton` to determine whether or not to show the search directory button that appears at the bottom of the persona list.
    open var showsSearchDirectoryButton: Bool = false {
        didSet {
            personaListView.showsSearchDirectoryButton = showsSearchDirectoryButton
        }
    }

    /**
     Set `allowsPickedPersonasToAppearAsSuggested` to false to remove personas from appearing in the suggested list if they have already been picked.
     Note: This property is disregarded if `getSuggestedPersonasForText` delegate method has been implemented.
     */
    open var allowsPickedPersonasToAppearAsSuggested: Bool = true

    open weak var delegate: MSPeoplePickerDelegate? {
        didSet {
            badgeFieldDelegate = delegate
        }
    }

    /// The `suggestedPersonas` are personas that appear in the persona list that can be picked and added to `pickedPersonas`.
    private var suggestedPersonas: [MSPersona] = [] {
        didSet {
            personaListView.personaList = suggestedPersonas
        }
    }

    private var isShowingPersonaSuggestions: Bool {
        get { return personaSuggestionsView.superview != nil }
        set {
            if isShowingPersonaSuggestions == newValue {
                return
            }
            if newValue {
                showPersonaSuggestions()
            } else {
                hidePersonaSuggestions()
            }
        }
    }

    private var keyboardHeight: CGFloat = 0

    private var containingViewBoundsObservation: NSKeyValueObservation?

    private let personaSuggestionsView = UIView()

    private let personaListView = MSPersonaListView()

    private let separator = MSSeparator()

    public override init() {
        super.init()
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        personaSuggestionsView.addSubview(personaListView)
        personaSuggestionsView.addSubview(separator)

        personaListView.onPersonaSelected = { [unowned self] persona in
            self.pickPersona(persona: persona)
        }
        personaListView.searchDirectoryDelegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// Returns the badge for the associated persona
    /// - Parameter persona: The `MSPersona` to find the associated `MSBadgeView` for
    open func badge(for persona: MSPersona) -> MSBadgeView? {
        return badges.first(where: {
            guard let personaBadgeDataSource = $0.dataSource as? MSPersonaBadgeViewDataSource else {
                assertionFailure("Badge dataSource is not of type MSPersonaBadgeViewDataSource")
                return false
            }
            return personaBadgeDataSource.persona.isEqual(to: persona)
        })
    }

    private func persona(for badge: MSBadgeView) -> MSPersona? {
        return pickedPersonas.first(where: {
            guard let personaBadgeDataSource = badge.dataSource as? MSPersonaBadgeViewDataSource else {
                assertionFailure("Badge dataSource is not of type MSPersonaBadgeViewDataSource")
                return false
            }
            return personaBadgeDataSource.persona.isEqual(to: $0)
        })
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        // Don't remove persona list on orientation change
        if !deviceOrientationIsChanging {
            isShowingPersonaSuggestions = false
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutPersonaSuggestions()
    }

    private func layoutPersonaSuggestions() {
        if !isShowingPersonaSuggestions {
            return
        }

        let position = superview?.convert(frame.origin, to: nil) ?? .zero
        let windowSize = window?.bounds.size ?? UIScreen.main.bounds.size

        let containingViewController = findContainingViewController()
        let containingViewFrame = containingViewController?.view.frame ?? CGRect(origin: .zero, size: windowSize)

        let personaSuggestionsX = containingViewController?.view.superview?.convert(containingViewFrame.origin, to: nil).x ?? 0
        let personaSuggestionsY: CGFloat
        let personaSuggestionsHeight: CGFloat
        let separatorY: CGFloat
        let statusBarHeight = window?.safeAreaInsets.top ?? 0
        // If the space below people picker to the keyboard is larger than the space above minus the status bar
        // then position the suggestions list below the people picker, otherwise position above
        if windowSize.height - (position.y + frame.height) - keyboardHeight > position.y - statusBarHeight {
            personaSuggestionsY = position.y + frame.height + Constants.personaSuggestionsVerticalMargin
            personaSuggestionsHeight = windowSize.height - personaSuggestionsY - keyboardHeight
            separatorY = 0
        } else {
            personaSuggestionsY = statusBarHeight
            personaSuggestionsHeight = position.y - personaSuggestionsY - Constants.personaSuggestionsVerticalMargin
            separatorY = personaSuggestionsHeight
        }

        personaSuggestionsView.frame = CGRect(x: personaSuggestionsX, y: personaSuggestionsY, width: containingViewFrame.width, height: personaSuggestionsHeight)

        personaListView.frame = personaSuggestionsView.bounds

        separator.frame = CGRect(x: 0, y: separatorY, width: personaSuggestionsView.frame.width, height: separator.frame.height)
    }

    // MARK: Personas

    private func showPersonaSuggestions() {
        personaListView.contentOffset = .zero
        window?.addSubview(personaSuggestionsView)
        containingViewBoundsObservation = window?.observe(\.bounds) { [unowned self] (_, _) in
            self.layoutPersonaSuggestions()
        }

        personaListView.searchDirectoryState = .idle

        setNeedsLayout()
    }

    private func hidePersonaSuggestions() {
        personaSuggestionsView.removeFromSuperview()
        containingViewBoundsObservation = nil
    }

    private func getSuggestedPersonas() {
        // Use `getSuggestedPersonasForText` delegate method if implemented, otherwise filter `availablePersonas` with `textFieldContent` and remove any personas that have already been picked (checks for matching name and email) if `allowPickedPersonasToAppearAsSuggested` is set to false.
        if delegate?.peoplePicker(_:getSuggestedPersonasForText:completion:) != nil {
            delegate?.peoplePicker?(self, getSuggestedPersonasForText: textFieldContent, completion: {
                self.suggestedPersonas = $0
            })
            return
        }

        var filteredPersonas = availablePersonas.filter { $0.name.lowercased().contains(textFieldContent.lowercased()) }
        if !allowsPickedPersonasToAppearAsSuggested {
            for pickedPersona in pickedPersonas {
                filteredPersonas = filteredPersonas.filter { !$0.isEqual(to: pickedPersona) }
            }
        }
        suggestedPersonas = filteredPersonas
    }

    private func shouldPick(persona: MSPersona) -> Bool {
        // Use `shouldPickPersona` delegate method if implemented, otherwise only pick persona if not already picked (checks for matching name and email).
        if let shouldPickPersonaFromDelegate = delegate?.peoplePicker?(self, shouldPickPersona: persona) {
            return shouldPickPersonaFromDelegate
        }
        return !pickedPersonas.contains(where: { $0.isEqual(to: persona) })
    }

    private func pickPersona(persona: MSPersona) {
        if !shouldPick(persona: persona) {
            resetTextFieldContent()
            return
        }

        pickedPersonas.append(persona)
        resetTextFieldContent()

        delegate?.peoplePicker?(self, didPickPersona: persona)
    }

    private func updatePickedPersonaBadges() {
        deleteAllBadges()
        pickedPersonas.forEach {
            addBadge(withDataSource: MSPersonaBadgeViewDataSource(persona: $0))
        }
    }

    // MARK: Badges

    open override func badgeText() {
        super.badgeText()

        if textFieldContent == "" {
            resignFirstResponder()
            return
        }

        let persona = delegate?.peoplePicker?(self, personaFromText: textFieldContent) ?? MSPersonaData(name: textFieldContent)
        pickPersona(persona: persona)
    }

    open override func addBadge(withDataSource dataSource: MSBadgeViewDataSource, fromUserAction: Bool = false, updateConstrainedBadges: Bool = true) {
        super.addBadge(withDataSource: dataSource, fromUserAction: fromUserAction, updateConstrainedBadges: updateConstrainedBadges)
        guard let personaBadgeDataSource = dataSource as? MSPersonaBadgeViewDataSource else {
            assertionFailure("Badge dataSource is not of type MSPersonaBadgeViewDataSource")
            return
        }
        if fromUserAction {
            pickPersona(persona: personaBadgeDataSource.persona)
        }
    }

    override func addBadge(_ badge: MSBadgeView) {
        guard let personaBadgeDataSource = badge.dataSource as? MSPersonaBadgeViewDataSource else {
            assertionFailure("Badge dataSource is not of type MSPersonaBadgeViewDataSource")
            return
        }
        let isValid = delegate?.peoplePicker?(self, personaIsValid: personaBadgeDataSource.persona) ?? true
        personaBadgeDataSource.style = isValid ? .default : .error
        badge.reload()
        super.addBadge(badge)
    }

    override func deleteBadge(_ badge: MSBadgeView, fromUserAction: Bool, updateConstrainedBadges: Bool) {
        // Need to find and delete the correct badge since badges can be removed and recreated in the case that a badge is successfully drag and dropped into a new picker. If there's text in the origin picker's textfield after a badge is dropped the text will become a badge and cause a removal and recreation of all badges and consequently a crash since the `badge` passed into this method cannot be found. The below ensures that we are deleting the correct badge in the current list of badges.
        if let persona = persona(for: badge), let badge = self.badge(for: persona), let index = pickedPersonas.firstIndex(where: { $0.isEqual(to: persona) }) {
            super.deleteBadge(badge, fromUserAction: fromUserAction, updateConstrainedBadges: updateConstrainedBadges)
            if fromUserAction {
                let persona = pickedPersonas[index]
                pickedPersonas.remove(at: index)
                delegate?.peoplePicker?(self, didRemovePersona: persona)
            }
        }
    }

    override func animateDraggedBadgeToBadgeField(_ destinationBadgeField: MSBadgeField) {
        guard let draggedBadge = draggedBadge,
            let personaBadgeDataSource = draggedBadge.dataSource as? MSPersonaBadgeViewDataSource,
            let destinationPeoplePicker = destinationBadgeField as? MSPeoplePicker else {
            assertionFailure("Badge dataSource is not of type MSPersonaBadgeViewDataSource or destination badge field is not of type MSPeoplePicker")
            return
        }
        if !destinationPeoplePicker.shouldPick(persona: personaBadgeDataSource.persona) {
            cancelBadgeDraggingIfNeeded()
            return
        }
        super.animateDraggedBadgeToBadgeField(destinationBadgeField)
    }

    // MARK: Text field

    override func textFieldTextChanged() {
        super.textFieldTextChanged()
        let textFieldHasContent = textFieldContent != ""
        isShowingPersonaSuggestions = textFieldHasContent
        if textFieldHasContent {
            getSuggestedPersonas()
        }
    }

    open override func resetTextFieldContent() {
        super.resetTextFieldContent()
        isShowingPersonaSuggestions = false
    }

    public override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        isShowingPersonaSuggestions = false
    }

    // MARK: Badge actions

    public override func didSelectBadge(_ badge: MSBadgeView) {
        super.didSelectBadge(badge)
        guard let personaBadgeDataSource = badge.dataSource as? MSPersonaBadgeViewDataSource else {
            assertionFailure("Badge dataSource is not of type MSPersonaBadgeViewDataSource")
            return
        }
        delegate?.peoplePicker?(self, didSelectPersona: personaBadgeDataSource.persona)
    }

    public override func didTapSelectedBadge(_ badge: MSBadgeView) {
        super.didTapSelectedBadge(badge)
        guard let personaBadgeDataSource = badge.dataSource as? MSPersonaBadgeViewDataSource else {
            assertionFailure("Badge dataSource is not of type MSPersonaBadgeViewDataSource")
            return
        }
        delegate?.peoplePicker?(self, didTapSelectedPersona: personaBadgeDataSource.persona)
    }

    // MARK: Keyboard notifications

    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                // Invalid keyboard notification
                return
        }
        keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: keyboardAnimationDuration, animations: layoutPersonaSuggestions)
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                // Invalid keyboard notification
                return
        }
        keyboardHeight = 0
        UIView.animate(withDuration: keyboardAnimationDuration, animations: layoutPersonaSuggestions)
    }
}

// MARK: - MSPeoplePicker: MSPersonaListViewSearchDirectoryDelegate

extension MSPeoplePicker: MSPersonaListViewSearchDirectoryDelegate {
    public func personaListSearchDirectory(_ personaListView: MSPersonaListView, completion: @escaping (Bool) -> Void) {
        delegate?.peoplePicker?(self, searchDirectoryWithCompletion: { personas, success in
            self.suggestedPersonas = personas
            completion(success)
        })
    }
}
