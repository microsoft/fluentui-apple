//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: CalendarViewDayMonthYearCell

class CalendarViewDayMonthYearCell: CalendarViewDayMonthCell {
    override class var identifier: String { return "CalendarViewDayMonthYearCell" }

    override var isSelected: Bool {
        didSet {
            yearLabel.isHidden = isSelected
        }
    }

    override var isHighlighted: Bool {
        didSet {
            yearLabel.isHidden = isHighlighted
        }
    }

    let yearLabel: UILabel

    override init(frame: CGRect) {
        yearLabel = UILabel(frame: .zero)
        yearLabel.font = Fonts.caption1
        yearLabel.textAlignment = .center
        yearLabel.textColor = Colors.Calendar.Day.textPrimary

        super.init(frame: frame)

        contentView.addSubview(yearLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func setup(textStyle: CalendarViewDayCellTextStyle, backgroundStyle: CalendarViewDayCellBackgroundStyle, selectionStyle: CalendarViewDayCellSelectionStyle, dateLabelText: String, indicatorLevel: Int) {
        preconditionFailure("Use setup(textStyle, backgroundStyle, selectionStyle, monthLabelText, dateLabelText, yearLabelText, indicatorLevel) instead")
    }

    override func setup(textStyle: CalendarViewDayCellTextStyle, backgroundStyle: CalendarViewDayCellBackgroundStyle, selectionStyle: CalendarViewDayCellSelectionStyle, monthLabelText: String, dateLabelText: String, indicatorLevel: Int) {
        preconditionFailure("Use setup(textStyle, backgroundStyle, selectionStyle, monthLabelText, dateLabelText, yearLabelText, indicatorLevel) instead")
    }

    // Only supports indicator levels from 0...4
    func setup(textStyle: CalendarViewDayCellTextStyle, backgroundStyle: CalendarViewDayCellBackgroundStyle, selectionStyle: CalendarViewDayCellSelectionStyle, monthLabelText: String, dateLabelText: String, yearLabelText: String, indicatorLevel: Int) {
        super.setup(textStyle: textStyle, backgroundStyle: backgroundStyle, selectionStyle: selectionStyle, monthLabelText: monthLabelText, dateLabelText: dateLabelText, indicatorLevel: indicatorLevel)

        switch textStyle {
        case .primary:
            yearLabel.textColor = Colors.Calendar.Day.textPrimary
        case .secondary:
            yearLabel.textColor = Colors.Calendar.Day.textSecondary
        }

        yearLabel.text = yearLabelText
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let maxWidth = bounds.size.width
        let maxHeight = bounds.size.height

        monthLabel.frame = CGRect(x: 0.0, y: 0.0, width: maxWidth, height: maxHeight / 3.0)

        if !isSelected && !isHighlighted {
            dateLabel.frame = CGRect(x: 0.0, y: maxHeight / 3.0, width: maxWidth, height: maxHeight / 3.0)
        }

        yearLabel.frame = CGRect(x: 0.0, y: maxHeight * (2.0 / 3.0), width: maxWidth, height: maxHeight / 3.0)

        dotView.frame = .zero
    }
}
