//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Class that represents a file action that will be displayed in the cell accessory view.
@objc (MSFFileAccessoryViewAction)
open class FileAccessoryViewAction: NSObject {
    /// Default constructor for a document cell action.
    /// - Parameters:
    ///   - title: the action's title
    ///   - image: the action's image
    ///   - highlightedImage: the action's highlighted image
    ///   - target: the action's target
    ///   - action: the action's selector
    ///   - canHide: false if the action must always be visible, true otherwise
    public init(title: String, image: UIImage, highlightedImage: UIImage? = nil, target: Any? = nil, action: Selector? = nil, canHide: Bool = true) {
        self.title = title
        self.image = image
        self.highlightedImage = highlightedImage
        self.target = target
        self.action = action
        self.canHide = canHide

        super.init()
    }

    fileprivate let title: String
    fileprivate let image: UIImage
    fileprivate let highlightedImage: UIImage?
    fileprivate let target: Any?
    fileprivate let action: Selector?
    fileprivate let canHide: Bool
}

/// Class that represents a table view cell accessory view representing a file or folder.
@objc (TableViewCellFileAccessoryView)
open class TableViewCellFileAccessoryView: UIView {
    /// The date will be displayed in a friendly format in the accessory view's first column.
    @objc public var date: Date? {
        didSet {
            // TODO_
            let dateString = "Yesterday"
            dateLabel.text = dateString

            if (date == nil && oldValue != nil) || (oldValue == nil && date != nil) {
                updateLayout()
            }
        }
    }

    /// Set to true to display the shared status in the accessory view's second column, false otherwise.
    @objc public var showSharedStatus: Bool = false {
        didSet {
            if oldValue != showSharedStatus {
                // TODO_ only call if the shared status could currently be shown
                updateLayout()
            }
        }
    }

    /// Set to true to indicate that the document is shared with others, false otherwise.
    @objc public var isShared: Bool = false {
        didSet {
            // TODO_ update the shared status if displayed
        }
    }

    /// Actions to display in the accessory view's third column.
    /// Depending on the cell's width, some actions may be hidden.
    /// A maximum of 4 actions will be displayed.
    /// Actions with the smallest index in the array will have a higher priority for being displayed.
    @objc public var actions: [FileAccessoryViewAction] = [] {
        didSet {
            if !oldValue.elementsEqual(actions) {
                updateLayout()
            }
        }
    }

    /// The width of the table view cell that contains the accessory view.
    @objc public var cellWidth: CGFloat = 0 {
        didSet {
            updateLayout()
        }
    }

    @objc public weak var tableViewCell: TableViewCell?

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(columnStackView)

        NSLayoutConstraint.activate([
            columnStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            columnStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            columnStackView.topAnchor.constraint(equalTo: topAnchor),
            columnStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        columnStackView.addArrangedSubview(actionsStackView)

        updateLayout()
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private struct Constants {
        static let layoutBreakPoints: [CGFloat] = [424.0, 504.0, 584.0, 616.0, 752.0, 900.0, 924.0]
        static let maxVisibleActionCount: UInt8 = 4
        static let minimumViewHeight: CGFloat = 24.0
        static let actionsSpacingDefault: CGFloat = 16.0
        static let actionsSpacingLarge: CGFloat = 24.0
        static let columnSpacing: CGFloat = 48.0
        static let reservedCellSpace: [CGFloat] = [460.0, 600.0]
        static let columnMinWidth: CGFloat = 100.0
        static let sharedIconSize: CGFloat = 24.0
        static let sharedStatusSpacing: CGFloat = 8.0
    }

    private lazy var actionsStackView: UIStackView = {
        return createStackView()
    }()

    private lazy var columnStackView: UIStackView = {
        let columnStackView = createStackView()
        columnStackView.spacing = Constants.columnSpacing
        return columnStackView
    }()

    private func createStackView() -> UIStackView {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal

        return stackView
    }

    private lazy var dateLabel: Label = {
        let label = Label(style: .footnote, colorStyle: .secondary)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center

        return label
    }()

    private lazy var dateLabelWidth: NSLayoutConstraint = {
        return dateLabel.widthAnchor.constraint(equalToConstant: 0.0)
    }()

    private lazy var sharedStatusView: UIView = {
        let view = UIView(frame: .zero)

        let imageView = UIImageView()
        imageView.image = UIImage.staticImageNamed("shared-24x24")!.image(withPrimaryColor: Colors.gray500)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let label = Label(style: .footnote, colorStyle: .secondary)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.text = "Common.Shared".localized

        view.addSubview(imageView)
        view.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.sharedIconSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.sharedIconSize),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.sharedStatusSpacing),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }()

    private lazy var sharedStatusViewWidth: NSLayoutConstraint = {
        return sharedStatusView.widthAnchor.constraint(equalToConstant: 0.0)
    }()

    private func updateActions() {
        let spacing = (cellWidth < Constants.layoutBreakPoints[6]) ? Constants.actionsSpacingDefault : Constants.actionsSpacingLarge
        actionsStackView.spacing = spacing

        actionsStackView.removeAllSubviews()

        var maxActionCount: Int8 = 0

        if cellWidth < Constants.layoutBreakPoints[0] {
            maxActionCount = 1
        } else if cellWidth < Constants.layoutBreakPoints[1] {
            maxActionCount = 2
        } else if cellWidth < Constants.layoutBreakPoints[2] {
            maxActionCount = 3
        } else {
            maxActionCount = 4
        }

        var visibleActions: [FileAccessoryViewAction] = []
        for action in actions {
            if !action.canHide || visibleActions.count < maxActionCount {
                visibleActions.append(action)
            }
        }

        // Hide actions that can be hidden
        if visibleActions.count > maxActionCount {
            for (index, action) in visibleActions.reversed().enumerated() {
                if action.canHide {
                    visibleActions.remove(at: index)

                    if visibleActions.count == maxActionCount {
                        break
                    }
                }
            }
        }

        // If there are more than 4 must-show actions, only show the 4 first ones
        if visibleActions.count > Constants.maxVisibleActionCount {
            visibleActions = Array(visibleActions.prefix(Int(Constants.maxVisibleActionCount)))
        }

        for action in visibleActions.reversed() {
            let actionView = FileAccessoryViewActionView(action: action)
            actionsStackView.addArrangedSubview(actionView)
        }
    }

    private func updateLayout() {
        updateActions()

        let actionCount = actionsStackView.arrangedSubviews.count
        var width = CGFloat(actionCount) * FileAccessoryViewActionView.size
        if actionCount > 1 {
            width += CGFloat(actionCount - 1) * actionsStackView.spacing
        }

        var reservedCellSpace = Constants.reservedCellSpace[0]
        if cellWidth > Constants.layoutBreakPoints[6] {
            reservedCellSpace = Constants.reservedCellSpace[1]
        }

        let availableColumnSpace = cellWidth - reservedCellSpace - width
        let columnMinWidth = Constants.columnMinWidth + Constants.columnSpacing
        let canShowFirstColumn = cellWidth >= Constants.layoutBreakPoints[4] && availableColumnSpace > columnMinWidth
        let canShowSecondColumn = cellWidth >= Constants.layoutBreakPoints[5] && availableColumnSpace > 2 * columnMinWidth
        let isShowingDate = canShowFirstColumn && date != nil
        let isShowingSharedStatus = showSharedStatus && (canShowSecondColumn || (canShowFirstColumn && !isShowingDate))

        var columnWidth: CGFloat = 0.0
        if isShowingDate || isShowingSharedStatus {
            columnWidth = cellWidth - reservedCellSpace - width

            if isShowingDate && isShowingSharedStatus {
                columnWidth = round(columnWidth / 2.0)
                columnWidth -= Constants.columnSpacing
                width += columnWidth + Constants.columnSpacing
            }

            columnWidth -= Constants.columnSpacing
            width += columnWidth + Constants.columnSpacing
        }

        dateLabel.removeFromSuperview()
        if isShowingDate {
            columnStackView.insertArrangedSubview(dateLabel, at: 0)
            dateLabelWidth.constant = columnWidth
        }

        sharedStatusView.removeFromSuperview()
        if isShowingSharedStatus {
            columnStackView.insertArrangedSubview(sharedStatusView, at: (isShowingDate ? 1 : 0))
            sharedStatusViewWidth.constant = columnWidth
        }

        let newFrame = CGRect(x: 0.0, y: 0.0, width: width, height: FileAccessoryViewActionView.size) // TODO_C calculate height based off of labels

        if !frame.equalTo(newFrame) {
            frame = newFrame
            tableViewCell?.setNeedsLayout()
        }
    }
}

// MARK: - TableViewCellFileAccessoryView: TableViewCellDelegate

extension TableViewCellFileAccessoryView: TableViewCellDelegate {
    public func tableViewCellSizeDidChange(_ tableViewCell: TableViewCell) {
        cellWidth = tableViewCell.bounds.width
    }
}

private class FileAccessoryViewActionView: UIButton {
    fileprivate static let size: CGFloat = 24.0

    fileprivate init(action: FileAccessoryViewAction) {
        super.init(frame: .zero)

        accessibilityLabel = action.title

        if let target = action.target, let action = action.action {
            addTarget(target, action: action, for: .touchUpInside)
        }

        setImage(action.image.image(withPrimaryColor: Colors.gray500), for: .normal)
        setImage(action.highlightedImage?.image(withPrimaryColor: Colors.gray500), for: .highlighted)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: FileAccessoryViewActionView.size),
            heightAnchor.constraint(equalToConstant: FileAccessoryViewActionView.size)
        ])
    }

    @available(*, unavailable)
    @objc public override init(frame: CGRect) {
        preconditionFailure("init(frame:) has not been implemented")
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
}
