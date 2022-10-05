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

        configureBackgroundColor()
        configureFontColor()
    }

    @objc override func themeDidChange(_ notification: Notification) {
        super.themeDidChange(notification)
        configureBackgroundColor()
        configureFontColor()
    }

    private func configureBackgroundColor() {
        contentView.backgroundColor = UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.background2].light, dark: fluentTheme.aliasTokens.colors[.background2].dark))
    }

    private func configureFontColor() {
        dateLabel.font = UIFont.fluent(fluentTheme.aliasTokens.typography[.body1])

        if isHighlighted || isSelected {
            dateLabel.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foregroundOnColor])
            dateLabel.showsLargeContentViewer = true
        } else {
            switch textStyle {
            case .primary:
                dateLabel.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1])
            case .secondary:
                dateLabel.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground3])
            }
        }
    }
}
