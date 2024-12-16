//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: CalendarViewDayTodayCell

class CalendarViewDayTodayCell: CalendarViewDayCell {
    override class var identifier: String { return "CalendarViewDayTodayCell" }

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
    override func setup(textStyle: CalendarViewDayCellTextStyle,
                        backgroundStyle: CalendarViewDayCellBackgroundStyle,
                        selectionStyle: CalendarViewDayCellSelectionStyle,
                        dateLabelText: String,
                        indicatorLevel: Int) {
        super.setup(textStyle: textStyle,
                    backgroundStyle: backgroundStyle,
                    selectionStyle: selectionStyle,
                    dateLabelText: dateLabelText,
                    indicatorLevel: indicatorLevel)

        updateAppearance()
    }

    override func updateAppearance() {
        super.updateAppearance()
        configureBackgroundColor()
        configureFontColor()
    }

    private func configureBackgroundColor() {
        contentView.backgroundColor = UIColor(light: fluentTheme.color(.background2).light,
                                              dark: fluentTheme.color(.background2).dark)
    }

    private func configureFontColor() {
        dateLabel.font = fluentTheme.typography(.body1)

        if isHighlighted || isSelected {
            dateLabel.textColor = fluentTheme.color(.foregroundOnColor)
            dateLabel.showsLargeContentViewer = true
        } else {
            switch textStyle {
            case .primary:
                dateLabel.textColor = fluentTheme.color(.foreground1)
            case .secondary:
                dateLabel.textColor = fluentTheme.color(.foreground3)
            }
        }
    }
}
