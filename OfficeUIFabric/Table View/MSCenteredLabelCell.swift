//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

// MARK: MSCenteredLabelCell

open class MSCenteredLabelCell: UITableViewCell {
    public static let identifier = "MSCenteredLabelCell"
    public static let defaultHeight: CGFloat = 45

    private struct Constants {
        static let labelFont = MSFonts.body
        static let paddingVerticalSmall: CGFloat = 5
    }

    // Public to be able to change style without wrapping every property
    public let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = Constants.labelFont
        label.textColor = MSColors.centeredLabelText
        return label
    }()

    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
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

    override open func layoutSubviews() {
        super.layoutSubviews()
        let labelFittingSize = label.sizeThatFits(CGSize(width: contentView.width - layoutMargins.left - layoutMargins.right, height: CGFloat.greatestFiniteMagnitude))
        label.frame.size = labelFittingSize
        label.centerInSuperview()
    }

    override open func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    override open func setSelected(_ selected: Bool, animated: Bool) { }
}
