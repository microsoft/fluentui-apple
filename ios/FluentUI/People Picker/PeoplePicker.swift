//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: PeoplePickerDelegate

@available(*, deprecated, renamed: "PeoplePickerDelegate")
public typealias MSPeoplePickerDelegate = PeoplePickerDelegate

@objc(MSFPeoplePickerDelegate)
public protocol PeoplePickerDelegate: BadgeFieldDelegate {
    // Suggested personas
    /// Called when text is entered into the text field. Provides an opportunity to return a list of personas based on the entered text to populate the suggested list.
    @objc optional func peoplePicker(_ peoplePicker: PeoplePicker, getSuggestedPersonasForText text: String, completion: @escaping ((_ personas: [Persona]) -> Void))
    /// Determines whether or not the suggested persona should be picked. Called when selecting a persona from the suggested list or returning text from the text field.
    @objc optional func peoplePicker(_ peoplePicker: PeoplePicker, shouldPickPersona persona: Persona) -> Bool
    /// Called after `shouldPickPersona` when a persona is picked from the suggested list or when text is returned from the text field.
    @objc optional func peoplePicker(_ peoplePicker: PeoplePicker, didPickPersona persona: Persona)
    /// Called when text is returned from the text field. Opportunity to match entered text to a persona (e.g. from an email address) and return that persona to be picked.
    @objc optional func peoplePicker(_ peoplePicker: PeoplePicker, personaFromText text: String) -> Persona

    // Picked personas
    /// Determines whether or not the picked persona is "valid". If invalid the corresponding badge added to the badge field will display in an error state.
    @objc optional func peoplePicker(_ peoplePicker: PeoplePicker, personaIsValid persona: Persona) -> Bool
    /// Called when an already picked persona appearing as a badge in the badge field is selected.
    @objc optional func peoplePicker(_ peoplePicker: PeoplePicker, didSelectPersona persona: Persona)
    /// Called when an already selected and picked persona appearing as a badge in the badge field is tapped.
    @objc optional func peoplePicker(_ peoplePicker: PeoplePicker, didTapSelectedPersona persona: Persona)
    /// Called when a picked persona is removed from the badge field.
    @objc optional func peoplePicker(_ peoplePicker: PeoplePicker, didRemovePersona persona: Persona)

    // Search directory button
    /// Called when the search directory button is tapped.
    @objc optional func peoplePicker(_ peoplePicker: PeoplePicker, searchDirectoryWithCompletion completion: @escaping (_ personas: [Persona], _ success: Bool) -> Void)

    /// This is called to check if suggestions are to be hidden on textField endEditing event.
    /// If not implemented, the default value assumed is false.
    @objc optional func peoplePickerShouldKeepShowingPersonaSuggestionsOnEndEditing(_ peoplePicker: PeoplePicker) -> Bool

    /// Called when the PersonaListView is shown.
    @objc optional func peoplePickerDidShowPersonaSuggestions(_ peoplePicker: PeoplePicker)

    /// Called when the PersonaListView is hidden.
    @objc optional func peoplePickerDidHidePersonaSuggestions(_ peoplePicker: PeoplePicker)
}

// MARK: - PeoplePicker

@available(*, deprecated, renamed: "PeoplePicker")
public typealias MSPeoplePicker = PeoplePicker

/**
 `PeoplePicker` is used to select one or more personas from a list which is populated according to the text entered into its text field. Selected personas are added to a list of `pickedPersonas` and represented visually as "badges" which can be interacted with and removed.

 Set `availablePersonas` to provide a list of personas to filter from and populate the `suggestedPersonas` list which is shown in the persona list view based on the text field content provided. The delegate method `getSuggestedPersonasForText` can be used instead of filtering `availablePersonas` to provide custom filtering or calls to other services to return a list of `suggestedPersonas` to display in the persona list.

 The `suggestedPersonas` are shown in a list either above or below the control based on the position of `PeoplePicker` on screen. If more space is available below the text field than above it then the persona list view will be positioned below, if not it will be positioned above the control.
 */
@objc(MSFPeoplePicker)
open class PeoplePicker: BadgeField {
    private struct Constants {
        static let personaSuggestionsVerticalMargin: CGFloat = 8
    }

    /// Use `availablePersonas` to provide a list of personas that may be filtered and appear as `suggestedPersonas`in the persona list.
    @objc open var availablePersonas: [Persona] = [] {
        didSet {
            personaListView.personaList = availablePersonas
        }
    }

    /// Use `pickedPersonas` to provide a list of personas that have been picked. These personas are displayed as interactable badges next to the text field. When a persona from the persona list is picked it gets added here.
    @objc open var pickedPersonas: [Persona] = [] {
        didSet {
            updatePickedPersonaBadges()
        }
    }

    /// Set `showsSearchDirectoryButton` to determine whether or not to show the search directory button that appears at the bottom of the persona list.
    @objc open var showsSearchDirectoryButton: Bool = false {
        didSet {
            personaListView.showsSearchDirectoryButton = showsSearchDirectoryButton
        }
    }

    /**
     Set `allowsPickedPersonasToAppearAsSuggested` to false to remove personas from appearing in the suggested list if they have already been picked.
     Note: This property is disregarded if `getSuggestedPersonasForText` delegate method has been implemented.
     */
    @objc open var allowsPickedPersonasToAppearAsSuggested: Bool = true

    @objc open weak var delegate: PeoplePickerDelegate? {
        didSet {
            badgeFieldDelegate = delegate
        }
    }

    /// The UIView used to present 'suggestedPersonas'. It includes personaListView
    @objc public let personaSuggestionsView = UIView()

    /// The UITableView used to present 'availablePersonas'
    @objc public let personaListView = PersonaListView()

    /// The `suggestedPersonas` are personas that appear in the persona list that can be picked and added to `pickedPersonas`.
    private var suggestedPersonas: [Persona] = [] {
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

    private let separator = Separator()

    @objc public override init() {
        super.init()
        initialize()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
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
    /// - Parameter persona: The `Persona` to find the associated `BadgeView` for
    @objc open func badge(for persona: Persona) -> BadgeView? {
        return badges.first(where: {
            guard let personaBadgeDataSource = $0.dataSource as? PersonaBadgeViewDataSource else {
                assertionFailure("Badge dataSource is not of type PersonaBadgeViewDataSource")
                return false
            }
            return personaBadgeDataSource.persona.isEqual(to: persona)
        })
    }

    private func persona(for badge: BadgeView) -> Persona? {
        return pickedPersonas.first(where: {
            guard let personaBadgeDataSource = badge.dataSource as? PersonaBadgeViewDataSource else {
                assertionFailure("Badge dataSource is not of type PersonaBadgeViewDataSource")
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

    /// layouts personaSuggestionsView in available window frame
    @objc open func showPersonaSuggestions() {
        personaListView.contentOffset = .zero
        window?.addSubview(personaSuggestionsView)
        containingViewBoundsObservation = window?.observe(\.bounds) { [unowned self] (_, _) in
            self.layoutPersonaSuggestions()
        }

        personaListView.searchDirectoryState = .idle
        setNeedsLayout()
        layoutIfNeeded()
        delegate?.peoplePickerDidShowPersonaSuggestions?(self)
    }

    /// Hides personaSuggestionsView
    @objc open func hidePersonaSuggestions() {
        personaSuggestionsView.removeFromSuperview()
        containingViewBoundsObservation = nil
        delegate?.peoplePickerDidHidePersonaSuggestions?(self)
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

    private func shouldPick(persona: Persona) -> Bool {
        // Use `shouldPickPersona` delegate method if implemented, otherwise only pick persona if not already picked (checks for matching name and email).
        if let shouldPickPersonaFromDelegate = delegate?.peoplePicker?(self, shouldPickPersona: persona) {
            return shouldPickPersonaFromDelegate
        }
        return !pickedPersonas.contains(where: { $0.isEqual(to: persona) })
    }

    private func pickPersona(persona: Persona) {
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
            addBadge(withDataSource: PersonaBadgeViewDataSource(persona: $0))
        }
    }

    // MARK: Badges

    open override func badgeText() {
        super.badgeText()

        if textFieldContent == "" {
            resignFirstResponder()
            return
        }

        let persona = delegate?.peoplePicker?(self, personaFromText: textFieldContent) ?? PersonaData(name: textFieldContent)
        pickPersona(persona: persona)
    }

    open override func addBadge(withDataSource dataSource: BadgeViewDataSource, fromUserAction: Bool = false, updateConstrainedBadges: Bool = true) {
        super.addBadge(withDataSource: dataSource, fromUserAction: fromUserAction, updateConstrainedBadges: updateConstrainedBadges)
        guard let personaBadgeDataSource = dataSource as? PersonaBadgeViewDataSource else {
            assertionFailure("Badge dataSource is not of type PersonaBadgeViewDataSource")
            return
        }
        if fromUserAction {
            pickPersona(persona: personaBadgeDataSource.persona)
        }
    }

    override func addBadge(_ badge: BadgeView) {
        guard let personaBadgeDataSource = badge.dataSource as? PersonaBadgeViewDataSource else {
            assertionFailure("Badge dataSource is not of type PersonaBadgeViewDataSource")
            return
        }
        let isValid = delegate?.peoplePicker?(self, personaIsValid: personaBadgeDataSource.persona) ?? true
        personaBadgeDataSource.style = isValid ? .default : .error
        badge.reload()
        super.addBadge(badge)
    }

    override func deleteBadge(_ badge: BadgeView, fromUserAction: Bool, updateConstrainedBadges: Bool) {
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

    override func animateDraggedBadgeToBadgeField(_ destinationBadgeField: BadgeField) {
        guard let draggedBadge = draggedBadge,
            let personaBadgeDataSource = draggedBadge.dataSource as? PersonaBadgeViewDataSource,
            let destinationPeoplePicker = destinationBadgeField as? PeoplePicker else {
                assertionFailure("Badge dataSource is not of type PersonaBadgeViewDataSource or destination badge field is not of type PeoplePicker")
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
        let textFieldHasContent = !textFieldContent.isEmpty
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
        isShowingPersonaSuggestions = delegate?.peoplePickerShouldKeepShowingPersonaSuggestionsOnEndEditing?(self) ?? false
    }

    // MARK: Badge actions

    public override func didSelectBadge(_ badge: BadgeView) {
        super.didSelectBadge(badge)
        guard let personaBadgeDataSource = badge.dataSource as? PersonaBadgeViewDataSource else {
            assertionFailure("Badge dataSource is not of type PersonaBadgeViewDataSource")
            return
        }
        delegate?.peoplePicker?(self, didSelectPersona: personaBadgeDataSource.persona)
    }

    public override func didTapSelectedBadge(_ badge: BadgeView) {
        super.didTapSelectedBadge(badge)
        guard let personaBadgeDataSource = badge.dataSource as? PersonaBadgeViewDataSource else {
            assertionFailure("Badge dataSource is not of type PersonaBadgeViewDataSource")
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

// MARK: - PeoplePicker: PersonaListViewSearchDirectoryDelegate

extension PeoplePicker: PersonaListViewSearchDirectoryDelegate {
    public func personaListSearchDirectory(_ personaListView: PersonaListView, completion: @escaping (Bool) -> Void) {
        delegate?.peoplePicker?(self, searchDirectoryWithCompletion: { personas, success in
            self.suggestedPersonas = personas
            completion(success)
        })
    }
}
