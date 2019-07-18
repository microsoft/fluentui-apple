//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSDateTimePickerViewComponentCell

/// TableViewCell representing the cell of component view (should be used only by MSDateTimePickerViewComponent and not instantiated on its own)
class MSDateTimePickerViewComponentCell: UITableViewCell {
    private struct Constants {
        static let baseHeight: CGFloat = 45
        static let normalFont: UIFont = MSFonts.body
        static let emphasizedFont: UIFont = MSFonts.headline
        static let normalTextColor: UIColor = MSColors.DateTimePicker.text
        static let emphasizedTextColor: UIColor = MSColors.DateTimePicker.textEmphasized
        static let verticalPadding: CGFloat = (baseHeight - Constants.normalFont.deviceLineHeight) / 2
    }

    static let identifier: String = "MSDateTimePickerViewComponentCell"

    class var idealHeight: CGFloat {
        return max(Constants.verticalPadding * 2 + Constants.normalFont.deviceLineHeight, Constants.baseHeight)
    }

    var emphasized: Bool = false {
        didSet {
            textLabel?.font = emphasized ? Constants.emphasizedFont: Constants.normalFont
            textLabel?.textColor = emphasized ? Constants.emphasizedTextColor : Constants.normalTextColor
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        backgroundColor = nil

        textLabel?.textAlignment = .center
        textLabel?.font = Constants.normalFont
        textLabel?.textColor = Constants.normalTextColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
