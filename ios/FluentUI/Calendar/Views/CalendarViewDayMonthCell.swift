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

        monthLabel.font = UIFont.fluent(fluentTheme.aliasTokens.typography[.caption2])
        monthLabel.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground3])
        contentView.addSubview(monthLabel)
    }

    @objc override func themeDidChange(_ notification: Notification) {
        super.themeDidChange(notification)
        updateMonthLabelColor(textStyle: textStyle)
    }

    private func updateMonthLabelColor(textStyle: CalendarViewDayCellTextStyle) {
        switch textStyle {
        case .primary:
            monthLabel.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground3])
        case .secondary:
            monthLabel.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground1])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func setup(textStyle: CalendarViewDayCellTextStyle, selectionStyle: CalendarViewDayCellSelectionStyle, dateLabelText: String, indicatorLevel: Int) {
        preconditionFailure("Use setup(textStyle, backgroundStyle, selectionStyle, monthLabelText, dateLabelText, indicatorLevel) instead")
    }

    // Only supports indicator levels from 0...4
    func setup(textStyle: CalendarViewDayCellTextStyle, selectionStyle: CalendarViewDayCellSelectionStyle, monthLabelText: String, dateLabelText: String, indicatorLevel: Int) {
        super.setup(textStyle: textStyle, selectionStyle: selectionStyle, dateLabelText: dateLabelText, indicatorLevel: indicatorLevel)

        updateMonthLabelColor(textStyle: textStyle)

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
