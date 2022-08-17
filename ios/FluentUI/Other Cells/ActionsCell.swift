//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ActionsCell

/**
 `ActionsCell` is used to present a button or set of buttons (max of 2) as a row in a table view. After being added to the table view a target can be added to the button(s) with a corresponding action.

 `ActionsCell` supports a maximum of 2 buttons that are displayed in a single row with a vertical separator between them. A button can be denoted 'destructive' by setting the 'action(X)ActionType' parameter to `.destructive`. When `.destructive`, this property causes the button to be displayed with red title label text to signify a 'destructive' action. When `.communication` is passed in, the button will be displayed with communication blue color.

 `topSeparatorType` and `bottomSeparatorType` can be used to show custom horizontal separators. Make sure to remove the `UITableViewCell` built-in separator by setting `separatorStyle = .none` on your table view.
 */
@objc(MSFActionsCell)
open class ActionsCell: UITableViewCell, TokenizedControlInternal {
    @objc(MSFActionsCellActionType)
    public enum ActionType: Int {
        case regular
        case destructive
        case communication

        func highlightedTextColor(tokens: ActionsCellTokens) -> UIColor {
            switch self {
            case .regular:
                return UIColor(dynamicColor: tokens.mainBrandColor).withAlphaComponent(0.4)
            case .destructive:
                return UIColor(dynamicColor: tokens.destructiveTextColor).withAlphaComponent(0.4)
            case .communication:
                return UIColor(dynamicColor: tokens.communicationTextColor).withAlphaComponent(0.4)
            }
        }

        func textColor(tokens: ActionsCellTokens) -> UIColor {
            switch self {
            case .regular:
                return UIColor(dynamicColor: tokens.mainBrandColor)
            case .destructive:
                return UIColor(dynamicColor: tokens.destructiveTextColor)
            case .communication:
                return UIColor(dynamicColor: tokens.communicationTextColor)
            }
        }
    }

    public static let identifier: String = "ActionsCell"

    // MARK: - ActionsCell TokenizedControl
    @objc public var actionsCellOverrideTokens: ActionsCellTokens? {
        didSet {
            self.overrideTokens = actionsCellOverrideTokens
        }
    }

    let defaultTokens: ActionsCellTokens = .init()
    var tokens: ActionsCellTokens = .init()
    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: ActionsCellTokens? {
        didSet {
            updateTokens()
        }
    }

    public func overrideTokens(_ tokens: ActionsCellTokens?) -> Self {
        overrideTokens = tokens
        return self
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let window = window, window.isEqual(notification.object) else {
            return
        }
        updateTokens()
    }

    private func updateTokens() {
        tokens = resolvedTokens
        setupBackgroundColors()
        updateActionTitleColors()
    }

    @objc public class func height(action1Title: String, action2Title: String = "", containerWidth: CGFloat, tokens: ActionsCellTokens) -> CGFloat {
        let actionCount: CGFloat = action2Title == "" ? 1 : 2
        let width = UIScreen.main.roundToDevicePixels(containerWidth / actionCount)

        let actionTitleFont = UIFont.fluent(tokens.titleFont)
        let action1TitleHeight = action1Title.preferredSize(for: actionTitleFont, width: width).height
        let action2TitleHeight = action2Title.preferredSize(for: actionTitleFont, width: width).height

        return max(tokens.paddingVertical * 2 + max(action1TitleHeight, action2TitleHeight), tokens.minHeight)
    }

    @objc public class func preferredWidth(action1Title: String, action2Title: String = "", tokens: ActionsCellTokens) -> CGFloat {
        let actionTitleFont = UIFont.fluent(tokens.titleFont)
        let action1TitleWidth = action1Title.preferredSize(for: actionTitleFont).width
        let action2TitleWidth = action2Title.preferredSize(for: actionTitleFont).width

        let actionCount: CGFloat = action2Title == "" ? 1 : 2
        return actionCount * max(action1TitleWidth, action2TitleWidth)
    }

    /// Style describing whether or not the cell's custom top separator should be visible and how wide it should extend
    @objc open var topSeparatorType: TableViewCell.SeparatorType = .none {
        didSet {
            if topSeparatorType != oldValue {
                updateHorizontalSeparator(topSeparator, with: topSeparatorType)
            }
        }
    }
    /// Style describing whether or not the cell's custom bottom separator should be visible and how wide it should extend
    @objc open var bottomSeparatorType: TableViewCell.SeparatorType = .none {
        didSet {
            if bottomSeparatorType != oldValue {
                updateHorizontalSeparator(bottomSeparator, with: bottomSeparatorType)
            }
        }
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
    }

    @objc public var backgroundStyleType: TableViewCellBackgroundStyleType = .plain {
        didSet {
            if backgroundStyleType != oldValue {
                setupBackgroundColors()
            }
        }
    }

    // By design, an actions cell has 2 actions at most
    @objc public let action1Button = UIButton()
    @objc public let action2Button = UIButton()

    private var action1Type: ActionType = .regular
    private var action2Type: ActionType = .regular

    private let topSeparator = MSFDivider()
    private let bottomSeparator = MSFDivider()
    private let verticalSeparator = MSFDivider(orientation: .vertical)

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(action1Button)
        contentView.addSubview(action2Button)
        contentView.addSubview(verticalSeparator)
        addSubview(topSeparator)
        addSubview(bottomSeparator)

        hideSystemSeparator()
        updateHorizontalSeparator(topSeparator, with: topSeparatorType)
        updateHorizontalSeparator(bottomSeparator, with: bottomSeparatorType)
        setupBackgroundColors()

        setupAction(action1Button)
        setupAction(action2Button)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Sets up the action cell with 1 or 2 actions.
    ///
    /// - Parameters:
    ///   - action1Title: The title of the first action.
    ///   - action2Title: The title of the second action.
    ///   - action1Type: type describing if the first action has '.regular', '.destructive' or '.communication' color.
    ///   - action2Type: type describing if the second action has '.regular', '.destructive' or '.communication' color.
    @objc open func setup(action1Title: String, action2Title: String = "", action1Type: ActionType = .regular, action2Type: ActionType = .regular) {
        action1Button.setTitle(action1Title, for: .normal)
        self.action1Type = action1Type

        let hasAction = !action2Title.isEmpty
        if hasAction {
            action2Button.setTitle(action2Title, for: .normal)
            self.action2Type = action2Type
        }
        action2Button.isHidden = !hasAction
        verticalSeparator.isHidden = !hasAction

        updateActionTitleColors()
    }

    /// Sets up the action cell with 1 action
    @objc public func setup(action1Title: String, action1Type: ActionType = .regular) {
        setup(action1Title: action1Title, action2Title: "", action1Type: action1Type)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let actionCount: CGFloat = action2Button.isHidden ? 1 : 2
        let singleActionWidth = UIScreen.main.roundToDevicePixels(contentView.frame.width / actionCount)
        var left: CGFloat = 0

        action1Button.frame = CGRect(x: left, y: 0, width: singleActionWidth, height: frame.height)
        left += action1Button.frame.width

        if actionCount > 1 {
            action2Button.frame = CGRect(x: left, y: 0, width: frame.width - left, height: frame.height)
            verticalSeparator.frame = CGRect(x: left, y: 0, width: verticalSeparator.frame.width, height: frame.height)
        }

        layoutHorizontalSeparator(topSeparator, with: topSeparatorType, at: 0)
        layoutHorizontalSeparator(bottomSeparator, with: bottomSeparatorType, at: frame.height - bottomSeparator.frame.height)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxWidth = size.width != 0 ? size.width : .infinity
        return CGSize(
            width: max(
                type(of: self).preferredWidth(
                    action1Title: action1Button.currentTitle ?? "",
                    action2Title: action2Button.currentTitle ?? "",
                    tokens: tokens
                ),
                maxWidth
            ),
            height: type(of: self).height(
                action1Title: action1Button.currentTitle ?? "",
                action2Title: action2Button.currentTitle ?? "",
                containerWidth: maxWidth,
                tokens: tokens
            )
        )
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateTokens()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        updateTokens()
        action1Button.removeTarget(nil, action: nil, for: .allEvents)
        action2Button.removeTarget(nil, action: nil, for: .allEvents)
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }

    private func setupAction(_ button: UIButton) {
        button.titleLabel?.font = UIFont.fluent(tokens.titleFont)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
    }

    private func layoutHorizontalSeparator(_ separator: MSFDivider, with type: TableViewCell.SeparatorType, at verticalOffset: CGFloat) {
        let horizontalOffset = type == .inset ? safeAreaInsets.left + tokens.horizontalSpacing : 0

        separator.frame = CGRect(
            x: horizontalOffset,
            y: verticalOffset,
            width: frame.width - horizontalOffset,
            height: separator.frame.height
        )
        separator.flipForRTL()
    }

    private func updateHorizontalSeparator(_ separator: MSFDivider, with type: TableViewCell.SeparatorType) {
        separator.isHidden = type == .none
        setNeedsLayout()
    }

    private func updateActionTitleColors() {
        action1Button.setTitleColor(action1Type.textColor(tokens: tokens), for: .normal)
        action1Button.setTitleColor(action1Type.highlightedTextColor(tokens: tokens), for: .highlighted)
        if !action2Button.isHidden {
            action2Button.setTitleColor(action2Type.textColor(tokens: tokens), for: .normal)
            action2Button.setTitleColor(action2Type.highlightedTextColor(tokens: tokens), for: .highlighted)
        }

    }

    private func setupBackgroundColors() {
        if backgroundStyleType != .custom {
            var customBackgroundConfig = UIBackgroundConfiguration.clear()
            customBackgroundConfig.backgroundColor = backgroundStyleType.defaultColor(tokens: tokens)
            backgroundConfiguration = customBackgroundConfig
        }
    }
}
