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

    override var isSelected: Bool {
        didSet {
            if oldValue != isSelected && isSelected == true {
                item.isUnread = false
                updateUnreadDot()
            }
        }
    }

    var tokenSet: SegmentedControlTokenSet

    func updateTokenizedValues() {
        titleLabel?.font = UIFont.fluent(tokenSet[.font].fontInfo, shouldScale: false)
        let verticalInset = tokenSet[.verticalInset].float
        let horizontalInset = tokenSet[.horizontalInset].float
        contentEdgeInsets = UIEdgeInsets(top: verticalInset,
                                         left: horizontalInset,
                                         bottom: verticalInset,
                                         right: horizontalInset)
    }

    init(withItem item: SegmentItem, tokenSet: SegmentedControlTokenSet) {
        self.item = item
        self.tokenSet = tokenSet
        super.init(frame: .zero)

        let title = item.title
        if let image = item.image {
            self.setImage(image, for: .normal)
            self.accessibilityLabel = title
            self.largeContentTitle = title
        } else {
            self.setTitle(title, for: .normal)
        }
        self.showsLargeContentViewer = true

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(isUnreadValueDidChange),
                                               name: SegmentItem.isUnreadValueDidChangeNotification,
                                               object: item)

        updateTokenizedValues()
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUnreadDot()
    }

    private let item: SegmentItem

    private lazy var unreadDotLayer: CALayer = {
        let unreadDotLayer = CALayer()
        let unreadDotSize = tokenSet[.unreadDotSize].float
        unreadDotLayer.bounds.size = CGSize(width: unreadDotSize, height: unreadDotSize)
        unreadDotLayer.cornerRadius = unreadDotSize / 2
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
                xPos = anchor.maxX + tokenSet[.unreadDotOffsetX].float
            } else {
                xPos = anchor.minX - tokenSet[.unreadDotOffsetX].float - tokenSet[.unreadDotSize].float
            }
            unreadDotLayer.frame.origin = CGPoint(x: xPos, y: anchor.minY + tokenSet[.unreadDotOffsetY].float)
            let unreadDotColor = isEnabled ? tokenSet[.enabledUnreadDotColor].dynamicColor : tokenSet[.disabledUnreadDotColor].dynamicColor
            unreadDotLayer.backgroundColor = UIColor(dynamicColor: unreadDotColor).cgColor
        }
    }
}
