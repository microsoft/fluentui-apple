//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: CenteredLabelCell

@objc(MSFCenteredLabelCell)
open class CenteredLabelCell: UITableViewCell {
    public static let identifier: String = "CenteredLabelCell"

    // Public to be able to change style without wrapping every property
    public let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = Constants.labelFont
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        backgroundColor = Colors.Table.Cell.background
    }

    @objc public required init(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /// Set up the cell with text to be displayed in the centered label
    ///
    /// - Parameter text: The text to be displayed
    @objc open func setup(text: String) {
        label.text = text
        setNeedsLayout()
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxWidth = size.width != 0 ? size.width : .infinity

        let labelWidthArea = maxWidth - layoutMargins.left - layoutMargins.right
        let labelFittingSize = label.sizeThatFits(CGSize(width: labelWidthArea, height: CGFloat.greatestFiniteMagnitude))
        let height = max(Constants.paddingVertical * 2 + ceil(labelFittingSize.height), Constants.defaultHeight)
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
        if let window = window {
            label.textColor = Colors.primary(for: window)
        }
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }

    private struct Constants {
        static let labelFont: UIFont = Fonts.body
        static let paddingVertical: CGFloat = 11
        static let defaultHeight: CGFloat = 48
    }
}
