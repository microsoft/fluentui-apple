//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import Combine

// MARK: CenteredLabelCell

@objc(MSFCenteredLabelCell)
open class CenteredLabelCell: UITableViewCell, TokenizedControlInternal {
    public static let identifier: String = "CenteredLabelCell"

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
        label.font = UIFont.fluent(tokenSet[.titleFont].fontInfo)
        label.textColor = UIColor(dynamicColor: tokenSet[.brandTextColor].dynamicColor)
    }

    // Public to be able to change style without wrapping every property
    public let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    @objc public var backgroundStyleType: TableViewCellBackgroundStyleType = .plain {
        didSet {
            if backgroundStyleType != oldValue {
                setupBackgroundColors()
            }
        }
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        tokenSet = TableViewCellTokenSet(customViewSize: { .default })
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        contentView.addSubview(label)
        setupBackgroundColors()

        // Update appearance whenever `tokenSet` changes.
        tokenSetSink = tokenSet.sinkChanges { [weak self] in
            self?.updateAppearance()
        }
    }

    @objc public required init(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Set up the cell with text to be displayed in the centered label
    ///
    /// - Parameter text: The text to be displayed
    @objc open func setup(text: String) {
        label.text = text
        label.font = UIFont.fluent(tokenSet[.titleFont].fontInfo)
        label.textColor = UIColor(dynamicColor: tokenSet[.brandTextColor].dynamicColor)
        setNeedsLayout()
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxWidth = size.width != 0 ? size.width : .infinity

        let labelWidthArea = maxWidth - layoutMargins.left - layoutMargins.right
        let labelFittingSize = label.sizeThatFits(CGSize(width: labelWidthArea, height: CGFloat.greatestFiniteMagnitude))
        let height = max(TableViewCellTokenSet.paddingVertical * 2 + ceil(labelFittingSize.height),
                         TableViewCellTokenSet.oneLineMinHeight)
        return CGSize(width: maxWidth, height: height)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let labelFittingSize = label.sizeThatFits(CGSize(width: contentView.frame.width - layoutMargins.left - layoutMargins.right, height: CGFloat.greatestFiniteMagnitude))
        label.frame.size = labelFittingSize
        label.centerInSuperview()
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateAppearance()
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }

    private func setupBackgroundColors() {
        if backgroundStyleType != .custom {
            var customBackgroundConfig = UIBackgroundConfiguration.clear()
            customBackgroundConfig.backgroundColor = backgroundStyleType.defaultColor(tokenSet: tokenSet)
            backgroundConfiguration = customBackgroundConfig
        }
    }
}
