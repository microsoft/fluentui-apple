//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: BadgeFieldDelegate
@available(*, deprecated, renamed: "BadgeFieldDelegate")
public typealias MSBadgeFieldDelegate = BadgeFieldDelegate

@objc(MSFBadgeFieldDelegate)
public protocol BadgeFieldDelegate: AnyObject {
    @objc optional func badgeField(_ badgeField: BadgeField, badgeDataSourceForText text: String) -> BadgeViewDataSource

    @objc optional func badgeField(_ badgeField: BadgeField, willChangeTextFieldContentWithText newText: String)
    @objc optional func badgeFieldDidChangeTextFieldContent(_ badgeField: BadgeField, isPaste: Bool)
    @objc optional func badgeField(_ badgeField: BadgeField, shouldBadgeText text: String, forSoftBadgingString badgingString: String) -> Bool
    /**
     `didAddBadge` and `didDeleteBadge` won't be called in the following case:
     add/delete were not triggered by a user action. In this case, handle the consequences of a add/delete after the external class called setupViewWithBadgeDataSources or addBadgeWithDataSource
     */
    @objc optional func badgeField(_ badgeField: BadgeField, didAddBadge badge: BadgeView)
    @objc optional func badgeField(_ badgeField: BadgeField, didDeleteBadge badge: BadgeView)
    /**
     `shouldAddBadgeForBadgeDataSource` defaults to true. Called only if the add results from a user action.
     */
    @objc optional func badgeField(_ badgeField: BadgeField, shouldAddBadgeForBadgeDataSource badgeDataSource: BadgeViewDataSource) -> Bool
    @objc optional func badgeField(_ badgeField: BadgeField, newBadgeForBadgeDataSource badgeDataSource: BadgeViewDataSource) -> BadgeView
    @objc optional func badgeField(_ badgeField: BadgeField, newMoreBadgeForBadgeDataSources badgeDataSources: [BadgeViewDataSource]) -> BadgeView
    @objc optional func badgeFieldContentHeightDidChange(_ badgeField: BadgeField)
    @objc optional func badgeField(_ badgeField: BadgeField, didTapSelectedBadge badge: BadgeView)
    @objc optional func badgeField(_ badgeField: BadgeField, shouldDragBadge badge: BadgeView) -> Bool // defaults to true
    /**
     `destinationBadgeField` is nil if the badge is animated back to its original field.
     `newBadge` is nil if the destination field returned false to `badgeField:shouldAddBadgeForBadgeDataSource` when the user dropped the badge.
     */
    @objc optional func badgeField(_ originbadgeField: BadgeField, didEndDraggingOriginBadge originBadge: BadgeView, toBadgeField destinationBadgeField: BadgeField?, withNewBadge newBadge: BadgeView?)
    @objc optional func badgeFieldShouldBeginEditing(_ badgeField: BadgeField) -> Bool
    @objc optional func badgeFieldDidBeginEditing(_ badgeField: BadgeField)
    @objc optional func badgeFieldDidEndEditing(_ badgeField: BadgeField)
    /**
     `badgeFieldShouldReturn` is called only when there's no text in the text field, otherwise `BadgeField` badges the text and doesn't call this.
     */
    @objc optional func badgeFieldShouldReturn(_ badgeField: BadgeField) -> Bool
    /// This is called to check if we should make badges inactive on textFieldDidEndEditing.
    /// If not implemented, the default value assumed is false.
    @objc optional func badgeFieldShouldKeepBadgesActiveOnEndEditing(_ badgeField: BadgeField) -> Bool
}

// MARK: - BadgeField Colors

public extension Colors {
    struct BadgeField {
        public static var background: UIColor = surfacePrimary
    }
}

// MARK: - BadgeField

@available(*, deprecated, renamed: "BadgeField")
public typealias MSBadgeField = BadgeField
/**
 BadgeField is a UIView that acts as a UITextField that can contains badges with enclosed text.
 It supports:
 * badge selection. Selection leaves the order of pills unchanged.
 * badge drag and drop between multiple BadgeFields
 * placeholder (hidden when text is not empty) or introduction text (not hidden when text is not empty)
 * custom input accessory view
 * max number of lines, with custom "+XX" badge to indicate badges that are not displayed
 * voiceover and dynamic text sizing
 */
@objc(MSFBadgeField)
open class BadgeField: UIView {
    private struct Constants {
        static let badgeMarginHorizontal: CGFloat = 5
        static let badgeMarginVertical: CGFloat = 5
        static let emptyTextFieldString: String = ""
        static let dragAndDropMinimumPressDuration: TimeInterval = 0.2
        static let dragAndDropScaleAnimationDuration: TimeInterval = 0.3
        static let dragAndDropScaleFactor: CGFloat = 1.10
        static let dragAndDropPositioningAnimationDuration: TimeInterval = 0.2
        static let labelMarginRight: CGFloat = 5
        static let labelColorStyle: TextColorStyle = .secondary
        static let textFieldMinWidth: CGFloat = 100
        static let textStyle: TextStyle = .subhead
    }

    @objc open var label: String = "" {
        didSet {
            labelView.text = label
            updateLabelsVisibility()
            textField.accessibilityLabel = label
            setNeedsLayout()
        }
    }

    @objc open var placeholder: String = "" {
        didSet {
            placeholderView.text = placeholder
            updateLabelsVisibility()
            textField.accessibilityLabel = placeholder
            setNeedsLayout()
        }
    }

    /**
     The max number of lines on which the badges should be laid out. If badges can't fit in the available number of lines, the textfield will add a `moreBadge` at the end of the last displayed line.
     Set `numberOfLines` to 0 to remove any limit for the number of lines.
     The default value is 0.
     Note:  Drag and drop should not be used with text fields that have a `numberOfLines` != 0. The resulting behavior is unknown.
     */
    @objc open var numberOfLines: Int = 0 {
        didSet {
            updateConstrainedBadges()
            updateBadgesVisibility()
            setNeedsLayout()
        }
    }

    /// Indicates whether or not the badge field is "editable". Note: if `isEditable` is false and in "non-editable" mode, the user CAN select badges but CAN'T add, delete or drag badge views.
    @objc open var isEditable: Bool = true {
        didSet {
            if !isEditable {
                resignFirstResponder()
            }
            textField.isUserInteractionEnabled = isEditable
            selectedBadgeTextField.isUserInteractionEnabled = isEditable
        }
    }

    /// `isActive` is a proxy property that is transmitted to all the badge views. Badge views should have their style altered if this is true. But this is the decision of whoever implement a new badge view abstract class. Note that this does not change the touch handling behavior in any way.
    @objc open var isActive: Bool = false {
        didSet {
            badges.forEach { $0.isActive = isActive }
            moreBadge?.isActive = isActive
        }
    }

    /// Set `allowsDragAndDrop`to determine whether or not the dragging and dropping of badges between badge fields is allowed.
    @objc open var allowsDragAndDrop: Bool = true

    /**
     "Soft" means that the `badgeField` badges the text only under certain conditions.
     It's the delegate's responsibility to define these conditions, via `badgeField(_, shouldBadgeText:, forSoftBadgingString:)`
     */
    @objc open var softBadgingCharacters: String = ""
    /**
     "Hard" means that the `badgeField` badges the text as soon as one of these character is used.
     */
    @objc open var hardBadgingCharacters: String = ""

    @objc public private(set) var badges: [BadgeView] = []

    @objc public var badgeDataSources: [BadgeViewDataSource] { return badges.map { $0.dataSource! } }

    @objc public weak var badgeFieldDelegate: BadgeFieldDelegate?

    var deviceOrientationIsChanging: Bool {
        originalDeviceOrientation != UIDevice.current.orientation
    }

    private var originalDeviceOrientation: UIDeviceOrientation = UIDevice.current.orientation

    private var cachedContentHeight: CGFloat = 0 {
        didSet {
            if cachedContentHeight != oldValue {
                badgeFieldDelegate?.badgeFieldContentHeightDidChange?(self)
                invalidateIntrinsicContentSize()
            }
        }
    }

    /// Keeps a copy of the original numberOfLines when the text field begins editing
    private var originalNumberOfLines: Int = 0

    @objc public init() {
        super.init(frame: .zero)
        backgroundColor = Colors.BadgeField.background

        labelView.style = Constants.textStyle
        labelView.colorStyle = Constants.labelColorStyle
        addSubview(labelView)

        placeholderView.style = Constants.textStyle
        placeholderView.colorStyle = Constants.labelColorStyle
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

        textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)

        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)

        // An accessible container must set isAccessibilityElement to false
        isAccessibilityElement = false
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    deinit {

        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }

    /**
     Sets up the view using the badge data sources.
     */
    @objc open func setup(dataSources: [BadgeViewDataSource]) {
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
     Updates the view using existing data sources. This is a bit of a hack since it's better to assume `BadgeViewDataSource` is immutable, but this is necessary to update badge style without losing the current state.
     */
    @objc open func reload() {
        badges.forEach { $0.reload() }
        setNeedsLayout()
    }

    private func setupTextField(_ textField: UITextField) {
        textField.font = Constants.textStyle.font
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
        let topMargin = UIScreen.main.middleOrigin(frame.height, containedSizeValue: contentHeight)

        var left = labelViewRightOffset
        var lineIndex = 0
        var badgeHeight: CGFloat = 0.0

        for (index, badge) in currentBadges.enumerated() {
            // Don't layout the dragged badge
            if badge == draggedBadge {
                continue
            }
            badge.frame = calculateBadgeFrame(badge: badge, badgeIndex: index, lineIndex: &lineIndex, left: &left, topMargin: topMargin, boundingWidth: bounds.width)
            badgeHeight = badge.frame.height
        }

        labelView.frame = CGRect(x: 0, y: topMargin, width: labelViewWidth, height: badgeHeight)

        let textFieldSize = textField.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let textFieldHeight = UIScreen.main.roundToDevicePixels(textFieldSize.height)
        let textFieldVerticalOffset = UIScreen.main.middleOrigin(badgeHeight, containedSizeValue: textFieldHeight)
        let shouldAppendToCurrentLine = left + Constants.textFieldMinWidth <= frame.width
        if !shouldAppendToCurrentLine {
            lineIndex += 1
            left = 0
        }
        textField.frame = CGRect(
            x: left,
            y: topMargin + offsetForLine(badgeHeight: badgeHeight, at: lineIndex) + textFieldVerticalOffset,
            width: frame.width - left,
            height: textFieldHeight
        )

        placeholderView.frame = CGRect(x: 0, y: topMargin, width: frame.width, height: badgeHeight)

        flipSubviewsForRTL()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: contentHeight(forBoundingWidth: size.width))
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: contentHeight(forBoundingWidth: frame.width))
    }

    private func shouldDragBadge(_ badge: BadgeView) -> Bool {
        if allowsDragAndDrop {
            return badgeFieldDelegate?.badgeField?(self, shouldDragBadge: badge) ?? true
        }
        return false
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

    private func addNextBadge(_ badge: BadgeView, badgeIndex: Int, currentLeft: CGFloat, currentLineIndex: Int) -> (Bool, CGFloat, Int) {
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
                                                                      boundingWidth: frame.width)
        }

        let badgeWidth = width(forBadge: badge,
                               isFirstBadge: isFirstBadge,
                               isFirstBadgeOfLastDisplayedLine: isFirstBadgeOfCurrentLine,
                               moreBadgeOffset: moreBadgeOffset,
                               boundingWidth: frame.width)
        let enoughSpaceAvailable = currentLeft + badgeWidth + moreBadgeOffset <= frame.width
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

    private func frameForBadge(_ badgeToInsert: BadgeView, boundingWidth: CGFloat) -> CGRect {
        let badges = currentBadges
        let contentHeight = self.contentHeight(forBoundingWidth: bounds.width)
        let topMargin = UIScreen.main.middleOrigin(frame.height, containedSizeValue: contentHeight)
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
    private func width(forBadge badge: BadgeView, isFirstBadge: Bool, isFirstBadgeOfLastDisplayedLine: Bool, moreBadgeOffset: CGFloat = -1, boundingWidth: CGFloat) -> CGFloat {
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

    @objc open func heightThatFits(badgeHeight: CGFloat, numberOfLines: Int) -> CGFloat {
        // Vertical margin not applicable to top line
        let heightForAllLines = CGFloat(numberOfLines) * (badgeHeight + Constants.badgeMarginVertical)
        return heightForAllLines - Constants.badgeMarginVertical
    }

    private func contentHeight(forBoundingWidth boundingWidth: CGFloat) -> CGFloat {
        var left = labelViewRightOffset
        var lineIndex = 0
        var badgeHeight: CGFloat = 0.0

        for (index, badge) in currentBadges.enumerated() {
            let frame = calculateBadgeFrame(badge: badge, badgeIndex: index, lineIndex: &lineIndex, left: &left, topMargin: 0, boundingWidth: bounds.width)
            badgeHeight = frame.size.height
        }

        let isFirstResponderOrHasTextFieldContent = isFirstResponder || !textFieldContent.isEmpty

        if isEditable && isFirstResponderOrHasTextFieldContent && left + Constants.textFieldMinWidth > boundingWidth {
            lineIndex += 1
        }
        let textFieldSize = textField.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let textFieldHeight = UIScreen.main.roundToDevicePixels(textFieldSize.height)
        let contentHeight = heightThatFits(badgeHeight: badgeHeight, numberOfLines: lineIndex + 1)
        return max(textFieldHeight, contentHeight)
    }

    @discardableResult
    private func calculateBadgeFrame(badge: BadgeView, badgeIndex: Int, lineIndex: inout Int, left: inout CGFloat, topMargin: CGFloat, boundingWidth: CGFloat) -> CGRect {
        let isFirstBadge = badgeIndex == 0
        let isFirstBadgeOfCurrentLine = isFirstBadge || left == 0
        let isLastDisplayedLine = shouldUseConstrainedBadges && lineIndex == numberOfLines - 1
        let badgeWidth = width(forBadge: badge,
                               isFirstBadge: isFirstBadge,
                               isFirstBadgeOfLastDisplayedLine: isFirstBadgeOfCurrentLine && isLastDisplayedLine,
                               boundingWidth: boundingWidth)
        let badgeHeight = badge.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).height

        // Not enough space on current line
        let enoughSpaceAvailableOnCurrentLine = left + badgeWidth <= frame.width
        let shouldAppendToCurrentLine = isFirstBadgeOfCurrentLine || enoughSpaceAvailableOnCurrentLine
        if !shouldAppendToCurrentLine {
            lineIndex += 1
            left = 0
            // Badge width may change to accomodate `moreBadge`, recursively layout
            return calculateBadgeFrame(badge: badge, badgeIndex: badgeIndex, lineIndex: &lineIndex, left: &left, topMargin: topMargin, boundingWidth: boundingWidth)
        }

        let badgeFrame = CGRect(x: left,
                                y: topMargin + offsetForLine(badgeHeight: badgeHeight, at: lineIndex),
                                width: badgeWidth,
                                height: badgeHeight)

        left += badgeWidth + Constants.badgeMarginHorizontal

        return badgeFrame
    }

    private func offsetForLine(badgeHeight: CGFloat, at lineIndex: Int) -> CGFloat {
        return CGFloat(lineIndex) * (badgeHeight + Constants.badgeMarginVertical)
    }

    // MARK: Badges

    private var badgingCharacters: String { return softBadgingCharacters + hardBadgingCharacters }

    /**
     The approach taken to handle the numberOfLines feature is to have a separate set of badges. It might look like this choice implies some code duplication, however this feature is almost only about layout (except the moreBadge). Handling numberOfLines directly in the layout process would lead to even more duplication: layoutSubviews, contentHeightForBoundingWidth and frameForBadge. This approach isolates the complexity of numberOfLines in a single method: updateConstrainedBadges that we have to call in the appropriate places.
     */
    private var constrainedBadges: [BadgeView] = []

    private var currentBadges: [BadgeView] { return shouldUseConstrainedBadges ? constrainedBadges : badges }

    private var shouldUseConstrainedBadges: Bool { return numberOfLines != 0 }

    /**
     This badge is added to the end of the last displayed line if all the badges don't fit in the numberOfLines. It will look like "+5", for example, to indicate the number of badges that are not being displayed.
     */
    private var moreBadge: BadgeView? {
        didSet {
            if let moreBadge = moreBadge {
                moreBadge.delegate = self
                moreBadge.isActive = isActive
                moreBadge.isUserInteractionEnabled = false
            }
        }
    }

    private var selectedBadge: BadgeView? {
        didSet {
            if selectedBadge == oldValue {
                return
            }
            oldValue?.isSelected = false
            selectedBadge?.isSelected = true
        }
    }

    var draggedBadge: BadgeView?
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
    @objc open func addBadges(withDataSources dataSources: [BadgeViewDataSource]) {
        for dataSource in dataSources {
            addBadge(withDataSource: dataSource, updateConstrainedBadges: false)
        }
        updateConstrainedBadges()
    }

    @objc open func addBadge(withDataSource dataSource: BadgeViewDataSource, fromUserAction: Bool = false, updateConstrainedBadges: Bool = true) {
        let badge = createBadge(withDataSource: dataSource)

        addBadge(badge)
        updateLabelsVisibility()
        selectedBadge = nil

        if updateConstrainedBadges {
            self.updateConstrainedBadges()
        }

        setNeedsLayout()

        if fromUserAction {
            badgeFieldDelegate?.badgeField?(self, didAddBadge: badge)
        }
    }

    @objc open func deleteBadges(withDataSource dataSource: BadgeViewDataSource) {
        badges.forEach { badge in
            if badge.dataSource == dataSource {
                deleteBadge(badge, fromUserAction: false, updateConstrainedBadges: false)
            }
        }
        updateConstrainedBadges()
    }

    @objc open func deleteAllBadges() {
        deleteAllBadges(fromUserAction: false)
    }

    @objc open func selectBadge(_ badge: BadgeView) {
        // Do nothing if badge already selected
        if selectedBadge == badge {
            return
        }
        selectedBadge = badge
        selectedBadgeTextField.becomeFirstResponder()
    }

    func addBadge(_ badge: BadgeView) {
        badge.delegate = self
        badge.isActive = isActive
        badges.append(badge)
        addSubview(badge)
        // Configure drag gesture
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        longPressGestureRecognizer.minimumPressDuration = Constants.dragAndDropMinimumPressDuration
        badge.addGestureRecognizer(longPressGestureRecognizer)
    }

    @discardableResult
    private func badgeText(_ text: String, force forceBadge: Bool) -> Bool {
        if text.isEmpty {
            return false
        }

        let badgeStrings = extractBadgeStrings(from: text, badgingCharacters: badgingCharacters, hardBadgingCharacters: hardBadgingCharacters, forceBadge: forceBadge, shouldBadge: { (badgeString, softBadgingString) -> Bool in
            return badgeFieldDelegate?.badgeField?(self, shouldBadgeText: badgeString, forSoftBadgingString: softBadgingString) ?? true
        })

        var didBadge = false

        // Add badges
        for badgeString in badgeStrings {
            // Append badge if needed
            if let badgeDataSource = badgeFieldDelegate?.badgeField?(self, badgeDataSourceForText: badgeString) {
                if shouldAddBadge(forBadgeDataSource: badgeDataSource) {
                    addBadge(withDataSource: badgeDataSource, fromUserAction: true, updateConstrainedBadges: true)
                }
                // Consider that we badge even if the delegate prevented via `shouldAddBadgeForBadgeDataSource`
                didBadge = true
            }
        }

        if didBadge {
            resetTextFieldContent()
        }

        setNeedsLayout()

        return didBadge
    }

    private func createBadge(withDataSource dataSource: BadgeViewDataSource) -> BadgeView {
        var badge: BadgeView
        if let badgeFromDelegate = badgeFieldDelegate?.badgeField?(self, newBadgeForBadgeDataSource: dataSource) {
            badge = badgeFromDelegate
        } else {
            badge = BadgeView(dataSource: dataSource)
        }

        return badge
    }

    private func createMoreBadge(withDataSources dataSources: [BadgeViewDataSource]) -> BadgeView {
        // If no delegate, fallback to default "+X" moreBadge
        var moreBadge: BadgeView
        if let moreBadgeFromDelegate = badgeFieldDelegate?.badgeField?(self, newMoreBadgeForBadgeDataSources: dataSources) {
            moreBadge = moreBadgeFromDelegate
        } else {
            moreBadge = BadgeView(dataSource: BadgeViewDataSource(text: "+\(dataSources.count)", style: .default))
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

    func deleteBadge(_ badge: BadgeView, fromUserAction: Bool, updateConstrainedBadges: Bool) {
        badge.removeFromSuperview()
        badges.remove(at: badges.firstIndex(of: badge)!)

        if updateConstrainedBadges {
            self.updateConstrainedBadges()
        }

        updateLabelsVisibility()

        if fromUserAction {
            badgeFieldDelegate?.badgeField?(self, didDeleteBadge: badge)
        }
    }

    private func deleteSelectedBadge(fromUserAction: Bool) {
        if let selectedBadge = selectedBadge {
            deleteBadge(selectedBadge, fromUserAction: fromUserAction, updateConstrainedBadges: true)
            self.selectedBadge = nil
        }
    }

    private func shouldAddBadge(forBadgeDataSource dataSource: BadgeViewDataSource) -> Bool {
        return badgeFieldDelegate?.badgeField?(self, shouldAddBadgeForBadgeDataSource: dataSource) ?? true
    }

    private func updateBadgesVisibility() {
        badges.forEach { $0.isHidden = shouldUseConstrainedBadges }
        constrainedBadges.forEach { $0.isHidden = !shouldUseConstrainedBadges }
        moreBadge?.isHidden = !shouldUseConstrainedBadges
    }

    // MARK: Text field

    @objc open var textFieldContent: String {
        return textField.text?.trimmed() ?? ""
    }

    @objc open func resetTextFieldContent() {
        textField.text = Constants.emptyTextFieldString
    }

    private let textField = BadgeTextField()

    /**
     The approach taken with selectedBadgeTextField is to use an alternate UITextField, invisible to the user, to handle all the actions that are related to the existing badges.
     */
    private let selectedBadgeTextField = BadgeTextField()

    private var switchingTextFieldResponders: Bool = false

    // MARK: Label view and placeholder view

    private let labelView = Label()
    private let placeholderView = Label()

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

    @objc func textFieldTextChanged() {
        badgeFieldDelegate?.badgeFieldDidChangeTextFieldContent?(self, isPaste: textField.isPaste)
        textField.isPaste = false
    }

    @objc private func handleOrientationChanged() {
        // Hack: to avoid properly handling rotations for the dragging window (which is annoying and overkill for this feature), let's just reset the dragging window
        resetDraggingWindow()
        originalDeviceOrientation = UIDevice.current.orientation
    }

    @objc private func handleContentSizeCategoryDidChange() {
        invalidateIntrinsicContentSize()
        setupTextField(textField)
    }

    // MARK: Accessibility

    open override func accessibilityElementCount() -> Int {
        var elementsCount = 0
        if isIntroductionLabelAccessible() {
            elementsCount += 1
        }

        elementsCount += shouldUseConstrainedBadges ? constrainedBadges.count : badges.count

        // counting the trailing text field used to add more badges
        elementsCount += 1
        return elementsCount
    }

    open override func accessibilityElement(at index: Int) -> Any? {
        if isIntroductionLabelAccessible() && index == 0 {
            return labelView
        }
        let offsetIndex = isIntroductionLabelAccessible() ? index - 1 : index

        let activeBadges = shouldUseConstrainedBadges ? constrainedBadges : badges
        if offsetIndex < activeBadges.count {
            return activeBadges[offsetIndex]
        }
        return textField
    }

    open override func index(ofAccessibilityElement element: Any) -> Int {
        if element as? UILabel == labelView {
            return 0
        }

        let activeBadges = shouldUseConstrainedBadges ? constrainedBadges : badges
        if let badge = element as? BadgeView, let index = activeBadges.firstIndex(of: badge) {
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
        if !isFirstResponder && badgeFieldDelegate?.badgeFieldShouldBeginEditing?(self) == false {
            cancelRunningGesture(gesture)
            return
        }

        guard let draggedBadge = gesture.view as? BadgeView else {
            return
        }
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
            if !shouldDragBadge(draggedBadge) {
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
            let hitBadgeField: BadgeField?
            if let hitView = containingWindow.hitTest(gesture.location(in: containingWindow), with: nil) {
                hitBadgeField = hitView as? BadgeField ?? hitView.findSuperview(of: BadgeField.self) as? BadgeField
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

    private func startDraggingBadge(_ badge: BadgeView, gestureRecognizer: UIGestureRecognizer) {
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
        draggedBadgeTouchCenterOffset = CGPoint(x: round(touchLocation.x - badge.frame.width / 2), y: round(touchLocation.y - badge.frame.height / 2))
        // Dragging window becomes front window
        draggingWindow.isHidden = false
        // Move dragged badge to main window
        draggedBadge?.frame = convert(draggedBadge!.frame, to: containingWindow)
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
        guard let draggedBadge = draggedBadge else {
            return
        }
        // Compute original position
        let destinationFrameInSelf = frameForBadge(draggedBadge, boundingWidth: frame.width)
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
                self.badgeFieldDelegate?.badgeField?(self, didEndDraggingOriginBadge: draggedBadge, toBadgeField: self, withNewBadge: nil)
            })
        } else {
            moveBadgeToOriginalPosition()
            moveBadgeToOriginalTextField()
            hideDraggingWindow()
            badgeFieldDelegate?.badgeField?(self, didEndDraggingOriginBadge: draggedBadge, toBadgeField: self, withNewBadge: nil)
        }
    }

    func animateDraggedBadgeToBadgeField(_ destinationBadgeField: BadgeField) {
        guard let containingWindow = window else {
            cancelBadgeDraggingIfNeeded()
            return
        }

        // "Cache" dragged badge (because we reset it below but we still need pointer to it)
        guard let draggedBadge = draggedBadge else {
            cancelBadgeDraggingIfNeeded()
            return
        }

        // Compute destination position
        let destinationFrameInHoveredBadgeField = destinationBadgeField.frameForBadge(draggedBadge, boundingWidth: destinationBadgeField.frame.width)
        let destinationFrameInWindow = destinationBadgeField.convert(destinationFrameInHoveredBadgeField, to: containingWindow)

        // Animate to destination position
        UIView.animate(withDuration: Constants.dragAndDropPositioningAnimationDuration, delay: 0.0, options: .beginFromCurrentState, animations: {
            draggedBadge.layer.transform = CATransform3DIdentity
            draggedBadge.frame = destinationFrameInWindow
        }, completion: { _ in
            // Update destination field
            let newlyCreatedBadge: BadgeView? = {
                guard let dataSource = draggedBadge.dataSource, destinationBadgeField.shouldAddBadge(forBadgeDataSource: dataSource) else {
                    return nil
                }
                destinationBadgeField.addBadge(withDataSource: dataSource, fromUserAction: true, updateConstrainedBadges: true)
                let lastBadge = destinationBadgeField.badges.last!
                destinationBadgeField.selectBadge(lastBadge)
                return lastBadge
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
            self.badgeFieldDelegate?.badgeField?(self, didEndDraggingOriginBadge: draggedBadge, toBadgeField: destinationBadgeField, withNewBadge: newlyCreatedBadge)
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

    func cancelBadgeDraggingIfNeeded() {
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

// MARK: - BadgeField: BadgeViewDelegate

extension BadgeField: BadgeViewDelegate {
    public func didSelectBadge(_ badge: BadgeView) {
        selectBadge(badge)
    }

    public func didTapSelectedBadge(_ badge: BadgeView) {
        badgeFieldDelegate?.badgeField?(self, didTapSelectedBadge: badge)
    }
}

// MARK: - BadgeField: UITextFieldDelegate

extension BadgeField: UITextFieldDelegate {
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
            if badgeFieldDelegate?.badgeFieldShouldBeginEditing?(self) == false {
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
        badgeFieldDelegate?.badgeFieldDidBeginEditing?(self)
        isActive = true
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Don't end editing on orientation change
        return !deviceOrientationIsChanging
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == selectedBadgeTextField {
            selectedBadge = nil
        }
        if !switchingTextFieldResponders {
            badgeText()
            updateLabelsVisibility()
            badgeFieldDelegate?.badgeFieldDidEndEditing?(self)
        }
        let shouldKeepBadgesActiveOnEndEditing = badgeFieldDelegate?.badgeFieldShouldKeepBadgesActiveOnEndEditing?(self) ?? false
        showAllBadgesForEditing = shouldKeepBadgesActiveOnEndEditing
        isActive = shouldKeepBadgesActiveOnEndEditing
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            if let text = textField.text, text.trimmed().isEmpty {
                let shouldReturn = badgeFieldDelegate?.badgeFieldShouldReturn?(self) ?? true
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
                newTextFieldText.insert(string, at: 0)
                self.textField.text = newTextFieldText as String
                badgeFieldDelegate?.badgeField?(self, willChangeTextFieldContentWithText: self.textField.text!.trimmed())
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
                    badgeFieldDelegate?.badgeField?(self, willChangeTextFieldContentWithText: newString.trimmed())
                }
                return !didBadge
            }

            updateLabelsVisibility(textFieldContent: newString.trimmed())

            // Handle delete key
            if string.isEmpty {
                // Delete on selected text: delete selection
                if textField.selectedTextRange?.isEmpty == false {
                    badgeFieldDelegate?.badgeField?(self, willChangeTextFieldContentWithText: newString.trimmed())
                    return true
                }

                // Delete backward on a single character: delete character
                let textPositionValue = textField.offset(from: textField.beginningOfDocument, to: textField.selectedTextRange!.start)
                if textPositionValue != Constants.emptyTextFieldString.count {
                    badgeFieldDelegate?.badgeField?(self, willChangeTextFieldContentWithText: newString.trimmed())
                    return true
                }

                // Delete backward in the first position: select last badge if available
                if let lastBadge = badges.last {
                    selectBadge(lastBadge)
                    selectedBadgeTextField.becomeFirstResponder()
                }
                return false
            }

            badgeFieldDelegate?.badgeField?(self, willChangeTextFieldContentWithText: newString.trimmed())
        }
        return true
    }
}

// MARK: - BadgeTextField

private class BadgeTextField: UITextField {
    /**
     Note: This is a signal that indicates that this is under a paste context. This pasteSignal is reset in 'textFieldTextChanged' method of 'BadgeField' right after the delegate method is called
     */
    fileprivate var isPaste: Bool = false

    override func paste(_ sender: Any?) {
        isPaste = true
        super.paste(sender)
    }

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
