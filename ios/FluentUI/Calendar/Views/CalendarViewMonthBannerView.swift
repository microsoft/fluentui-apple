//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: CalendarViewMonthBannerView

class CalendarViewMonthBannerView: UICollectionReusableView {
    private struct Constants {
        static let visualStateTransitionDuration: TimeInterval = 0.3
    }

    static let supplementaryElementKind: String = "CalendarViewMonthBannerView"
    static let reuseIdentifier: String = "CalendarViewMonthBannerView"

    private var isVisible: Bool = false
    private let monthLabel: UILabel

    override init(frame: CGRect) {
        // Month label
        monthLabel = Label(style: .body, colorStyle: .regular)
        monthLabel.textAlignment = .center
        monthLabel.alpha = 0.0  // Initial `isVisible` is `false`

        super.init(frame: frame)

        isUserInteractionEnabled = false

        addSubview(monthLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        monthLabel.frame = bounds
    }

    func setup(monthLabelText: String) {
        monthLabel.text = monthLabelText
    }

    func setVisible(_ isVisible: Bool, animated: Bool) {
        if isVisible == self.isVisible {
            return
        }

        let duration = (animated) ? calendarViewDayCellVisualStateTransitionDuration : 0.0

        UIView.animate(withDuration: duration) {
            self.monthLabel.alpha = isVisible ? 1.0 : 0.0
        }

        self.isVisible = isVisible
    }
}
