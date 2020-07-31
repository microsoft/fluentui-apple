//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: Calendar Colors

public extension Colors {
    struct Calendar {
        public struct Day {
            public static var textPrimary: UIColor = Colors.textPrimary
            public static var textSecondary: UIColor = Colors.textSecondary
            public static var textSelected: UIColor = textOnAccent
            public static var backgroundPrimary = UIColor(light: Calendar.background, dark: surfaceSecondary)
            public static var backgroundSecondary = UIColor(light: surfaceSecondary, dark: Calendar.background)
            public static var circleHighlighted: UIColor = gray400
        }
        public struct Today {
            public static var background: UIColor = Calendar.Day.backgroundPrimary
        }
        public struct WeekdayHeading {
            public struct Light {
                public static var textRegular = UIColor(light: gray600, lightHighContrast: gray700, dark: textPrimary)
                public static var textWeekend: UIColor = textSecondary
                public static var background: UIColor = Calendar.background
            }
            public struct Dark {
                public static var textRegular: UIColor = textOnAccent
                public static var textWeekend: UIColor = textOnAccent.withAlphaComponent(0.7)
            }
        }
        public static var background = UIColor(light: surfacePrimary, dark: surfaceTertiary)
    }
}

// MARK: - CalendarViewDayMonthCell

class CalendarViewDayMonthCell: CalendarViewDayCell {
    struct Constants {
        static let monthLabelMargin: CGFloat = 2.0
    }

    override class var identifier: String { return "CalendarViewDayMonthCell" }

    override var isSelected: Bool {
        didSet {
            monthLabel.isHidden = isSelected
        }
    }

    override var isHighlighted: Bool {
        didSet {
            monthLabel.isHidden = isHighlighted
        }
    }

    let monthLabel: UILabel

    override init(frame: CGRect) {
        monthLabel = UILabel(frame: CGRect.zero)
        monthLabel.font = Fonts.caption1
        monthLabel.textAlignment = .center
        monthLabel.textColor = Colors.Calendar.Day.textPrimary

        super.init(frame: frame)

        contentView.addSubview(monthLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func setup(textStyle: CalendarViewDayCellTextStyle, backgroundStyle: CalendarViewDayCellBackgroundStyle, selectionStyle: CalendarViewDayCellSelectionStyle, dateLabelText: String, indicatorLevel: Int) {
        preconditionFailure("Use setup(textStyle, backgroundStyle, selectionStyle, monthLabelText, dateLabelText, indicatorLevel) instead")
    }

    // Only supports indicator levels from 0...4
    func setup(textStyle: CalendarViewDayCellTextStyle, backgroundStyle: CalendarViewDayCellBackgroundStyle, selectionStyle: CalendarViewDayCellSelectionStyle, monthLabelText: String, dateLabelText: String, indicatorLevel: Int) {
        super.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, dateLabelText: dateLabelText, indicatorLevel: indicatorLevel)

        switch textStyle {
        case .primary:
            monthLabel.textColor = Colors.Calendar.Day.textPrimary
        case .secondary:
            monthLabel.textColor = Colors.Calendar.Day.textSecondary
        }

        monthLabel.text = monthLabelText
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let maxWidth = bounds.size.width
        let maxHeight = bounds.size.height

        monthLabel.frame = CGRect(x: 0.0, y: Constants.monthLabelMargin, width: maxWidth, height: maxHeight / 2.0)

        if !isSelected && !isHighlighted {
            dateLabel.frame = CGRect(x: 0.0, y: (maxHeight / 2.0) - Constants.monthLabelMargin, width: maxWidth, height: maxHeight / 2.0)
        }

        dotView.frame = .zero
    }
}
