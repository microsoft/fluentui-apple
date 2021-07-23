//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import UIKit

class SegmentPillButton: UIButton {
    var isUnreadDotVisible: Bool = false {
        didSet {
            if oldValue != isUnreadDotVisible {
                if isUnreadDotVisible {
                    self.layer.addSublayer(unreadDotLayer)
                } else {
                    unreadDotLayer.removeFromSuperlayer()
                }
            }
        }
    }

    var unreadDotColor: UIColor = Colors.gray100

    override var isSelected: Bool {
        didSet {
            if oldValue != isSelected && isSelected == true {
                item.isUnread = false
                updateUnreadDot()
            }
        }
    }

    init(withItem item: SegmentItem) {
        self.item = item
        super.init(frame: .zero)

        self.contentEdgeInsets = Constants.insets

        let title = item.title
        self.setTitle(title, for: .normal)
        self.accessibilityLabel = title
        self.largeContentTitle = title
        self.showsLargeContentViewer = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontSize)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(isUnreadValueDidChange),
                                               name: SegmentItem.isUnreadValueDidChangeNotification,
                                               object: item)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUnreadDot()
    }

    private let item: SegmentItem

    private let unreadDotLayer: CALayer = {
        let unreadDotLayer = CALayer()
        unreadDotLayer.bounds.size = CGSize(width: Constants.unreadDotSize, height: Constants.unreadDotSize)
        unreadDotLayer.cornerRadius = Constants.unreadDotSize / 2
        return unreadDotLayer
    }()

    @objc private func isUnreadValueDidChange() {
        isUnreadDotVisible = item.isUnread
        setNeedsLayout()
    }

    private func updateUnreadDot() {
        isUnreadDotVisible = item.isUnread
        if isUnreadDotVisible {
            let anchor = self.titleLabel?.frame ?? .zero
            let xPos: CGFloat
            if effectiveUserInterfaceLayoutDirection == .leftToRight {
                xPos = anchor.maxX + Constants.unreadDotOffset.x
            } else {
                xPos = anchor.minX - Constants.unreadDotOffset.x - Constants.unreadDotSize
            }
            unreadDotLayer.frame.origin = CGPoint(x: xPos, y: anchor.minY + Constants.unreadDotOffset.y)
            unreadDotLayer.backgroundColor = unreadDotColor.cgColor
        }
    }

    private struct Constants {
        static let fontSize: CGFloat = 16
        static let unreadDotOffset = CGPoint(x: 6, y: 3)
        static let unreadDotSize: CGFloat = 6
        static let insets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
    }
}
