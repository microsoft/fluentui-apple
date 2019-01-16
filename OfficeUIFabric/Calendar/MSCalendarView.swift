//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import Foundation

// MARK: MSCalendarViewHeightStyle

enum MSCalendarViewHeightStyle {
    case short  // Shows 2 weeks
    case half   // Shows 2.5 weeks
    case tall   // Shows 5 weeks
    case extraTall // Show 6 weeks
}

// MARK: - MSCalendarView

class MSCalendarView: UIView {
    let weekdayHeadingView: MSCalendarViewWeekdayHeadingView
    let collectionView: UICollectionView
    let collectionViewLayout: MSCalendarViewLayout

    weak var accessibleViewDelegate: AccessibleViewDelegate?

    private let headingViewSeparator: MSSeparator
    private let collectionViewSeparator: MSSeparator

    init(headerStyle: MSDatePickerHeaderStyle = .light) {
        weekdayHeadingView = MSCalendarViewWeekdayHeadingView(headerStyle: headerStyle)

        headingViewSeparator = MSSeparator(style: .shadow)

        collectionViewLayout = MSCalendarViewLayout()

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = MSColors.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        // Enable multiple selection to allow for one cell to be selected and another cell to be highlighted simultaneously
        collectionView.allowsMultipleSelection = true

        collectionViewSeparator = MSSeparator(style: .default)

        super.init(frame: .zero)

        addSubview(weekdayHeadingView)
        addSubview(collectionView)
        addSubview(collectionViewSeparator)

        if headerStyle == .light {
            addSubview(headingViewSeparator)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Weekday heading view
        let weekdayHeadingViewSize = weekdayHeadingView.sizeThatFits(bounds.size)
        weekdayHeadingView.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: weekdayHeadingViewSize.width,
            height: weekdayHeadingViewSize.height
        )

        headingViewSeparator.frame = CGRect(
            x: 0.0,
            y: weekdayHeadingView.height,
            width: bounds.size.width,
            height: headingViewSeparator.height
        )

        // Collection view
        //
        // Avoid the default scroll view behavior that shifts the content offset when view frame changes. For example the
        // default behavior would reduce the content offset y when the height is increased to equally grow the visible bounds
        // at the top and bottom. We would just want the visible bounds to grow at the bottom.
        let originalContentOffset = collectionView.contentOffset
        collectionView.frame = CGRect(
            x: 0.0,
            y: weekdayHeadingView.height,
            width: bounds.size.width,
            height: bounds.size.height - weekdayHeadingView.height
        )
        collectionView.contentOffset = originalContentOffset

        collectionViewSeparator.frame = CGRect(
            x: 0.0,
            y: collectionView.bottom - collectionViewSeparator.height,
            width: bounds.size.width,
            height: collectionViewSeparator.height
        )
    }

    func height(for style: MSCalendarViewHeightStyle, in bounds: CGRect) -> CGFloat {
        var height: CGFloat = 0.0

        // Weekday heading
        height += weekdayHeadingView.sizeThatFits(bounds.size).height

        // Day cells
        height += MSCalendarViewLayout.preferredItemHeight * rows(for: style)

        // Do not include last separator
        height -= UIScreen.main.devicePixel

        return height
    }

    func rows(for style: MSCalendarViewHeightStyle) -> CGFloat {
        switch style {
        case .short:
            return 2.0
        case .half:
            return 2.5
        case .tall:
            return 5.0
        case .extraTall:
            return 6.0
        }
    }

    // MARK: Accessibility

    override var isAccessibilityElement: Bool { get { return true } set { } }

    override var accessibilityLabel: String? { get { return "Accessibility.Calendar.Label".localized } set { } }

    override var accessibilityHint: String? { get { return "Accessibility.Calendar.Hint".localized } set { } }

    override var accessibilityTraits: UIAccessibilityTraits { get { return super.accessibilityTraits.union(.adjustable) } set { } }

    override var accessibilityValue: String? {
        get { return accessibleViewDelegate?.accessibilityValueForAccessibleView?(self) ?? super.accessibilityValue }
        set { }
    }

    override func accessibilityIncrement() {
        accessibleViewDelegate?.accessibilityIncrementForAccessibleView?(self)
    }

    override func accessibilityDecrement() {
        accessibleViewDelegate?.accessibilityDecrementForAccessibleView?(self)
    }

    override func accessibilityPerformMagicTap() -> Bool {
        return accessibleViewDelegate?.accessibilityPerformMagicTapForAccessibleView?(self) ?? super.accessibilityPerformMagicTap()
    }

    override func accessibilityActivate() -> Bool {
        return accessibleViewDelegate?.accessibilityActivateForAccessibleView?(self) ?? super.accessibilityActivate()
    }
}
