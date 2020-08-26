//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - FileAccessoryViewAction

/// Class that represents a file action that will be displayed in the cell accessory view.
@objc (MSFFileAccessoryViewAction)
open class FileAccessoryViewAction: NSObject {
    /// Default constructor for a document cell action.
    /// - Parameters:
    ///   - title: the action's title
    ///   - image: the action's image
    ///   - target: the action's target
    ///   - action: the action's selector
    ///   - isEnabled: true if the action is enabled, false otherwise
    ///   - canHide: false if the action must always be visible, true otherwise
    ///   - useAppPrimaryColor: true if the action's image should be tinted with the app's primary color
    @objc public init(title: String, image: UIImage, target: Any? = nil, action: Selector? = nil, isEnabled: Bool = true, canHide: Bool = true, useAppPrimaryColor: Bool = false) {
        self.title = title
        self.image = image
        self.target = target
        self.action = action
        self.isEnabled = isEnabled
        self.canHide = canHide
        self.useAppPrimaryColor = useAppPrimaryColor

        super.init()
    }

    fileprivate let title: String
    fileprivate let image: UIImage
    fileprivate let target: Any?
    fileprivate let action: Selector?
    fileprivate let isEnabled: Bool
    fileprivate let canHide: Bool
    fileprivate let useAppPrimaryColor: Bool
}

// MARK: - TableViewCellFileAccessoryView

/// Class that represents a table view cell accessory view representing a file or folder.
@objc (MSFTableViewCellFileAccessoryView)
open class TableViewCellFileAccessoryView: UIView {
    /// The date will be displayed in a friendly format in the accessory view's first column.
    @objc public var date: Date? {
        didSet {
            updateDateLabel()

            if tableViewCell != nil && (date == nil && oldValue != nil) || (oldValue == nil && date != nil) {
                updateLayout()
            }
        }
    }

    /// Set to true to display the shared status in the accessory view's second column, false otherwise.
    @objc public var showSharedStatus: Bool = false {
        didSet {
            if tableViewCell != nil && oldValue != showSharedStatus {
                updateLayout()
            }
        }
    }

    /// Set to true to indicate that the document is shared with others, false otherwise.
    @objc public var isShared: Bool = false {
        didSet {
            updateSharedStatus()
        }
    }

    /// Actions to display in the accessory view's third column.
    /// Depending on the cell's width, some actions may be hidden.
    /// A maximum of 4 actions will be displayed.
    /// Actions with the smallest index in the array will have a higher priority for being displayed.
    @objc public var actions: [FileAccessoryViewAction] = [] {
        didSet {
            if tableViewCell != nil && !oldValue.elementsEqual(actions) {
                updateLayout()
            }
        }
    }

    @objc public weak var tableViewCell: TableViewCell? {
        didSet {
            updateLayout()
        }
    }

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(columnStackView)

        NSLayoutConstraint.activate([
            columnStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            columnStackView.topAnchor.constraint(equalTo: topAnchor),
            columnStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        columnStackView.addArrangedSubview(actionsStackView)

        updateSharedStatus()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLayout),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if let tableViewCell = tableViewCell {
            if !tableViewCell.bounds.equalTo(previousBounds) {
                previousBounds = tableViewCell.bounds

                updateLayout()
            }
        }
    }

    private struct Constants {
        static let layoutBreakPoints: [CGFloat] = [424, 504, 584, 616, 752, 900, 1092]
        static let maxVisibleActionCount: UInt8 = 4
        static let minimumViewHeight: CGFloat = 24
        static let actionsSpacingDefault: CGFloat = 16
        static let actionsSpacingLarge: CGFloat = 24
        static let columnSpacing: CGFloat = 24
        static let leadingOffset: CGFloat = 8
        static let reservedCellSpace: [CGFloat] = [460, 600]
        static let columnMinWidth: CGFloat = 150
        static let fullDateMinWidth: CGFloat = 170
        static let sharedIconSize: CGFloat = 24
        static let sharedStatusSpacing: CGFloat = 8
    }

    private lazy var actionsStackView: UIStackView = {
        let stackView = createHorizontalStackView()

        if #available(iOS 13, *) {
            stackView.addInteraction(UILargeContentViewerInteraction())
        }

        return stackView
    }()

    private lazy var columnStackView: UIStackView = {
        let columnStackView = createHorizontalStackView()
        columnStackView.spacing = Constants.columnSpacing

        return columnStackView
    }()

    private func createHorizontalStackView() -> UIStackView {
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
        return dateLabel.widthAnchor.constraint(equalToConstant: 0)
    }()

    private func updateSharedStatus() {
        let imageName = isShared ? "ic_fluent_people_24_regular" : "ic_fluent_person_24_regular"
        sharedStatusImageView.image = UIImage.staticImageNamed(imageName)!.image(withPrimaryColor: Colors.gray500)
        sharedStatusLabel.text = isShared ? "Common.Shared".localized : "Common.OnlyMe".localized
    }

    private lazy var sharedStatusLabel: Label = {
        let label = Label(style: .footnote, colorStyle: .secondary)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .natural

        return label
    }()

    private lazy var sharedStatusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var sharedStatusView: UIView = {
        let containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)

        view.addSubview(sharedStatusImageView)
        view.addSubview(sharedStatusLabel)

        NSLayoutConstraint.activate([
            sharedStatusImageView.widthAnchor.constraint(equalToConstant: Constants.sharedIconSize),
            sharedStatusImageView.heightAnchor.constraint(equalToConstant: Constants.sharedIconSize),
            sharedStatusImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sharedStatusImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sharedStatusLabel.leadingAnchor.constraint(equalTo: sharedStatusImageView.trailingAnchor, constant: Constants.sharedStatusSpacing),
            sharedStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sharedStatusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return containerView
    }()

    private lazy var sharedStatusViewWidth: NSLayoutConstraint = {
        return sharedStatusView.widthAnchor.constraint(equalToConstant: 0)
    }()

    private func updateActions() {
        let cellSize = tableViewCell?.frame.size ?? .zero
        let spacing = (cellSize.width < Constants.layoutBreakPoints[6]) ? Constants.actionsSpacingDefault : Constants.actionsSpacingLarge
        actionsStackView.spacing = spacing

        actionsStackView.removeAllSubviews()

        var maxActionCount: Int8 = 0

        if cellSize.width < Constants.layoutBreakPoints[0] {
            maxActionCount = 1
        } else if cellSize.width < Constants.layoutBreakPoints[1] {
            maxActionCount = 2
        } else if cellSize.width < Constants.layoutBreakPoints[2] {
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
                    visibleActions.remove(at: visibleActions.count - index - 1)

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

        // If the window is not available yet, default to a random window.
        // This method will eventually get called once the view is installed in a window.
        let currentWindow = window ?? UIApplication.shared.windows.first!
        for action in visibleActions.reversed() {
            let actionView = FileAccessoryViewActionView(action: action, window: currentWindow)
            actionsStackView.addArrangedSubview(actionView)
        }
    }

    private func updateDateLabel() {
        let dateString = date?.displayString(short: (dateLabelWidth.constant < Constants.fullDateMinWidth)) ?? ""
        dateLabel.text = dateString
    }

    @objc private func updateLayout() {
        updateActions()

        let actionCount = actionsStackView.arrangedSubviews.count
        var width = CGFloat(actionCount) * FileAccessoryViewActionView.size.width
        if actionCount > 1 {
            width += CGFloat(actionCount - 1) * actionsStackView.spacing
        }

        let cellSize = tableViewCell?.frame.size ?? .zero
        var reservedCellSpace = Constants.reservedCellSpace[0]
        if cellSize.width > Constants.layoutBreakPoints[6] {
            reservedCellSpace = Constants.reservedCellSpace[1]
        }

        let availableColumnSpace = cellSize.width - reservedCellSpace - width
        let columnMinWidth = Constants.columnMinWidth + Constants.columnSpacing
        let canShowFirstColumn = cellSize.width >= Constants.layoutBreakPoints[4] && availableColumnSpace > columnMinWidth
        let canShowSecondColumn = cellSize.width >= Constants.layoutBreakPoints[5] && availableColumnSpace > 2 * columnMinWidth && UIApplication.shared.preferredContentSizeCategory.canShowSharedStatus
        let isShowingDate = canShowFirstColumn && date != nil
        let isShowingSharedStatus = showSharedStatus && (canShowSecondColumn || (canShowFirstColumn && !isShowingDate))

        var columnWidth: CGFloat = 0
        if isShowingDate || isShowingSharedStatus {
            columnWidth = availableColumnSpace

            if isShowingDate && isShowingSharedStatus {
                columnWidth = round(columnWidth / 2) - 2 * Constants.columnSpacing
                width += 2 * columnWidth + 2 * Constants.columnSpacing - Constants.leadingOffset
            } else {
                width += columnWidth
                columnWidth -= 2 * Constants.columnSpacing - Constants.leadingOffset
            }
        }

        dateLabel.removeFromSuperview()
        if isShowingDate {
            columnStackView.insertArrangedSubview(dateLabel, at: 0)
            dateLabelWidth.constant = columnWidth
            dateLabelWidth.isActive = true

            updateDateLabel()
        }

        sharedStatusView.removeFromSuperview()
        if isShowingSharedStatus {
            columnStackView.insertArrangedSubview(sharedStatusView, at: (isShowingDate ? 1 : 0))
            sharedStatusViewWidth.constant = columnWidth
            sharedStatusViewWidth.isActive = true
        }

        if isShowingDate && isShowingSharedStatus {
            columnStackView.setCustomSpacing(0, after: dateLabel)
        }

        var height: CGFloat = FileAccessoryViewActionView.size.height
        if isShowingDate {
            height = max(height, dateLabel.intrinsicContentSize.height)
        }

        if isShowingSharedStatus {
            height = max(height, sharedStatusLabel.intrinsicContentSize.height)
        }

        let newFrame = CGRect(x: 0, y: 0, width: width, height: height)

        if !frame.equalTo(newFrame) {
            frame = newFrame
            tableViewCell?.setNeedsLayout()
        }
    }

    private var previousBounds: CGRect = .zero
}

// MARK: - FileAccessoryViewActionView

private class FileAccessoryViewActionView: UIButton {
    fileprivate static let size = CGSize(width: 24, height: 60)

    fileprivate init(action: FileAccessoryViewAction, window: UIWindow) {
        super.init(frame: .zero)

        accessibilityLabel = action.title

        if let target = action.target, let action = action.action {
            addTarget(target, action: action, for: .touchUpInside)
        }

        isEnabled = action.isEnabled
        setImage(action.image, for: .normal)

        if action.useAppPrimaryColor {
            tintColor = Colors.primary(for: window)
        } else if action.isEnabled {
            tintColor = Colors.iconSecondary
        } else {
            tintColor = Colors.iconDisabled
        }

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: FileAccessoryViewActionView.size.width),
            heightAnchor.constraint(greaterThanOrEqualToConstant: FileAccessoryViewActionView.size.height)
        ])

        if #available(iOS 13, *) {
            showsLargeContentViewer = true
            scalesLargeContentImage = true
            largeContentTitle = action.title
        }
    }

    @available(*, unavailable)
    @objc public override init(frame: CGRect) {
        preconditionFailure("init(frame:) has not been implemented")
    }

    @available(*, unavailable)
    @objc public required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // When the button is disabled, we still need to capture touch events to prevent them from
        // being forwarded to the table view cell.
        if !isEnabled && self.point(inside: convert(point, to: self), with: event) {
            return touchIntercept
        }

        return super.hitTest(point, with: event)
    }

    private let touchIntercept: UIView = {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = true

        return view
    }()
}

extension UIContentSizeCategory {
    var canShowSharedStatus: Bool {
        switch self {
        case .accessibilityExtraExtraExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraLarge, .accessibilityLarge, .accessibilityMedium:
            return false
        default:
            return true
        }
    }
}
