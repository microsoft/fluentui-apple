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
                    accessibilityLabel = String(format: "Accessibility.TabBarItemView.UnreadFormat".localized, item.title)
                } else {
                    unreadDotLayer.removeFromSuperlayer()
                    accessibilityLabel = item.title
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

    let tokenSet: SegmentedControlTokenSet

    func updateTokenizedValues() {
        titleLabel?.font = tokenSet[.font].uiFont
        let verticalInset = tokenSet[.verticalInset].float
        let horizontalInset = tokenSet[.horizontalInset].float
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: verticalInset,
                                                              leading: horizontalInset,
                                                              bottom: verticalInset,
                                                              trailing: horizontalInset)
        configuration.background.backgroundColor = .clear
        configuration.background.cornerRadius = SegmentedControlTokenSet.pillButtonCornerRadius
        configuration.baseForegroundColor = tokenSet[.restLabelColor].uiColor
        let titleTransformer = UIConfigurationTextAttributesTransformer { [weak self] incoming in
            var outgoing = incoming
            outgoing.font = self?.tokenSet[.font].uiFont
            return outgoing
        }
        configuration.titleTextAttributesTransformer = titleTransformer
        self.configuration = configuration
    }

    init(withItem item: SegmentItem, tokenSet: SegmentedControlTokenSet) {
        self.item = item
        self.tokenSet = tokenSet
        super.init(frame: .zero)

        // TODO: Once iOS 14 support is dropped, set title, etc., in configuration
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
        guard let updateMaskedContentConstraints = updateMaskedContentConstraints else {
            return
        }
        updateMaskedContentConstraints()
    }

    /// UIButton.Configuration is doing something causing the layout of the label/icon
    /// and masked content to render incorrectly, so we need to update the constraints
    /// on the masked content when we layoutSubviews
    var updateMaskedContentConstraints: (() -> Void)?

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
            let anchorView: UIView?
            if item.image != nil {
                anchorView = self.imageView
            } else {
                anchorView = self.titleLabel
            }
            let anchor = anchorView?.frame ?? .zero
            let xPos: CGFloat
            if effectiveUserInterfaceLayoutDirection == .leftToRight {
                xPos = anchor.maxX + tokenSet[.unreadDotOffsetX].float
            } else {
                xPos = anchor.minX - tokenSet[.unreadDotOffsetX].float - tokenSet[.unreadDotSize].float
            }
            unreadDotLayer.frame.origin = CGPoint(x: xPos, y: anchor.minY + tokenSet[.unreadDotOffsetY].float)
            let unreadDotColor = isEnabled ? tokenSet[.enabledUnreadDotColor].uiColor : tokenSet[.disabledUnreadDotColor].uiColor
            unreadDotLayer.backgroundColor = unreadDotColor.cgColor
        }
    }
}
