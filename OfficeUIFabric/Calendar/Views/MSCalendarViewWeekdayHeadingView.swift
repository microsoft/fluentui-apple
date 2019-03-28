//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

// MARK: MSCalendarViewWeekdayHeadingView

class MSCalendarViewWeekdayHeadingView: UIView {
    private struct Constants {
        struct Light {
            static let regularTextColor: UIColor = MSColors.gray
            static let weekendTextColor: UIColor = MSColors.lightGray
            static let backgroundColor: UIColor = MSColors.background
            static let regularHeight: CGFloat = 26.0
        }

        struct Dark {
            static let regularTextColor: UIColor = MSColors.white
            static let weekendTextColor: UIColor = MSColors.white.withAlphaComponent(0.7)
            static let backgroundColor: UIColor = MSColors.primary
            static let paddingTop: CGFloat = 12.0
            static let compactHeight: CGFloat = 26.0
            static let regularHeight: CGFloat = 48.0
        }
    }

    private var firstWeekday: Int?
    private let headerStyle: MSDatePickerHeaderStyle

    private var headingLabels = [UILabel]()

    init(headerStyle: MSDatePickerHeaderStyle) {
        self.headerStyle = headerStyle

        super.init(frame: .zero)

        backgroundColor = headerStyle == .dark ? Constants.Dark.backgroundColor : Constants.Light.backgroundColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            label.font = MSFonts.caption1

            switch headerStyle {
            case .light:
                label.textColor = (index == 0 || index == 6) ? Constants.Light.weekendTextColor : Constants.Light.regularTextColor

            case .dark:
                label.textColor = (index == 0 || index == 6) ? Constants.Dark.weekendTextColor : Constants.Dark.regularTextColor
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
