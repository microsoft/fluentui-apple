//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: CenteredLabelCell

@objc(MSFCenteredLabelCell)
open class CenteredLabelCell: UITableViewCell, TokenizedControlInternal {
    public static let identifier: String = "CenteredLabelCell"

    // MARK: - CenteredLabelCell TokenizedControl
    @objc public var centeredLabelCellOverrideTokens: TableViewCellTokens? {
        didSet {
            self.overrideTokens = centeredLabelCellOverrideTokens
        }
    }

    let defaultTokens: TableViewCellTokens = .init()
    var tokens: TableViewCellTokens = .init()
    /// Design token set for this control, to use in place of the control's default Fluent tokens.
    var overrideTokens: TableViewCellTokens? {
        didSet {
            updateTokens()
        }
    }

    public func overrideTokens(_ tokens: TableViewCellTokens?) -> Self {
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
        backgroundColor = UIColor(dynamicColor: tokens.cellBackgroundColor)
        label.font = UIFont.fluent(tokens.titleFont)
        label.textColor = UIColor(dynamicColor: tokens.mainBrandColor)
    }

    // Public to be able to change style without wrapping every property
    public let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        contentView.addSubview(label)
    }

    @objc public required init(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Set up the cell with text to be displayed in the centered label
    ///
    /// - Parameter text: The text to be displayed
    @objc open func setup(text: String) {
        label.text = text
        label.font = UIFont.fluent(tokens.titleFont)
        label.textColor = UIColor(dynamicColor: tokens.mainBrandColor)
        setNeedsLayout()
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxWidth = size.width != 0 ? size.width : .infinity

        let labelWidthArea = maxWidth - layoutMargins.left - layoutMargins.right
        let labelFittingSize = label.sizeThatFits(CGSize(width: labelWidthArea, height: CGFloat.greatestFiniteMagnitude))
        let height = max(tokens.paddingVertical * 2 + ceil(labelFittingSize.height), tokens.minHeight)
        return CGSize(width: maxWidth, height: height)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let labelFittingSize = label.sizeThatFits(CGSize(width: contentView.frame.width - layoutMargins.left - layoutMargins.right, height: CGFloat.greatestFiniteMagnitude))
        label.frame.size = labelFittingSize
        label.centerInSuperview()
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        updateTokens()
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }
}
