//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: CalendarViewWeekdayHeadingView

class CalendarViewWeekdayHeadingView: UIView {
    private struct Constants {
        struct Light {
            static let regularHeight: CGFloat = 26.0
        }

        struct Dark {
            static let paddingTop: CGFloat = 12.0
            static let compactHeight: CGFloat = 26.0
            static let regularHeight: CGFloat = 48.0
        }
    }

    private var firstWeekday: Int?
    private let headerStyle: DatePickerHeaderStyle

    private var headingLabels = [UILabel]()

    init(headerStyle: DatePickerHeaderStyle) {
        self.headerStyle = headerStyle

        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        switch headerStyle {
        case .light:
            return CGSize(
                width: size.width,
                height: Constants.Light.regularHeight
            )
        case .dark:
            return CGSize(
                width: size.width,
                height: traitCollection.verticalSizeClass == .regular ? Constants.Dark.regularHeight : Constants.Dark.compactHeight
            )
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let paddingTop = (traitCollection.verticalSizeClass == .regular && headerStyle == .dark) ? Constants.Dark.paddingTop : 0.0

        let labelWidth = UIScreen.main.roundToDevicePixels(bounds.size.width / 7.0)
        let labelHeight = bounds.size.height - paddingTop

        var left: CGFloat = 0.0

        for label in headingLabels {
            label.frame = CGRect(x: left, y: paddingTop, width: labelWidth, height: labelHeight)
            left += labelWidth
        }

        flipSubviewsForRTL()
    }

	override func didMoveToWindow() {
		if let window = window {
			backgroundColor = headerStyle == .dark ? Colors.primary(for: window) : Colors.Calendar.WeekdayHeading.Light.background
		}
	}

    func setup(horizontalSizeClass: UIUserInterfaceSizeClass, firstWeekday: Int) {
        if self.firstWeekday != nil && self.firstWeekday == firstWeekday {
            return
        }

        self.firstWeekday = firstWeekday

        for label in headingLabels {
            label.removeFromSuperview()
        }

        headingLabels = [UILabel]()

        let weekdaySymbols: [String] = horizontalSizeClass == .regular ? Calendar.current.shortStandaloneWeekdaySymbols : Calendar.current.veryShortStandaloneWeekdaySymbols

        for (index, weekdaySymbol) in weekdaySymbols.enumerated() {
            let label = UILabel()
            label.textAlignment = .center
            label.text = weekdaySymbol
            label.font = Fonts.caption1

            switch headerStyle {
            case .light:
                label.textColor = (index == 0 || index == 6) ? Colors.Calendar.WeekdayHeading.Light.textWeekend : Colors.Calendar.WeekdayHeading.Light.textRegular

            case .dark:
                label.textColor = (index == 0 || index == 6) ? Colors.Calendar.WeekdayHeading.Dark.textWeekend : Colors.Calendar.WeekdayHeading.Dark.textRegular
            }

            headingLabels.append(label)
            addSubview(label)
        }

        // Shift `headingLabels` to align with `firstWeekday` preference
        for _ in 1..<firstWeekday {
            headingLabels.append(headingLabels.removeFirst())
        }

        setNeedsLayout()
    }
}
