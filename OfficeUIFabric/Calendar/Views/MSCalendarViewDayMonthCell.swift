//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: MSCalendarViewDayMonthCell

class MSCalendarViewDayMonthCell: MSCalendarViewDayCell {
    struct Constants {
        static let monthLabelMargin: CGFloat = 2.0
    }

    override class var identifier: String { return "MSCalendarViewDayMonthCell" }

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
        monthLabel.font = MSFonts.caption1
        monthLabel.textAlignment = .center
        monthLabel.textColor = MSColors.CalendarView.DayCell.textColorPrimary

        super.init(frame: frame)

        contentView.addSubview(monthLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup(textStyle: MSCalendarViewDayCellTextStyle, backgroundStyle: MSCalendarViewDayCellBackgroundStyle, selectionStyle: MSCalendarViewDayCellSelectionStyle, dateLabelText: String, indicatorLevel: Int) {
        fatalError("Use setup(textStyle, backgroundStyle, selectionStyle, monthLabelText, dateLabelText, indicatorLevel) instead")
    }

    // Only supports indicator levels from 0...4
    func setup(textStyle: MSCalendarViewDayCellTextStyle, backgroundStyle: MSCalendarViewDayCellBackgroundStyle, selectionStyle: MSCalendarViewDayCellSelectionStyle, monthLabelText: String, dateLabelText: String, indicatorLevel: Int) {
        super.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, dateLabelText: dateLabelText, indicatorLevel: indicatorLevel)

        switch textStyle {
        case .primary:
            monthLabel.textColor = MSColors.CalendarView.DayCell.textColorPrimary
        case .secondary:
            monthLabel.textColor = MSColors.CalendarView.DayCell.textColorSecondary
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
