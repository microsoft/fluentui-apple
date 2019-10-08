//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSActionsCell

/**
 `MSActionsCell` is used to present a button or set of buttons (max of 2) as a row in a table view. After being added to the table view a target can be added to the button(s) with a corresponding action.

 `MSActionsCell` supports a maximum of 2 buttons that are displayed in a single row with a vertical separator between them. A button can be denoted 'destructive' by setting the 'action(X)ActionType' parameter to `.destructive`. When `.destructive`, this property causes the button to be displayed with red title label text to signify a 'destructive' action. When `.communication` is passed in, the button will be displayed with communication blue color.

 `topSeparatorType` and `bottomSeparatorType` can be used to show custom horizontal separators. Make sure to remove the `UITableViewCell` built-in separator by setting `separatorStyle = .none` on your table view.
 */
open class MSActionsCell: UITableViewCell {
    @objc(MSActionsCellActionType)
    public enum ActionType: Int {
        case regular
        case destructive
        case communication

        var highlightedTextColor: UIColor {
            switch self {
            case .regular:
                return MSColors.Table.ActionCell.textHighlighted
            case .destructive:
                return MSColors.Table.ActionCell.textDestructiveHighlighted
            case .communication:
                return MSColors.Table.ActionCell.textCommunicationHighlighted
            }
        }

        var textColor: UIColor {
            switch self {
            case .regular:
                return MSColors.Table.ActionCell.text
            case .destructive:
                return MSColors.Table.ActionCell.textDestructive
            case .communication:
                return MSColors.Table.ActionCell.textCommunication
            }
        }
    }

    private struct Constants {
        static let horizontalSpacing: CGFloat = 16
    }

    public static let defaultHeight: CGFloat = 45
    public static let identifier: String = "MSActionsCell"

    /// Style describing whether or not the cell's custom top separator should be visible and how wide it should extend
    @objc open var topSeparatorType: MSTableViewCell.SeparatorType = .none {
        didSet {
            if topSeparatorType != oldValue {
                updateHorizontalSeparator(topSeparator, with: topSeparatorType)
            }
        }
    }
    /// Style describing whether or not the cell's custom bottom separator should be visible and how wide it should extend
    @objc open var bottomSeparatorType: MSTableViewCell.SeparatorType = .none {
        didSet {
            if bottomSeparatorType != oldValue {
                updateHorizontalSeparator(bottomSeparator, with: bottomSeparatorType)
            }
        }
    }

    // By design, an actions cell has 2 actions at most
    @objc public let action1Button = UIButton()
    @objc public let action2Button = UIButton()

    private let topSeparator = MSSeparator(style: .default, orientation: .horizontal)
    private let bottomSeparator = MSSeparator(style: .default, orientation: .horizontal)
    private let verticalSeparator = MSSeparator(style: .default, orientation: .vertical)

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

        backgroundColor = MSColors.Table.Cell.background
        action1Button.titleLabel?.font = MSTableViewCell.TextStyles.title.font
        action2Button.titleLabel?.font = MSTableViewCell.TextStyles.title.font
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        action1Button.setTitleColor(action1Type.textColor, for: .normal)
        action1Button.setTitleColor(action1Type.highlightedTextColor, for: .highlighted)

        let hasAction = !action2Title.isEmpty
        if hasAction {
            action2Button.setTitle(action2Title, for: .normal)
            action2Button.setTitleColor(action2Type.textColor, for: .normal)
            action2Button.setTitleColor(action2Type.highlightedTextColor, for: .highlighted)
        }
        action2Button.isHidden = !hasAction
        verticalSeparator.isHidden = !hasAction
    }

    /// Sets up the action cell with 1 action
    @objc public func setup(action1Title: String, action1Type: ActionType = .regular) {
        setup(action1Title: action1Title, action2Title: "", action1Type: action1Type)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let actionCount: CGFloat = action2Button.isHidden ? 1 : 2
        let singleActionWidth = UIScreen.main.roundToDevicePixels(contentView.width / actionCount)
        var left: CGFloat = 0

        action1Button.frame = CGRect(x: left, y: 0, width: singleActionWidth, height: height)
        left += action1Button.width

        if actionCount > 1 {
            action2Button.frame = CGRect(x: left, y: 0, width: width - left, height: height)
            verticalSeparator.frame = CGRect(x: left, y: 0, width: verticalSeparator.width, height: height)
        }

        layoutHorizontalSeparator(topSeparator, with: topSeparatorType, at: 0)
        layoutHorizontalSeparator(bottomSeparator, with: bottomSeparatorType, at: height - bottomSeparator.height)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        action1Button.removeTarget(nil, action: nil, for: .allEvents)
        action2Button.removeTarget(nil, action: nil, for: .allEvents)
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }

    private func layoutHorizontalSeparator(_ separator: MSSeparator, with type: MSTableViewCell.SeparatorType, at verticalOffset: CGFloat) {
        let horizontalOffset = type == .inset ? safeAreaInsets.left + Constants.horizontalSpacing : 0

        separator.frame = CGRect(
            x: horizontalOffset,
            y: verticalOffset,
            width: width - horizontalOffset,
            height: separator.height
        )
        separator.flipForRTL()
    }

    private func updateHorizontalSeparator(_ separator: MSSeparator, with type: MSTableViewCell.SeparatorType) {
        separator.isHidden = type == .none
        setNeedsLayout()
    }
}
