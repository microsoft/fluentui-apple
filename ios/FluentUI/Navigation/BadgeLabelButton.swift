//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class BadgeLabelButton: UIButton {
    let badgeLabel = BadgeLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(badgeValueDidChange),
                                               name: UIBarButtonItem.badgeValueDidChangeNotification,
                                               object: item)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        update()
    }

    private struct Constants {
        static let badgeVerticalOffset: CGFloat = -5
        static let badgeHeight: CGFloat = 16
        static let badgeMinWidth: CGFloat = 16
        static let badgeMaxWidth: CGFloat = 27
        static let badgeBorderWidth: CGFloat = 2
        static let badgeHorizontalPadding: CGFloat = 10
        static let badgeCornerRadii: CGFloat = 10
    }

    private var badgeWidth: CGFloat {
        return min(max(badgeLabel.intrinsicContentSize.width + Constants.badgeHorizontalPadding, Constants.badgeMinWidth), Constants.badgeMaxWidth)
    }

    private var badgeVerticalPosition: CGFloat {
        return (frame.size.height - intrinsicContentSize.height) / 2 - Constants.badgeHeight / 2 - Constants.badgeVerticalOffset
    }

    private var badgeFrameOriginX: CGFloat {
        var xOrigin: CGFloat
        if isLeftToRightUserInterfaceLayoutDirection {
            xOrigin = frame.size.width - contentEdgeInsets.left - badgeWidth / 2
        } else {
            xOrigin = contentEdgeInsets.left - badgeWidth / 2
        }
        return xOrigin
    }

    private var badgeLabelFrame: CGRect {
        let targetView = isItemTitlePresent ? titleLabel : imageView

        return CGRect(x: badgeFrameOriginX - (targetView?.frame.origin.x ?? 0),
                      y: badgeVerticalPosition - (targetView?.frame.origin.y ?? 0),
                      width: badgeWidth,
                      height: Constants.badgeHeight)
    }

    private var badgeBoundsOriginX: CGFloat {
        var xOrigin: CGFloat = 0
        if !isLeftToRightUserInterfaceLayoutDirection {
            xOrigin -= badgeWidth / 2
        }
        return xOrigin
    }

    private var isLeftToRightUserInterfaceLayoutDirection: Bool {
        return effectiveUserInterfaceLayoutDirection == .leftToRight
    }

    private var isItemTitlePresent: Bool {
        return item?.title != nil
    }

    public var item: UIBarButtonItem? {
        didSet {
            update()
        }
    }

    private func update() {
        if isItemTitlePresent {
            titleLabel?.addSubview(badgeLabel)
            titleLabel?.isHidden = false
        } else {
            imageView?.addSubview(badgeLabel)
            imageView?.isHidden = false
            imageView?.clipsToBounds = false
        }

        updateBadgeLabel()
    }

    func updateBadgeLabel() {
        badgeLabel.text = item?.badgeValue
        let isNilBadgeValue = item?.badgeValue == nil
        badgeLabel.isHidden = isNilBadgeValue

        if isNilBadgeValue {
            layer.mask = nil
        } else {
            badgeLabel.frame = badgeLabelFrame

            let layer = CAShapeLayer()
            layer.path = UIBezierPath(roundedRect: badgeLabel.bounds,
                                      byRoundingCorners: .allCorners,
                                      cornerRadii: CGSize(width: Constants.badgeCornerRadii, height: Constants.badgeCornerRadii)).cgPath
            badgeLabel.layer.mask = layer
            badgeLabel.layer.cornerRadius = 0

            let bezierRect = CGRect(x: badgeFrameOriginX,
                                    y: badgeVerticalPosition,
                                    width: badgeWidth,
                                    height: Constants.badgeHeight)
            let path = UIBezierPath(rect: CGRect(x: badgeBoundsOriginX,
                                                 y: 0,
                                                 width: frame.size.width + badgeWidth / 2,
                                                 height: frame.size.height))
            path.append(UIBezierPath(roundedRect: borderRect(for: bezierRect),
                                     byRoundingCorners: .allCorners,
                                     cornerRadii: CGSize(width: Constants.badgeCornerRadii,
                                                         height: Constants.badgeCornerRadii)))
            path.append(UIBezierPath(roundedRect: bezierRect,
                                     byRoundingCorners: .allCorners,
                                     cornerRadii: CGSize(width: Constants.badgeCornerRadii,
                                                         height: Constants.badgeCornerRadii)))
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = .evenOdd
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }

    private func borderRect(for frame: CGRect) -> CGRect {
        return CGRect(x: frame.origin.x - Constants.badgeBorderWidth,
                      y: frame.origin.y - Constants.badgeBorderWidth,
                      width: frame.size.width + 2 * Constants.badgeBorderWidth,
                      height: frame.size.height + 2 * Constants.badgeBorderWidth)
    }

    @objc private func badgeValueDidChange() {
        updateBadgeLabel()
    }
}
