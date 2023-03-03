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

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        updateBackgroundColor()
    }

    private func updateBackgroundColor() {
        backgroundColor = UIColor(dynamicColor: DynamicColor(light: fluentTheme.aliasTokens.colors[.background2].light, dark: fluentTheme.aliasTokens.colors[.background2].dark))
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

        let labelWidth = ceil(bounds.size.width / 7.0)
        let labelHeight = bounds.size.height - paddingTop

        var left: CGFloat = 0.0

        for label in headingLabels {
            label.frame = CGRect(x: left, y: paddingTop, width: labelWidth, height: labelHeight)
            left += labelWidth
        }

        flipSubviewsForRTL()
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        super.didMoveToWindow()
        updateBackgroundColor()
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

        for weekdaySymbol in weekdaySymbols {
            let label = UILabel()
            label.textAlignment = .center
            label.text = weekdaySymbol
            label.font = UIFont.fluent(fluentTheme.aliasTokens.typography[.caption2])
            label.showsLargeContentViewer = true
            label.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.foreground2])
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
