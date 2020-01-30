//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: MSCalendarViewDayTodayCell

class MSCalendarViewDayTodayCell: MSCalendarViewDayCell {
    override class var identifier: String { return "MSCalendarViewDayTodayCell" }

    override var isSelected: Bool {
        didSet {
            configureBackgroundColor()
            configureFontColor()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            configureBackgroundColor()
            configureFontColor()
        }
    }

    // Only supports indicator levels from 0...4
    override func setup(textStyle: MSCalendarViewDayCellTextStyle, backgroundStyle: MSCalendarViewDayCellBackgroundStyle, selectionStyle: MSCalendarViewDayCellSelectionStyle, dateLabelText: String, indicatorLevel: Int) {
        super.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, dateLabelText: dateLabelText, indicatorLevel: indicatorLevel)

        configureBackgroundColor()
        configureFontColor()
    }

    private func configureBackgroundColor() {
        if isHighlighted || isSelected {
            switch backgroundStyle {
            case .primary:
                contentView.backgroundColor = MSColors.Calendar.Day.backgroundPrimary
            case .secondary:
                contentView.backgroundColor = MSColors.Calendar.Day.backgroundSecondary
            }
        } else {
            contentView.backgroundColor = MSColors.Calendar.Today.background
        }
    }

    private func configureFontColor() {
        if isHighlighted || isSelected {
            dateLabel.font = MSFonts.body
            dateLabel.textColor = MSColors.Calendar.Day.textSelected
        } else {
            dateLabel.font = MSFonts.headline
            switch textStyle {
            case .primary:
                dateLabel.textColor = MSColors.Calendar.Day.textPrimary
                dotView.color = MSColors.Calendar.Day.textPrimary
            case .secondary:
                dateLabel.textColor = MSColors.Calendar.Day.textSecondary
                dotView.color = MSColors.Calendar.Day.textSecondary
            }
        }
    }
}
