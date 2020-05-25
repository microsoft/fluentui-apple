//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: CenteredLabelCell

@available(*, deprecated, renamed: "CenteredLabelCell")
public typealias MSCenteredLabelCell = CenteredLabelCell

@objc(MSFCenteredLabelCell)
open class CenteredLabelCell: UITableViewCell {
    public static let identifier: String = "CenteredLabelCell"
    public static let defaultHeight: CGFloat = 45

    private struct Constants {
        static let labelFont: UIFont = Fonts.body
        static let paddingVerticalSmall: CGFloat = 5
    }

    // Public to be able to change style without wrapping every property
    public let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = Constants.labelFont
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
    open func setup(text: String) {
        label.text = text
        setNeedsLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let labelFittingSize = label.sizeThatFits(CGSize(width: contentView.frame.width - layoutMargins.left - layoutMargins.right, height: CGFloat.greatestFiniteMagnitude))
        label.frame.size = labelFittingSize
        label.centerInSuperview()
    }

    open override func didMoveToWindow() {
        if let window = window {
            label.textColor = Colors.primary(for: window)
        }
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }
}
