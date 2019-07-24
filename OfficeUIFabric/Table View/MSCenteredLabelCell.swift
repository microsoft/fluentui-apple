//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSCenteredLabelCell

open class MSCenteredLabelCell: UITableViewCell {
    public static let identifier: String = "MSCenteredLabelCell"
    public static let defaultHeight: CGFloat = 45

    private struct Constants {
        static let labelFont: UIFont = MSFonts.body
        static let paddingVerticalSmall: CGFloat = 5
    }

    // Public to be able to change style without wrapping every property
    public let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = Constants.labelFont
        label.textColor = MSColors.Table.CenteredLabelCell.text
        return label
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        backgroundColor = MSColors.Table.Cell.background
    }

    @objc public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let labelFittingSize = label.sizeThatFits(CGSize(width: contentView.width - layoutMargins.left - layoutMargins.right, height: CGFloat.greatestFiniteMagnitude))
        label.frame.size = labelFittingSize
        label.centerInSuperview()
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }
}
