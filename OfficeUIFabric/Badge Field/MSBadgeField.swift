//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSBadgeFieldDelegate

@objc public protocol MSBadgeFieldDelegate: class {
    @objc func badgeField(_ badgeField: MSBadgeField, badgeDataSourceForText text: String) -> MSBadgeViewDataSource

    @objc optional func badgeField(_ badgeField: MSBadgeField, willChangeTextFieldContentWithText newText: String)
    @objc optional func badgeFieldDidChangeTextFieldContent(_ badgeField: MSBadgeField, isPaste: Bool)
    @objc optional func badgeField(_ badgeField: MSBadgeField, shouldBadgeText text: String, forSoftBadgingString badgingString: String) -> Bool
    /**
     `didAddBadge` and `didDeleteBadge` won't be called in the following case:
     add/delete were not triggered by a user action. In this case, handle the consequences of a add/delete after the external class called setupViewWithBadgeDataSources or addBadgeWithDataSource
     */
    @objc optional func badgeField(_ badgeField: MSBadgeField, didAddBadge badge: MSBadgeView)
    @objc optional func badgeField(_ badgeField: MSBadgeField, didDeleteBadge badge: MSBadgeView)
    /**
     `shouldAddBadgeForBadgeDataSource` defaults to true. Called only if the add results from a user action.
    */
    @objc optional func badgeField(_ badgeField: MSBadgeField, shouldAddBadgeForBadgeDataSource badgeDataSource: MSBadgeViewDataSource) -> Bool
    @objc optional func badgeField(_ badgeField: MSBadgeField, newBadgeForBadgeDataSource badgeDataSource: MSBadgeViewDataSource) -> MSBadgeView
    @objc optional func badgeField(_ badgeField: MSBadgeField, newMoreBadgeForBadgeDataSources badgeDataSources: [MSBadgeViewDataSource]) -> MSBadgeView
    @objc optional func badgeFieldContentHeightDidChange(_ badgeField: MSBadgeField)
    @objc optional func badgeField(_ badgeField: MSBadgeField, didTapSelectedBadge badge: MSBadgeView)
    @objc optional func badgeField(_ badgeField: MSBadgeField, shouldDragBadge badge: MSBadgeView) -> Bool // defaults to true
    /**
     `destinationBadgeField` is nil if the badge is animated back to its original field.
     `newBadge` is nil if the destination field returned false to `badgeField:shouldAddBadgeForBadgeDataSource` when the user dropped the badge.
     */
    @objc optional func badgeField(_ originbadgeField: MSBadgeField, didEndDraggingOriginBadge originBadge: MSBadgeView, toBadgeField destinationBadgeField: MSBadgeField?, withNewBadge newBadge: MSBadgeView?)
    @objc optional func badgeFieldShouldBeginEditing(_ badgeField: MSBadgeField) -> Bool
    @objc optional func badgeFieldDidBeginEditing(_ badgeField: MSBadgeField)
    @objc optional func badgeFieldDidEndEditing(_ badgeField: MSBadgeField)
    /**
     `badgeFieldShouldReturn` is called only when there's no text in the text field, otherwise `MSBadgeField` badges the text and doesn't call this.
     */
    @objc optional func badgeFieldShouldReturn(_ badgeField: MSBadgeField) -> Bool
}

// MARK: - MSBadgeField

/**
 MSBadgeField is a UIView that acts as a UITextField that can contains badges with enclosed text.
 It supports:
 * badge selection. Selection leaves the order of pills unchanged.
 * badge drag and drop between multiple MSBadgeFields
 * placeholder (hidden when text is not empty) or introduction text (not hidden when text is not empty)
 * custom input accessory view
 * max number of lines, with custom "+XX" badge to indicate badges that are not displayed
 * voiceover and dynamic text sizing
 */
open class MSBadgeField: UIView {
    private struct Constants {
        static let badgeHeight: CGFloat = 26
        static let badgeMarginHorizontal: CGFloat = 5
        static let badgeMarginVertical: CGFloat = 5
        static let emptyTextFieldString: String = zeroWidthSpace
        static let dragAndDropMinimumPressDuration: TimeInterval = 0.2
        static let dragAndDropScaleAnimationDuration: TimeInterval = 0.3
        static let dragAndDropScaleFactor: CGFloat = 1.10
        static let dragAndDropPositioningAnimationDuration: TimeInterval = 0.2
        static let labelMarginRight: CGFloat = 5
        static let textStyleFont: UIFont = MSTextStyle.subhead.font
        static let textFieldMinWidth: CGFloat = 100
        static let zeroWidthSpace: String = "\u{200B}"
    }

    open var label: String = "" {
        didSet {
            labelView.text = label
            updateLabelsVisibility()
            textField.accessibilityLabel = label
            setNeedsLayout()
        }
    }

    open var placeholder: String = "" {
        didSet {
            placeholderView.text = placeholder
            updateLabelsVisibility()
            textField.accessibilityLabel = placeholder
            setNeedsLayout()
        }
    }

    /**
     The max number of lines on which the badges should be laid out. If badges can't fit in the available number of lines, the textfield will add a `moreBadge` at the end of the last displayed line.
     Set numberOfLines to 0 to remove any limit for the number of lines.
     The default value is 0.
     Note: you should not use drag and drop with text fields that have a numberOfLines != 0. The resulting behavior is unknown.
     */
    @objc open var numberOfLines: Int = 0 {
        didSet {
            updateConstrainedBadges()
            updateBadgesVisibility()
            setNeedsLayout()
        }
    }

    /**
     Note: in non-editable mode, the user CAN select badges but CAN'T add, delete or drag badge views
     */
    @objc open var isEditable: Bool = true {
        didSet {
            if !isEditable {
                resignFirstResponder()
            }
            textField.isUserInteractionEnabled = isEditable
            selectedBadgeTextField.isUserInteractionEnabled = isEditable
        }
    }

    /**
     isEnabled is a proxy property that is transmitted to all the badge views. Badge views should have their style altered if this is true. But this is the decision of whoever implement a new badge view abstract class. Note that this does not change the touch handling behavior in any way.
     */
    @objc open var isEnabled: Bool = true {
        didSet {
            badges.forEach { $0.isEnabled = isEnabled }
            moreBadge?.isEnabled = isEnabled
        }
    }

    /**
     "Soft" means that the `badgeField` badges the text only under certain conditions.
     It's the delegate's responsibility to define these conditions, via `badgeField(_, shouldBadgeText:, forSoftBadgingString:)`
     */
    open var softBadgingCharacters: String = ""
    /**
     "Hard" means that the `badgeField` badges the text as soon as one of these character is used.
     */
    open var hardBadgingCharacters: String = ""

    @objc public private(set) var badges: [MSBadgeView] = []

    @objc public var badgeDataSources: [MSBadgeViewDataSource] { return badges.map { $0.dataSource! } }

    @objc public weak var delegate: MSBadgeFieldDelegate?

    private var cachedContentHeight: CGFloat = 0 {
        didSet {
            if cachedContentHeight != oldValue {
                delegate?.badgeFieldContentHeightDidChange?(self)
                invalidateIntrinsicContentSize()
            }
        }
    }

    /// Keeps a copy of the original numberOfLines when the text field begins editing
    private var originalNumberOfLines: Int = 0

    public init() {
        super.init(frame: .zero)
        backgroundColor = MSColors.background

        labelView.font = Constants.textStyleFont
        labelView.textColor = MSColors.BadgeField.label
        addSubview(labelView)

        placeholderView.font = Constants.textStyleFont
        placeholderView.textColor = MSColors.BadgeField.placeholder
        addSubview(placeholderView)

        updateLabelsVisibility()

        setupTextField(textField)
        resetTextFieldContent()
        addSubview(textField)

        setupTextField(selectedBadgeTextField)
        selectedBadgeTextField.delegate = self
        selectedBadgeTextField.frame = .zero
        selectedBadgeTextField.text = Constants.emptyTextFieldString
        addSubview(selectedBadgeTextField)

        setupDraggingWindow()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBadgeFieldTapped(_:)))
        addGestureRecognizer(tapGesture)

        textField.addTarget(self, action: #selector(handleTextFieldTextChanged), for: .editingChanged)
        textField.addObserver(self, forKeyPath: #keyPath(UITextField.selectedTextRange), options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)

        // An accessible container must set isAccessibilityElement to false
        isAccessibilityElement = false
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        textField.removeObserver(self, forKeyPath: #keyPath(UITextField.selectedTextRange), context: nil)
    }

    /**
     Sets up the view using the badge data sources.
     */
    open func setup(dataSources: [MSBadgeViewDataSource]) {
        for badge in badges {
            badge.removeFromSuperview()
        }
        badges.removeAll()
        selectedBadge = nil
        resetTextFieldContent()
        for dataSource in dataSources {
            addBadge(withDataSource: dataSource, updateConstrainedBadges: false)
        }
        setNeedsLayout()
    }

    /**
     Updates the view using existing data sources. This is a bit of a hack since it's better to assume `MSBadgeViewDataSource` is immutable, but this is necessary to update badge style without losing the current state.
     */
    open func reload() {
        badges.forEach { $0.reload() }
        setNeedsLayout()
    }

    private func setupTextField(_ textField: UITextField) {
        textField.font = Constants.textStyleFont
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.delegate = self
    }

    private func setupDraggingWindow() {
        // The dragging window must be on top of any other window (keyboard, status bar etc.)
        draggingWindow.windowLevel = UIWindow.Level(rawValue: .greatestFiniteMagnitude)
        draggingWindow.backgroundColor = .clear
        draggingWindow.isHidden = true
    }

    // MARK: Layout

    open override func layoutSubviews() {
        super.layoutSubviews()

        // `constrainedBadges` depends on the view width, so we should update it on each width change
        updateConstrainedBadges()

        let contentHeight = self.contentHeight(forBoundingWidth: bounds.width)
        // Give the view controller a chance to relayout itself if necessary
        cachedContentHeight = contentHeight
        let topMargin = UIScreen.main.middleOrigin(height, containedSizeValue: contentHeight)

        labelView.frame = CGRect(x: 0, y: topMargin, width: labelViewWidth, height: Constants.badgeHeight)

        var left = labelViewRightOffset
        var lineIndex = 0

        for (index, badge) in currentBadges.enumerated() {
            // Don't layout the dragged badge
            if badge == draggedBadge {
                continue
            }
            badge.frame = calculateBadgeFrame(badge: badge, badgeIndex: index, lineIndex: &lineIndex, left: &left, topMargin: topMargin, boundingWidth: bounds.width)
        }

        let textFieldSize = textField.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let textFieldHeight = UIScreen.main.roundToDevicePixels(textFieldSize.height)
        let textFieldVerticalOffset = UIScreen.main.middleOrigin(Constants.badgeHeight, containedSizeValue: textFieldHeight)
        let shouldAppendToCurrentLine = left + Constants.textFieldMinWidth <= width
        if !shouldAppendToCurrentLine {
            lineIndex += 1
            left = 0
        }
        textField.frame = CGRect(
            x: left,
            y: topMargin + offsetForLine(at: lineIndex) + textFieldVerticalOffset,
            width: width - left,
            height: textFieldHeight
        )

        placeholderView.frame = CGRect(x: 0, y: topMargin, width: width, height: Constants.badgeHeight)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: contentHeight(forBoundingWidth: size.width))
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: contentHeight(forBoundingWidth: width))
    }

    private func updateConstrainedBadges() {
        // Remove previous moreBadge
        moreBadge?.removeFromSuperview()
        constrainedBadges.removeAll()
        // No max number of lines, no need to compute these badges
        if !shouldUseConstrainedBadges {
            return
        }
        // Loop on all badges
        var left = labelViewRightOffset
        var lineIndex = 0
        for (index, badge) in badges.enumerated() {
            let (shouldBreak, newLeft, newLineIndex) = addNextBadge(badge, badgeIndex: index, currentLeft: left, currentLineIndex: lineIndex)
            if shouldBreak {
                break
            }
            left = newLeft
            lineIndex = newLineIndex
        }
        updateBadgesVisibility()
    }

    private func addNextBadge(_ badge: MSBadgeView, badgeIndex: Int, currentLeft: CGFloat, currentLineIndex: Int) -> (Bool, CGFloat, Int) {
        let isLastDisplayedLine = currentLineIndex == numberOfLines - 1
        let isFirstBadge = badgeIndex == 0
        let isFirstBadgeOfCurrentLine = isFirstBadge || currentLeft == 0

        var moreBadgeOffset: CGFloat = 0
        let moreBadges = badges[(badgeIndex + 1)...]
        if !moreBadges.isEmpty {
            let moreBadgesDataSources = moreBadges.compactMap { $0.dataSource }
            let moreBadge = createMoreBadge(withDataSources: moreBadgesDataSources)
            moreBadgeOffset = Constants.badgeMarginHorizontal + width(forBadge: moreBadge,
                                                                          isFirstBadge: false,
                                                                          isFirstBadgeOfLastDisplayedLine: false,
                                                                          moreBadgeOffset: 0,
                                                                          boundingWidth: width)
        }

        let badgeWidth = width(forBadge: badge,
                               isFirstBadge: isFirstBadge,
                               isFirstBadgeOfLastDisplayedLine: isFirstBadgeOfCurrentLine,
                               moreBadgeOffset: moreBadgeOffset,
                               boundingWidth: width)
        let enoughSpaceAvailable = currentLeft + badgeWidth + moreBadgeOffset <= width
        let shouldAppend = isFirstBadgeOfCurrentLine || enoughSpaceAvailable
        if !shouldAppend {
            if isLastDisplayedLine {
                // No space for both badge and "+X" badge: Add "+X+1" badge instead (if needed)
                let moreBadges = badges[badgeIndex...]
                if !moreBadges.isEmpty {
                    let moreBadgesDataSources = moreBadges.compactMap { $0.dataSource }
                    let moreBadge = createMoreBadge(withDataSources: moreBadgesDataSources)
                    self.moreBadge = moreBadge
                    constrainedBadges.append(moreBadge)
                    addSubview(moreBadge)
                }
                // Stop adding badges (we don't care about returning correct newCurrentLeft and newCurrentLineIndex here)
                return (true, 0, 0)
            } else {
                return addNextBadge(badge, badgeIndex: badgeIndex, currentLeft: 0, currentLineIndex: currentLineIndex + 1)
            }
        }
        // Badge should be appended on current line: append and keep looping on following badges
        constrainedBadges.append(badge)
        return (false, currentLeft + badgeWidth + Constants.badgeMarginHorizontal, currentLineIndex)
    }

    private func frameForBadge(_ badgeToInsert: MSBadgeView, boundingWidth: CGFloat) -> CGRect {
        let badges = currentBadges
        let contentHeight = self.contentHeight(forBoundingWidth: bounds.width)
        let topMargin = UIScreen.main.middleOrigin(height, containedSizeValue: contentHeight)
        var left = labelViewRightOffset
        var lineIndex = 0

        for (index, badge) in badges.enumerated() {
            let frame = calculateBadgeFrame(badge: badge, badgeIndex: index, lineIndex: &lineIndex, left: &left, topMargin: topMargin, boundingWidth: boundingWidth)
            if badge == badgeToInsert {
                return frame
            }
        }
        // Unknown badge label: return the frame that the badge would have if it was added to this field
        return calculateBadgeFrame(badge: badgeToInsert, badgeIndex: badges.count, lineIndex: &lineIndex, left: &left, topMargin: topMargin, boundingWidth: boundingWidth)
    }

    /**
     Use this method if you don't know yet which moreBadge should be added, typically if you're computing the badges that should be displayed when a constrained number of lines is set.
     */
    private func width(forBadge badge: MSBadgeView, isFirstBadge: Bool, isFirstBadgeOfLastDisplayedLine: Bool, moreBadgeOffset: CGFloat = -1, boundingWidth: CGFloat) -> CGFloat {
        let badgeFittingSize = badge.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let badgeFittingWidth = UIScreen.main.roundToDevicePixels(badgeFittingSize.width)
        var badgeMaxWidth = boundingWidth
        // First badge: remove the size taken by the introduction label
        if isFirstBadge {
            badgeMaxWidth -= labelViewRightOffset
        }
        // First badge of last displayed line: remove the space taken by the moreBadge
        if isFirstBadgeOfLastDisplayedLine {
            badgeMaxWidth -= moreBadgeOffset == -1 ? calculateMoreBadgeOffset() : moreBadgeOffset
        }
        return min(badgeMaxWidth, badgeFittingWidth)
    }

    private func calculateMoreBadgeOffset() -> CGFloat {
        if shouldUseConstrainedBadges, let moreBadge = moreBadge {
            let moreBadgeSize = moreBadge.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            let moreBadgeWidth = UIScreen.main.roundToDevicePixels(moreBadgeSize.width)
            return moreBadgeWidth + Constants.badgeMarginHorizontal
        } else {
            return 0
        }
    }

    open func heightThatFits(numberOfLines: Int) -> CGFloat {
        // Vertical margin not applicable to top line
        let heightForAllLines = CGFloat(numberOfLines) * (Constants.badgeHeight + Constants.badgeMarginVertical)
        return heightForAllLines - Constants.badgeMarginVertical
    }

    private func contentHeight(forBoundingWidth boundingWidth: CGFloat) -> CGFloat {
        var left = labelViewRightOffset
        var lineIndex = 0

        for (index, badge) in currentBadges.enumerated() {
            calculateBadgeFrame(badge: badge, badgeIndex: index, lineIndex: &lineIndex, left: &left, topMargin: 0, boundingWidth: bounds.width)
        }

        if isEditable && isFirstResponder && left + Constants.textFieldMinWidth > boundingWidth {
            lineIndex += 1
        }
        let textFieldSize = textField.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let textFieldHeight = UIScreen.main.roundToDevicePixels(textFieldSize.height)
        let contentHeight = heightThatFits(numberOfLines: lineIndex + 1)
        return max(textFieldHeight, contentHeight)
    }

    @discardableResult
    private func calculateBadgeFrame(badge: MSBadgeView, badgeIndex: Int, lineIndex: inout Int, left: inout CGFloat, topMargin: CGFloat, boundingWidth: CGFloat) -> CGRect {
        let isFirstBadge = badgeIndex == 0
        let isFirstBadgeOfCurrentLine = isFirstBadge || left == 0
        let isLastDisplayedLine = shouldUseConstrainedBadges && lineIndex == numberOfLines - 1
        let badgeWidth = width(forBadge: badge,
                               isFirstBadge: isFirstBadge,
                               isFirstBadgeOfLastDisplayedLine: isFirstBadgeOfCurrentLine && isLastDisplayedLine,
                               boundingWidth: boundingWidth)
        // Not enough space on current line
        let enoughSpaceAvailableOnCurrentLine = left + badgeWidth <= width
        let shouldAppendToCurrentLine = isFirstBadgeOfCurrentLine || enoughSpaceAvailableOnCurrentLine
        if !shouldAppendToCurrentLine {
            lineIndex += 1
            left = 0
            // Badge width may change to accomodate `moreBadge`, recursively layout
            return calculateBadgeFrame(badge: badge, badgeIndex: badgeIndex, lineIndex: &lineIndex, left: &left, topMargin: topMargin, boundingWidth: boundingWidth)
        }

        let badgeFrame = CGRect(x: left, y: topMargin + offsetForLine(at: lineIndex), width: badgeWidth, height: Constants.badgeHeight)

        left += badgeWidth + Constants.badgeMarginHorizontal

        return badgeFrame
    }

    private func offsetForLine(at lineIndex: Int) -> CGFloat {
        return CGFloat(lineIndex) * (Constants.badgeHeight + Constants.badgeMarginVertical)
    }

    // MARK: Badges

    private var badgingCharacters: String { return softBadgingCharacters + hardBadgingCharacters }

    /**
     The approach taken to handle the numberOfLines feature is to have a separate set of badges. It might look like this choice implies some code duplication, however this feature is almost only about layout (except the moreBadge). Handling numberOfLines directly in the layout process would lead to even more duplication: layoutSubviews, contentHeightForBoundingWidth and frameForBadge. This approach isolates the complexity of numberOfLines in a single method: updateConstrainedBadges that we have to call in the appropriate places.
     */
    private var constrainedBadges: [MSBadgeView] = []

    private var currentBadges: [MSBadgeView] { return shouldUseConstrainedBadges ? constrainedBadges : badges }

    private var shouldUseConstrainedBadges: Bool { return numberOfLines != 0 }

    /**
     This badge is added to the end of the last displayed line if all the badges don't fit in the numberOfLines. It will look like "+5", for example, to indicate the number of badges that are not being displayed.
     */
    private var moreBadge: MSBadgeView? {
        didSet {
            if let moreBadge = moreBadge {
                moreBadge.delegate = self
                moreBadge.isEnabled = isEnabled
                moreBadge.isUserInteractionEnabled = false
            }
        }
    }

    private var selectedBadge: MSBadgeView? {
        didSet {
            if selectedBadge == oldValue {
                return
            }
            oldValue?.isSelected = false
            selectedBadge?.isSelected = true
        }
    }

    private var draggedBadge: MSBadgeView?
    private var draggedBadgeTouchCenterOffset: CGPoint?
    private var draggingWindow = UIWindow()

    /// Shows all badges when text field starts editing and resorts back to constrained badges (if originalNumberOfLines > 0) when editing ends
    private var showAllBadgesForEditing: Bool = false {
        didSet {
            if showAllBadgesForEditing {
                originalNumberOfLines = numberOfLines
            }
            numberOfLines = showAllBadgesForEditing ? 0 : originalNumberOfLines
        }
    }

    /// Badges the current text field content
    @objc open func badgeText() {
        badgeText(textFieldContent, force: true)
    }

    // For performance reasons, addBadges:withDataSources should be used when multiple badges must be added
    @objc open func addBadges(withDataSources dataSources: [MSBadgeViewDataSource]) {
        for dataSource in dataSources {
            addBadge(withDataSource: dataSource, updateConstrainedBadges: false)
        }
        updateConstrainedBadges()
    }

    @objc open func addBadge(withDataSource dataSource: MSBadgeViewDataSource, fromUserAction: Bool = false, updateConstrainedBadges: Bool = true) {
        guard let delegate = delegate else {
            assertionFailure("Missing delegate in addBadge:withDataSource")
            return
        }

        let badge = createBadge(withDataSource: dataSource)

        addBadge(badge)
        updateLabelsVisibility()
        selectedBadge = nil

        if updateConstrainedBadges {
            self.updateConstrainedBadges()
        }

        setNeedsLayout()

        if fromUserAction {
            delegate.badgeField?(self, didAddBadge: badge)
        }
    }

    @objc open func deleteBadges(withDataSource dataSource: MSBadgeViewDataSource) {
        badges.forEach { badge in
            if badge.dataSource == dataSource {
                deleteBadge(badge, fromUserAction: false, updateConstrainedBadges: false)
            }
        }
        updateConstrainedBadges()
    }

    open func deleteAllBadges() {
        deleteAllBadges(fromUserAction: false)
    }

    @objc open func selectBadge(_ badge: MSBadgeView) {
        // Do nothing if badge already selected
        if selectedBadge == badge {
            return
        }
        selectedBadge = badge
        selectedBadgeTextField.becomeFirstResponder()
    }

    private func addBadge(_ badge: MSBadgeView) {
        badge.delegate = self
        badge.isEnabled = isEnabled
        badges.append(badge)
        addSubview(badge)
        // Configure drag gesture
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        longPressGestureRecognizer.minimumPressDuration = Constants.dragAndDropMinimumPressDuration
        badge.addGestureRecognizer(longPressGestureRecognizer)
    }

    @discardableResult
    private func badgeText(_ text: String, force forceBadge: Bool) -> Bool {
        guard let delegate = delegate else {
            assertionFailure("Missing delegate in badgeText:withText")
            return false
        }

        if text.isEmpty {
            return false
        }

        let badgeStrings = extractBadgeStrings(from: text, badgingCharacters: badgingCharacters, hardBadgingCharacters: hardBadgingCharacters, forceBadge: forceBadge, shouldBadge: { (badgeString, softBadgingString) -> Bool in
            return delegate.badgeField?(self, shouldBadgeText: badgeString, forSoftBadgingString: softBadgingString) ?? true
        })

        var didBadge = false

        // Add badges
        for badgeString in badgeStrings {
            // Append badge if needed
            let badgeDataSource = delegate.badgeField(self, badgeDataSourceForText: badgeString)
            if shouldAddBadge(forBadgeDataSource: badgeDataSource) {
                addBadge(withDataSource: badgeDataSource, fromUserAction: true, updateConstrainedBadges: true)
            }
            // Consider that we badge even if the delegate prevented via `shouldAddBadgeForBadgeDataSource`
            didBadge = true
        }

        if didBadge {
            resetTextFieldContent()
        }

        setNeedsLayout()

        return didBadge
    }

    private func createBadge(withDataSource dataSource: MSBadgeViewDataSource) -> MSBadgeView {
        var badge: MSBadgeView
        if let badgeFromDelegate = delegate?.badgeField?(self, newBadgeForBadgeDataSource: dataSource) {
            badge = badgeFromDelegate
        } else {
            badge = MSBadgeView()
            badge.dataSource = dataSource
        }

        return badge
    }

    private func createMoreBadge(withDataSources dataSources: [MSBadgeViewDataSource]) -> MSBadgeView {
        // If no delegate, fallback to default "+X" moreBadge
        var moreBadge: MSBadgeView
        if let moreBadgeFromDelegate = delegate?.badgeField?(self, newMoreBadgeForBadgeDataSources: dataSources) {
            moreBadge = moreBadgeFromDelegate
        } else {
            moreBadge = MSBadgeView()
            moreBadge.dataSource = MSBadgeViewDataSource(text: "+\(dataSources.count)", style: .default)
        }

        return moreBadge
    }

    private func deleteAllBadges(fromUserAction: Bool) {
        let badgesCopy = badges
        for badge in badgesCopy {
            deleteBadge(badge, fromUserAction: fromUserAction, updateConstrainedBadges: false)
        }
        updateConstrainedBadges()
        selectedBadge = nil
    }

    private func deleteBadge(_ badge: MSBadgeView, fromUserAction: Bool, updateConstrainedBadges: Bool) {
        badge.removeFromSuperview()
        badges.remove(at: badges.index(of: badge)!)

        if updateConstrainedBadges {
            self.updateConstrainedBadges()
        }

        updateLabelsVisibility()

        if fromUserAction {
            delegate?.badgeField?(self, didDeleteBadge: badge)
        }
    }

    private func deleteSelectedBadge(fromUserAction: Bool) {
        if let selectedBadge = selectedBadge {
            deleteBadge(selectedBadge, fromUserAction: fromUserAction, updateConstrainedBadges: true)
            self.selectedBadge = nil
        }
    }

    private func badgeWithEqualDataSource(_ dataSource: MSBadgeViewDataSource) -> MSBadgeView? {
        return badges.first(where: { $0.dataSource?.isEqual(dataSource) == true })
    }

    private func shouldAddBadge(forBadgeDataSource dataSource: MSBadgeViewDataSource) -> Bool {
        return delegate?.badgeField?(self, shouldAddBadgeForBadgeDataSource: dataSource) ?? true
    }

    private func updateBadgesVisibility() {
        badges.forEach { $0.isHidden = shouldUseConstrainedBadges }
        constrainedBadges.forEach { $0.isHidden = !shouldUseConstrainedBadges }
        moreBadge?.isHidden = !shouldUseConstrainedBadges
    }

    // MARK: Text field

    @objc open var textFieldContent: String {
        return textField.text!.trimmed()
    }

    @objc open func resetTextFieldContent() {
        textField.text = Constants.emptyTextFieldString
    }

    private let textField = PasteControlTextField()

    /**
     The approach taken with selectedBadgeTextField is to use an alternate UITextField, invisible to the user, to handle all the actions that are related to the existing badges.
     */
    private let selectedBadgeTextField = UITextField()

    private var switchingTextFieldResponders: Bool = false

    // MARK: Label view and placeholder view

    private let labelView = UILabel()
    private let placeholderView = UILabel()

    private var labelViewRightOffset: CGFloat {
        return labelView.isHidden ? 0 : labelViewWidth + Constants.labelMarginRight
    }

    private var labelViewWidth: CGFloat {
        if labelView.isHidden {
            return 0
        }
        let labelSize = labelView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return UIScreen.main.roundToDevicePixels(labelSize.width)
    }

    private func updateLabelsVisibility(textFieldContent: String? = nil) {
        let textFieldContent = textFieldContent ?? self.textFieldContent
        labelView.isHidden = label.isEmpty
        placeholderView.isHidden = !labelView.isHidden || !badges.isEmpty || !textFieldContent.isEmpty
        setNeedsLayout()
    }

    // MARK: Gestures

    @objc func handleBadgeFieldTapped(_ recognizer: UITapGestureRecognizer) {
        let tapPoint = recognizer.location(in: self)
        let tappedView = hitTest(tapPoint, with: nil)

        if tappedView == self {
            selectedBadge = nil
            textField.becomeFirstResponder()
        }
    }

    // MARK: UIResponder

    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    open override var isFirstResponder: Bool {
        return textField.isFirstResponder || selectedBadgeTextField.isFirstResponder
    }

    @discardableResult
    open override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder() || selectedBadgeTextField.resignFirstResponder()
    }

    // MARK: Observations

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == #keyPath(UITextField.selectedTextRange), object as? UITextField == textField else {
            return
        }

        // Invalid change
        guard let newSelectedTextRange = change?[NSKeyValueChangeKey.newKey] as? UITextRange else {
            return
        }

        // Prevent selection to be before or to include zero width space
        let startTextPositionValue = textField.offset(from: textField.beginningOfDocument, to: newSelectedTextRange.start)
        if startTextPositionValue == 0 {
            if let afterEmptySpaceTextPosition = textField.position(from: newSelectedTextRange.start, in: .right, offset: 1) {
                let afterEmptySpaceTextRange = textField.textRange(from: afterEmptySpaceTextPosition, to: newSelectedTextRange.end)
                textField.selectedTextRange = afterEmptySpaceTextRange
            }
        }
    }

    @objc private func handleTextFieldTextChanged() {
        delegate?.badgeFieldDidChangeTextFieldContent?(self, isPaste: textField.isPaste)
        textField.isPaste = false
    }

    @objc private func handleOrientationChanged() {
        // Hack: to avoid properly handling rotations for the dragging window (which is annoying and overkill for this feature), let's just reset the dragging window
        resetDraggingWindow()
    }

    // MARK: Accessibility

    open override func accessibilityElementCount() -> Int {
        var elementsCount = 0
        if isIntroductionLabelAccessible() {
            elementsCount += 1
        }
        elementsCount += badges.count
        elementsCount += 1
        return elementsCount
    }

    open override func accessibilityElement(at index: Int) -> Any? {
        if isIntroductionLabelAccessible() && index == 0 {
            return labelView
        }
        let offsetIndex = isIntroductionLabelAccessible() ? index - 1 : index
        if offsetIndex < badges.count {
            return badges[offsetIndex]
        }
        return textField
    }

    open override func index(ofAccessibilityElement element: Any) -> Int {
        if element as? UILabel == labelView {
            return 0
        }
        if let badge = element as? MSBadgeView, let index = badges.index(of: badge) {
             return isIntroductionLabelAccessible() ? index + 1 : index
        }
        return accessibilityElementCount() - 1
    }

    private func isIntroductionLabelAccessible() -> Bool {
        // No badge: introduction will be read as part of the text field
        if badges.isEmpty {
            return false
        }
        // No introduction
        if labelView.isHidden || label.isEmpty {
            return false
        }
        return true
    }

    @objc public func voiceOverFocusOnTextFieldAndAnnounce(_ announcement: String?) {
        guard let announcement = announcement, !announcement.isEmpty else {
            UIAccessibility.post(notification: .screenChanged, argument: textField)
            return
        }

        let previousAccessibilityLabel = textField.accessibilityLabel
        // Update the accessibilityLabel to include the desired announcement
        textField.accessibilityLabel = "\(announcement). \(previousAccessibilityLabel ?? "")"
        UIAccessibility.post(notification: .screenChanged, argument: textField)
        // Reset the accessibility to the proper label
        // Allow the label to get reset on a delay so the notification has time to fire before it changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.textField.accessibilityLabel = previousAccessibilityLabel
        }
    }

    // MARK: Drag and drop

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        // Invalid window (happens when the compose screen is not on screen)
        guard let containingWindow = window else {
            return
        }

        // Was not first responder, check if we should begin editing
        if !isFirstResponder && delegate?.badgeFieldShouldBeginEditing?(self) == false {
            cancelRunningGesture(gesture)
            return
        }

        let draggedBadge = gesture.view as! MSBadgeView
        switch gesture.state {
        case .began:
            // Already dragging another badge: cancel this new gesture
            if !draggingWindow.isHidden {
                cancelRunningGesture(gesture)
                return
            }
            // Select badge
            selectBadge(draggedBadge)
            // Not editable: cancel running gesture
            if !isEditable {
                cancelRunningGesture(gesture)
                return
            }
            // Drag and drop disabled: cancel running gesture
            let shouldDragBadge = delegate?.badgeField?(self, shouldDragBadge: draggedBadge) ?? true
            if !shouldDragBadge {
                cancelRunningGesture(gesture)
                return
            }
            // Start dragging
            startDraggingBadge(draggedBadge, gestureRecognizer: gesture)
        case .changed:
            // Change draggedBadge to position of drag
            let position = gesture.location(in: containingWindow)
            let centerOffset = draggedBadgeTouchCenterOffset ?? .zero
            draggedBadge.center = CGPoint(x: position.x - centerOffset.x, y: position.y - centerOffset.y)
        case .ended:
            // Find field under gesture end location
            let hitBadgeField: MSBadgeField?
            if let hitView = containingWindow.hitTest(gesture.location(in: containingWindow), with: nil) {
                hitBadgeField = hitView as? MSBadgeField ?? hitView.findSuperview(of: MSBadgeField.self) as? MSBadgeField
            } else {
                hitBadgeField = nil
            }
            // Animate to hovered field or hovered view is not a field or is the original field so animate badge back to origin
            if let hoveredBadgeField = hitBadgeField, hoveredBadgeField != self {
                animateDraggedBadgeToBadgeField(hoveredBadgeField)
            } else {
                moveDraggedBadgeBackToOriginalPosition(animated: true)
            }
        default:
            // Cancelled or failed
            moveDraggedBadgeBackToOriginalPosition(animated: false)
        }
    }

    private func startDraggingBadge(_ badge: MSBadgeView, gestureRecognizer: UIGestureRecognizer) {
        guard let containingWindow = window else {
            return
        }
        // Already dragging badge
        if draggedBadge == badge {
            return
        }
        draggedBadge = badge
        // Dragging badge offset
        let touchLocation = gestureRecognizer.location(in: badge)
        draggedBadgeTouchCenterOffset = CGPoint(x: round(touchLocation.x - badge.width / 2), y: round(touchLocation.y - badge.height / 2))
        // Dragging window becomes front window
        draggingWindow.isHidden = false
        // Move dragged badge to main window
        draggedBadge!.frame = convert(draggedBadge!.frame, to: containingWindow)
        draggingWindow.addSubview(draggedBadge!)
        // Animate scale
        UIView.animate(withDuration: Constants.dragAndDropScaleAnimationDuration) {
            self.draggedBadge!.layer.transform = CATransform3DMakeScale(Constants.dragAndDropScaleFactor, Constants.dragAndDropScaleFactor, 1)
        }
    }

    private func moveDraggedBadgeBackToOriginalPosition(animated: Bool) {
        // Invalid window (happens when the compose screen is not on screen)
        guard let containingWindow = window else {
            return
        }
        // "Cache" dragged badge (because we reset it below but we still need pointer to it)
        guard let draggedBadge = self.draggedBadge else {
            return
        }
        // Compute original position
        let destinationFrameInSelf = frameForBadge(draggedBadge, boundingWidth: width)
        let destinationFrameInWindow = convert(destinationFrameInSelf, to: containingWindow)
        // Move to original position
        let moveBadgeToOriginalPosition = {
            draggedBadge.layer.transform = CATransform3DIdentity
            draggedBadge.frame = destinationFrameInWindow
        }
        // Move to original field
        let moveBadgeToOriginalTextField = {
            self.addSubview(draggedBadge)
            self.draggedBadge = nil
            self.setNeedsLayout()
        }

        if animated {
            UIView.animate(withDuration: Constants.dragAndDropPositioningAnimationDuration, delay: 0.0, options: .beginFromCurrentState, animations: {
                moveBadgeToOriginalPosition()
            }, completion: { _ in
                moveBadgeToOriginalTextField()
                // Reset dragging window: need to execute this after a delay to avoid blinking
                self.perform(#selector(self.hideDraggingWindow), with: nil, afterDelay: 0.1)
                self.delegate?.badgeField?(self, didEndDraggingOriginBadge: draggedBadge, toBadgeField: self, withNewBadge: nil)
            })
        } else {
            moveBadgeToOriginalPosition()
            moveBadgeToOriginalTextField()
            hideDraggingWindow()
            delegate?.badgeField?(self, didEndDraggingOriginBadge: draggedBadge, toBadgeField: self, withNewBadge: nil)
        }
    }

    private func animateDraggedBadgeToBadgeField(_ destinationBadgeField: MSBadgeField) {
        guard let containingWindow = window else {
            cancelBadgeDraggingIfNeeded()
            return
        }

        // "Cache" dragged badge (because we reset it below but we still need pointer to it)
        guard let draggedBadge = self.draggedBadge else {
            cancelBadgeDraggingIfNeeded()
            return
        }

        // Compute destination position
        let destinationFrameInHoveredBadgeField = destinationBadgeField.frameForBadge(draggedBadge, boundingWidth: destinationBadgeField.width)
        let destinationFrameInWindow = destinationBadgeField.convert(destinationFrameInHoveredBadgeField, to: containingWindow)

        // Animate to destination position
        UIView.animate(withDuration: Constants.dragAndDropPositioningAnimationDuration, delay: 0.0, options: .beginFromCurrentState, animations: {
            draggedBadge.layer.transform = CATransform3DIdentity
            draggedBadge.frame = destinationFrameInWindow
        }, completion: { _ in
            // Update destination field
            let newlyCreatedBadge: MSBadgeView? = {
                guard let dataSource = draggedBadge.dataSource, destinationBadgeField.shouldAddBadge(forBadgeDataSource: dataSource) else {
                    return nil
                }
                destinationBadgeField.addBadge(withDataSource: dataSource, fromUserAction: true, updateConstrainedBadges: true)
                destinationBadgeField.selectBadge(destinationBadgeField.badges.last!)
                return destinationBadgeField.badgeWithEqualDataSource(dataSource)!
            }()
            // Update origin field
            self.deleteBadge(draggedBadge, fromUserAction: true, updateConstrainedBadges: true)
            self.selectedBadge = nil
            self.updateLabelsVisibility()

            draggedBadge.removeFromSuperview()
            self.draggedBadge = nil
            self.setNeedsLayout()

            // Reset dragging window: need to execute this after a delay to avoid blinking
            self.perform(#selector(self.hideDraggingWindow), with: nil, afterDelay: 0.1)
            self.delegate?.badgeField?(self, didEndDraggingOriginBadge: draggedBadge, toBadgeField: destinationBadgeField, withNewBadge: newlyCreatedBadge)
        })
    }

    @objc private func hideDraggingWindow() {
        draggingWindow.isHidden = true
    }

    private func cancelRunningGesture(_ gesture: UIGestureRecognizer) {
        // Doing this will deliver a Failed state on the next gesture update. This is Apple's recommended way.
        gesture.isEnabled = false
        gesture.isEnabled = true
    }

    private func cancelBadgeDraggingIfNeeded() {
        if draggedBadge == nil {
            return
        }
        // Animate back to origin
        moveDraggedBadgeBackToOriginalPosition(animated: false)
    }

    private func resetDraggingWindow() {
        guard let containingWindow = window else {
            return
        }
        cancelBadgeDraggingIfNeeded()
        // Reinstanciate a window with fresh orientation
        draggingWindow = UIWindow()
        draggingWindow.frame = containingWindow.frame
        setupDraggingWindow()
    }
}

// MARK: - MSBadgeField: MSBadgeViewDelegate

extension MSBadgeField: MSBadgeViewDelegate {
    public func didSelectBadge(_ badge: MSBadgeView) {
        selectBadge(badge)
    }

    public func didTapSelectedBadge(_ badge: MSBadgeView) {
        delegate?.badgeField?(self, didTapSelectedBadge: badge)
    }
}

// MARK: - MSBadgeField: UITextFieldDelegate

extension MSBadgeField: UITextFieldDelegate {
    // The switchingTextFieldResponders logic relies on the fact that when we're switching between 2 text fields A -> B, the order of the callbacks are
    // textFieldShouldBeginEditing called for B
    // textFieldDidEndEditing called for A
    // textFieldDidBeginEditing called for B
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !isEditable {
            return false
        }
        // No text field was selected before, check if we should begin editing
        if textField == selectedBadgeTextField && !self.textField.isFirstResponder ||
            textField == self.textField && !selectedBadgeTextField.isFirstResponder {
            if delegate?.badgeFieldShouldBeginEditing?(self) == false {
                // Deselect in case this was triggered by a select
                selectedBadge = nil
                return false
            }
        }
        switchingTextFieldResponders = true
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        showAllBadgesForEditing = true
        switchingTextFieldResponders = false
        delegate?.badgeFieldDidBeginEditing?(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == selectedBadgeTextField {
            selectedBadge = nil
        }
        if !switchingTextFieldResponders {
            badgeText()
            updateLabelsVisibility()
            delegate?.badgeFieldDidEndEditing?(self)
        }
        showAllBadgesForEditing = false
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            if let text = textField.text, text.trimmed().isEmpty {
                let shouldReturn = delegate?.badgeFieldShouldReturn?(self) ?? true
                if shouldReturn {
                    resignFirstResponder()
                }
                return false
            }
            badgeText()
            return false
        }
        if textField == selectedBadgeTextField {
            deleteSelectedBadge(fromUserAction: true)
            self.textField.becomeFirstResponder()
            return true
        }
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == selectedBadgeTextField {
            deleteSelectedBadge(fromUserAction: true)
            // Insert the new char at beginning of text field
            if let formerTextFieldText = self.textField.text {
                let newTextFieldText = NSMutableString(string: formerTextFieldText)
                newTextFieldText.insert(string, at: 1)
                self.textField.text = newTextFieldText as String
                delegate?.badgeField?(self, willChangeTextFieldContentWithText: self.textField.text!.trimmed())
            }
            updateLabelsVisibility()
            self.textField.becomeFirstResponder()
            return false
        }

        if textField == self.textField {
            guard let textFieldText = textField.text else {
                return true
            }

            let newString = (textFieldText as NSString).replacingCharacters(in: range, with: string)
            // Badging character detected
            let badgingCharactersSet = CharacterSet(charactersIn: badgingCharacters)
            if let range = newString.rangeOfCharacter(from: badgingCharactersSet), !range.isEmpty {
                let didBadge = badgeText(newString, force: false)
                if !didBadge {
                    // Placeholder
                    updateLabelsVisibility(textFieldContent: newString.trimmed())
                    delegate?.badgeField?(self, willChangeTextFieldContentWithText: newString.trimmed())
                }
                return !didBadge
            }

            updateLabelsVisibility(textFieldContent: newString.trimmed())

            // Handle delete key
            if string.isEmpty {
                // Delete on selected text: delete selection
                if textField.selectedTextRange?.isEmpty == false {
                    delegate?.badgeField?(self, willChangeTextFieldContentWithText: newString.trimmed())
                    return true
                }
                // Delete backward on visible character: delete character
                let textPositionValue = textField.offset(from: textField.beginningOfDocument, to: textField.selectedTextRange!.start)
                if textPositionValue != Constants.emptyTextFieldString.count {
                    delegate?.badgeField?(self, willChangeTextFieldContentWithText: newString.trimmed())
                    return true
                }
                // Delete backward on zero width space
                if let lastBadge = badges.last {
                    selectBadge(lastBadge)
                    selectedBadgeTextField.becomeFirstResponder()
                }
                return false
            }

            delegate?.badgeField?(self, willChangeTextFieldContentWithText: newString.trimmed())
        }
        return true
    }
}

// MARK: - PasteControlTextField

private class PasteControlTextField: UITextField {
    /**
     Note: This is a signal that indicates that this is under a paste context. This pasteSignal is reset in 'handleTextFieldTextChanged' method of 'MSBadgeField' right after the delegate method is called
     */
    fileprivate var isPaste: Bool = false

    override func paste(_ sender: Any?) {
        isPaste = true
        super.paste(sender)
    }
}
