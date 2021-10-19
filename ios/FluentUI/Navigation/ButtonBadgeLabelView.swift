//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class ButtonBadgeLabelView: UIView {
    let item: UIBarButtonItem
    let button: UIButton
    let badgeLabel = BadgeLabel()

    init(for item: UIBarButtonItem, inside button: UIButton) {
        self.item = item
        self.button = button

        super.init(frame: .zero)

        addSubview(badgeLabel)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(badgeValueDidChange),
                                               name: UIBarButtonItem.badgeValueDidChangeNotification,
                                               object: item)

        badgeValue = item.badgeValue
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        update()
    }

    private struct Constants {
        static let badgeLandscapeVerticalOffset: CGFloat = -5
        static let badgePortraitVerticalOffset: CGFloat = -4
        static let badgeHeight: CGFloat = 16
        static let badgeMinWidth: CGFloat = 16
        static let badgeMaxWidth: CGFloat = 27
        static let badgeBorderWidth: CGFloat = 2
        static let badgeHorizontalPadding: CGFloat = 10
        static let badgeCornerRadii: CGFloat = 10
    }

    private var isInPortraitMode: Bool {
        return (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular)
    }

    private var badgeValue: String? {
        didSet {
            if oldValue != badgeValue {
                update()
            }
        }
    }

    private func updateButton() {
        if item.title != nil {
            button.titleLabel?.isHidden = false
        } else {
            button.imageView?.isHidden = false
            button.imageView?.clipsToBounds = false
        }
    }

    private func update() {
        updateButton()

        badgeLabel.text = badgeValue
        let isNilBadgeValue = badgeValue == nil
        badgeLabel.isHidden = isNilBadgeValue

        if isNilBadgeValue {
            button.layer.mask = nil
        } else {
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = .evenOdd

            let badgeWidth = min(max(badgeLabel.intrinsicContentSize.width + Constants.badgeHorizontalPadding, Constants.badgeMinWidth), Constants.badgeMaxWidth)
            let path = UIBezierPath(rect: CGRect(x: bezierRectOriginX(for: badgeWidth), y: 0, width: button.frame.size.width + badgeWidth / 2, height: button.frame.size.height))

            badgeLabel.frame = badgeFrame(for: badgeWidth, isTitleLabelPresent: item.title != nil)

            let layer = CAShapeLayer()
            layer.path = UIBezierPath(roundedRect: badgeLabel.bounds,
                                      byRoundingCorners: .allCorners,
                                      cornerRadii: CGSize(width: Constants.badgeCornerRadii, height: Constants.badgeCornerRadii)).cgPath

            badgeLabel.layer.mask = layer
            badgeLabel.layer.cornerRadius = 0

            let bezierRect = bezierRect(for: badgeWidth)
            path.append(UIBezierPath(roundedRect: borderRect(for: bezierRect),
                                     byRoundingCorners: .allCorners,
                                     cornerRadii: CGSize(width: Constants.badgeCornerRadii, height: Constants.badgeCornerRadii)))

            path.append(UIBezierPath(roundedRect: bezierRect,
                                     byRoundingCorners: .allCorners,
                                     cornerRadii: CGSize(width: Constants.badgeCornerRadii, height: Constants.badgeCornerRadii)))

            maskLayer.path = path.cgPath
            button.layer.mask = maskLayer
        }
    }

    private func badgeFrame(for badgeWidth: CGFloat, isTitleLabelPresent: Bool) -> CGRect {
        let badgeVerticalOffset = isInPortraitMode ? Constants.badgePortraitVerticalOffset : Constants.badgeLandscapeVerticalOffset
        let badgeVerticalPosition = (button.frame.size.height - button.intrinsicContentSize.height) / 2 - Constants.badgeHeight / 2 - badgeVerticalOffset
        if isTitleLabelPresent {
            return CGRect(x: badgeFrameOriginX(for: badgeWidth) - (button.titleLabel?.frame.origin.x ?? 0),
                          y: badgeVerticalPosition - (button.titleLabel?.frame.origin.y ?? 0),
                          width: badgeWidth,
                          height: Constants.badgeHeight)
        } else {
            return CGRect(x: badgeFrameOriginX(for: badgeWidth) - (button.imageView?.frame.origin.x ?? 0),
                          y: badgeVerticalPosition - (button.imageView?.frame.origin.y ?? 0),
                          width: badgeWidth,
                          height: Constants.badgeHeight)
        }
    }

    private func bezierRect(for badgeWidth: CGFloat) -> CGRect {
        let badgeVerticalOffset = isInPortraitMode ? Constants.badgePortraitVerticalOffset : Constants.badgeLandscapeVerticalOffset
        let badgeVerticalPosition = (button.frame.size.height - button.intrinsicContentSize.height) / 2 - Constants.badgeHeight / 2 - badgeVerticalOffset
        return CGRect(x: badgeFrameOriginX(for: badgeWidth),
                      y: badgeVerticalPosition,
                      width: badgeWidth,
                      height: Constants.badgeHeight)
    }

    private func bezierRectOriginX(for width: CGFloat) -> CGFloat {
        var xOrigin: CGFloat = 0

        if effectiveUserInterfaceLayoutDirection == .rightToLeft {
            xOrigin -= width / 2
        }

        return xOrigin
    }

    private func badgeFrameOriginX(for width: CGFloat) -> CGFloat {
        var xOrigin: CGFloat

        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            xOrigin = button.frame.size.width - button.contentEdgeInsets.left - width / 2
        } else {
            xOrigin = button.contentEdgeInsets.left - width / 2
        }

        return xOrigin
    }

    private func borderRect(for frame: CGRect) -> CGRect {
        return CGRect(x: frame.origin.x - Constants.badgeBorderWidth,
                      y: frame.origin.y - Constants.badgeBorderWidth,
                      width: frame.size.width + 2 * Constants.badgeBorderWidth,
                      height: frame.size.height + 2 * Constants.badgeBorderWidth)
    }

    @objc private func badgeValueDidChange() {
        badgeValue = item.badgeValue
    }
}
