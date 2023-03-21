//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

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
        monthLabel.textAlignment = .center
        monthLabel.showsLargeContentViewer = true

        super.init(frame: frame)

        monthLabel.font = fluentTheme.typography(.caption2)
        updateMonthLabelColor()
        contentView.addSubview(monthLabel)
    }

    override func updateAppearance() {
        super.updateAppearance()
        updateMonthLabelColor()
    }

    private func updateMonthLabelColor() {
        monthLabel.textColor = fluentTheme.color(.foreground2)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func setup(textStyle: CalendarViewDayCellTextStyle,
                        backgroundStyle: CalendarViewDayCellBackgroundStyle,
                        selectionStyle: CalendarViewDayCellSelectionStyle,
                        dateLabelText: String,
                        indicatorLevel: Int) {
        preconditionFailure("Use setup(textStyle, backgroundStyle, selectionStyle, monthLabelText, dateLabelText, indicatorLevel) instead")
    }

    // Only supports indicator levels from 0...4
    func setup(textStyle: CalendarViewDayCellTextStyle,
               backgroundStyle: CalendarViewDayCellBackgroundStyle,
               selectionStyle: CalendarViewDayCellSelectionStyle,
               monthLabelText: String,
               dateLabelText: String,
               indicatorLevel: Int) {
        super.setup(textStyle: textStyle,
                    backgroundStyle: backgroundStyle,
                    selectionStyle: selectionStyle,
                    dateLabelText: dateLabelText,
                    indicatorLevel: indicatorLevel)

        updateMonthLabelColor()

        monthLabel.text = monthLabelText.uppercased()
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
