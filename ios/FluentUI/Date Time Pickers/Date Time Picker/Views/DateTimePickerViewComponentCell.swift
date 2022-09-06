//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - DateTimePickerViewComponentCell

/// TableViewCell representing the cell of component view (should be used only by DateTimePickerViewComponent and not instantiated on its own)
class DateTimePickerViewComponentCell: UITableViewCell {
    private struct Constants {
        static let baseHeight: CGFloat = 45
        static let verticalPadding: CGFloat = 12
        static let maximumFontSize: CGFloat = 33.0
    }

    static let identifier: String = "DateTimePickerViewComponentCell"

    class var idealHeight: CGFloat {
        return max(Constants.verticalPadding * 2 + Fonts.body.deviceLineHeight, Constants.baseHeight)
    }

    var emphasized: Bool = false {
        didSet {
            updateTextLabelColor()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.background2])

        updateTextLabelColor()

        textLabel?.textAlignment = .center
        textLabel?.showsLargeContentViewer = true
        textLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont.fluent(fluentTheme.aliasTokens.typography[.body1], shouldScale: false), maximumPointSize: Constants.maximumFontSize)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        emphasized = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = bounds
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Override -> No selection
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Override -> No highlight
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updateTextLabelColor()
    }

    private func updateTextLabelColor() {
        textLabel?.textColor = emphasized ? UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.brandForeground1]) : UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground3])
    }
}
