//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import Combine

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

        func highlightedTextColor(tokenSet: TableViewCellTokenSet) -> UIColor {
            switch self {
            case .regular:
                return UIColor(dynamicColor: tokenSet[.brandTextColor].dynamicColor).withAlphaComponent(0.4)
            case .destructive:
                return UIColor(dynamicColor: tokenSet[.dangerTextColor].dynamicColor).withAlphaComponent(0.4)
            case .communication:
                return UIColor(dynamicColor: tokenSet[.communicationTextColor].dynamicColor).withAlphaComponent(0.4)
            }
        }

        func textColor(tokenSet: TableViewCellTokenSet) -> UIColor {
            switch self {
            case .regular:
                return UIColor(dynamicColor: tokenSet[.brandTextColor].dynamicColor)
            case .destructive:
                return UIColor(dynamicColor: tokenSet[.dangerTextColor].dynamicColor)
            case .communication:
                return UIColor(dynamicColor: tokenSet[.communicationTextColor].dynamicColor)
            }
        }
    }

    public static let identifier: String = "ActionsCell"

    public typealias TokenSetKeyType = TableViewCellTokenSet.Tokens
    public var tokenSet: TableViewCellTokenSet
    var tokenSetSink: AnyCancellable?

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(fluentTheme)
        updateAppearance()
    }

    private func updateAppearance() {
        setupBackgroundColors()
        updateActionTitleColors()
    }

    public class func height(action1Title: String, action2Title: String = "", containerWidth: CGFloat, tokenSet: TableViewCellTokenSet) -> CGFloat {
        let actionCount: CGFloat = action2Title == "" ? 1 : 2
        let width = ceil(containerWidth / actionCount)

        let actionTitleFont = UIFont.fluent(tokenSet[.titleFont].fontInfo)
        let action1TitleHeight = action1Title.preferredSize(for: actionTitleFont, width: width).height
        let action2TitleHeight = action2Title.preferredSize(for: actionTitleFont, width: width).height

        return max(TableViewCellTokenSet.paddingVertical * 2 + max(action1TitleHeight, action2TitleHeight),
                   TableViewCellTokenSet.oneLineMinHeight)
    }

    public class func preferredWidth(action1Title: String, action2Title: String = "", tokenSet: TableViewCellTokenSet) -> CGFloat {
        let actionTitleFont = UIFont.fluent(tokenSet[.titleFont].fontInfo)
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

    private let topSeparator = Separator(orientation: .horizontal)
    private let bottomSeparator = Separator(orientation: .horizontal)
    private let verticalSeparator = Separator(orientation: .vertical)

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.tokenSet = TableViewCellTokenSet(customViewSize: { .default })
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(action1Button)
        contentView.addSubview(action2Button)
        contentView.addSubview(verticalSeparator)
        addSubview(topSeparator)
        addSubview(bottomSeparator)

        // hide system separator so we can draw our own. We prefer the container UITableView to set separatorStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: CGFloat.greatestFiniteMagnitude, bottom: 0, right: 0)
        updateHorizontalSeparator(topSeparator, with: topSeparatorType)
        updateHorizontalSeparator(bottomSeparator, with: bottomSeparatorType)
        setupBackgroundColors()

        setupAction(action1Button)
        setupAction(action2Button)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        // Update appearance whenever `tokenSet` changes.
        tokenSetSink = tokenSet.sinkChanges { [weak self] in
            self?.updateAppearance()
        }
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
        let singleActionWidth = ceil(contentView.frame.width / actionCount)
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
                Self.preferredWidth(
                    action1Title: action1Button.currentTitle ?? "",
                    action2Title: action2Button.currentTitle ?? "",
                    tokenSet: tokenSet
                ),
                maxWidth
            ),
            height: Self.height(
                action1Title: action1Button.currentTitle ?? "",
                action2Title: action2Button.currentTitle ?? "",
                containerWidth: maxWidth,
                tokenSet: tokenSet
            )
        )
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateAppearance()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        updateAppearance()
        action1Button.removeTarget(nil, action: nil, for: .allEvents)
        action2Button.removeTarget(nil, action: nil, for: .allEvents)
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }

    private func setupAction(_ button: UIButton) {
        button.titleLabel?.font = UIFont.fluent(tokenSet[.titleFont].fontInfo)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
    }

    private func layoutHorizontalSeparator(_ separator: Separator, with type: TableViewCell.SeparatorType, at verticalOffset: CGFloat) {
        let horizontalOffset = type == .inset ? safeAreaInsets.left + TableViewCellTokenSet.horizontalSpacing : 0

        separator.frame = CGRect(
            x: horizontalOffset,
            y: verticalOffset,
            width: frame.width - horizontalOffset,
            height: separator.frame.height
        )
        separator.flipForRTL()
    }

    private func updateHorizontalSeparator(_ separator: Separator, with type: TableViewCell.SeparatorType) {
        separator.isHidden = type == .none
        setNeedsLayout()
    }

    private func updateActionTitleColors() {
        action1Button.setTitleColor(action1Type.textColor(tokenSet: tokenSet), for: .normal)
        action1Button.setTitleColor(action1Type.highlightedTextColor(tokenSet: tokenSet), for: .highlighted)
        if !action2Button.isHidden {
            action2Button.setTitleColor(action2Type.textColor(tokenSet: tokenSet), for: .normal)
            action2Button.setTitleColor(action2Type.highlightedTextColor(tokenSet: tokenSet), for: .highlighted)
        }

    }

    private func setupBackgroundColors() {
        if backgroundStyleType != .custom {
            var customBackgroundConfig = UIBackgroundConfiguration.clear()
            customBackgroundConfig.backgroundColor = backgroundStyleType.defaultColor(tokenSet: tokenSet)
            backgroundConfiguration = customBackgroundConfig
        }
    }
}
