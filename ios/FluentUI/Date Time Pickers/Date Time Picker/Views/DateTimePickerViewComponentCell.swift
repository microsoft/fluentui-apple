//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: DateTimePicker Colors
public extension Colors {
  struct DateTimePicker {
      public static var background: UIColor = Calendar.background
      public static var text: UIColor = textSecondary
  }
}

// MARK: - DateTimePickerViewComponentCell

/// TableViewCell representing the cell of component view (should be used only by DateTimePickerViewComponent and not instantiated on its own)
class DateTimePickerViewComponentCell: UITableViewCell {
    private struct Constants {
        static let baseHeight: CGFloat = 45
        static let verticalPadding: CGFloat = 12
        static let maximumFontSize: CGFloat = 33.0
        static let normalTextColor: UIColor = Colors.DateTimePicker.text
    }

    static let identifier: String = "DateTimePickerViewComponentCell"

    class var idealHeight: CGFloat {
        return max(Constants.verticalPadding * 2 + Fonts.body.deviceLineHeight, Constants.baseHeight)
    }

    var emphasized: Bool = false {
        didSet {
            if emphasized {
                textLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: Fonts.headline, maximumPointSize: Constants.maximumFontSize)
            } else {
                textLabel?.font = UIFontMetrics.default.scaledFont(for: Fonts.body, maximumPointSize: Constants.maximumFontSize)
            }
            updateTextLabelColor()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        backgroundColor = nil

        textLabel?.textAlignment = .center
        textLabel?.font = UIFontMetrics.default.scaledFont(for: Fonts.body, maximumPointSize: Constants.maximumFontSize)
        textLabel?.textColor = Constants.normalTextColor
        textLabel?.showsLargeContentViewer = true
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
        if let window = window {
            textLabel?.textColor = emphasized ? Colors.primary(for: window) : Constants.normalTextColor
        }
    }
}
