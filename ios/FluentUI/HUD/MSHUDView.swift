//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSHUDType

enum MSHUDType {
    case activity
    case success
    case failure
    case custom(image: UIImage)
}

// MARK: - MSHUDView

class MSHUDView: UIView {
    private struct Constants {
        static let backgroundCornerRadius: CGFloat = 4.0
        static let maxWidth: CGFloat = 200.0
        static let minSideSizeWithoutLabel: CGFloat = 98.0
        static let minSideSizeWithLabel: CGFloat = 108.0
        static let paddingHorizontalWithoutLabel: CGFloat = 30.0
        static let paddingHorizontalWithLabel: CGFloat = 24.0
        static let paddingVerticalWithLabel: CGFloat = 18.0
        static let labelMarginTop: CGFloat = 14.0
        static let labelMaxWidth: CGFloat = maxWidth - 2 * paddingHorizontalWithLabel
    }

    var onTap: (() -> Void)? {
        didSet {
            if onTap != nil {
                addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHUDTapped)))
                isUserInteractionEnabled = true
            }
        }
    }

    let label: UILabel = {
        let label = UILabel()
        label.textColor = Colors.HUD.text
        label.font = MSFonts.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = Constants.labelMaxWidth
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()

    private let indicatorView: UIView

    public init(label: String = "", type: MSHUDType) {
        indicatorView = MSHUDIndicatorView(type: type)

        super.init(frame: .zero)

        backgroundColor = Colors.HUD.background
        layer.cornerRadius = Constants.backgroundCornerRadius
        layer.masksToBounds = true
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }

        addSubview(indicatorView)

        self.label.isHidden = label.isEmpty
        if !self.label.isHidden {
            self.label.text = label
            addSubview(self.label)
        }

        isUserInteractionEnabled = false
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        indicatorView.sizeToFit()
        indicatorView.frame = CGRect(
            x: UIScreen.main.roundToDevicePixels((bounds.width - indicatorView.frame.width) / 2),
            y: UIScreen.main.roundToDevicePixels(label.isHidden ? (bounds.height - indicatorView.frame.height) / 2 : Constants.paddingVerticalWithLabel),
            width: indicatorView.frame.width,
            height: indicatorView.frame.height
        )

        let labelSize = label.sizeThatFits(CGSize(width: Constants.labelMaxWidth, height: .greatestFiniteMagnitude))
        label.frame = CGRect(
            x: UIScreen.main.roundToDevicePixels((bounds.width - labelSize.width) / 2),
            y: indicatorView.frame.maxY + Constants.labelMarginTop,
            width: labelSize.width,
            height: labelSize.height
        )
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let indicatorViewSize = indicatorView.sizeThatFits(size)

        if label.isHidden {
            let sideSize = max(Constants.minSideSizeWithoutLabel, indicatorViewSize.width + 2 * Constants.paddingHorizontalWithoutLabel)
            return CGSize(width: sideSize, height: sideSize)
        } else {
            let labelSize = label.sizeThatFits(CGSize(width: Constants.labelMaxWidth, height: .greatestFiniteMagnitude))
            let fittingWidth = max(indicatorViewSize.width, labelSize.width) + 2 * Constants.paddingHorizontalWithLabel
            let fittingHeight = Constants.paddingVerticalWithLabel + indicatorViewSize.height + Constants.labelMarginTop + labelSize.height + Constants.paddingVerticalWithLabel

            return CGSize(
                width: min(Constants.maxWidth, max(Constants.minSideSizeWithLabel, fittingWidth)),
                height: max(Constants.minSideSizeWithLabel, fittingHeight)
            )
        }
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    // MARK: Accessibility

    var accessibilityMessageForHide: String { return "Accessibility.HUD.Done".localized }

    open override var accessibilityLabel: String? {
        get {
            if let labelText = label.text, !labelText.isEmpty {
                return labelText
            }
            return indicatorView.accessibilityLabel ?? "Accessibility.HUD.Loading".localized
        }
        set { }
    }

    open override var isAccessibilityElement: Bool {
        get { return true }
        set { }
    }

    open override var accessibilityViewIsModal: Bool {
        get { return true }
        set { }
    }

    open override var accessibilityTraits: UIAccessibilityTraits {
        get { return super.accessibilityTraits.union(isUserInteractionEnabled ? .button : .staticText) }
        set { }
    }

    @objc private func handleHUDTapped() {
        onTap?()
    }
}

// MARK: - MSHUDIndicatorView

/// A container view of a fixed size which accepts a `MSHUDType` and centers its visual presentation.
private class MSHUDIndicatorView: UIView {
    private struct Constants {
        static let width: CGFloat = 40.0
        static let height: CGFloat = 40.0
    }

    private static func createContentView(type: MSHUDType) -> UIView {
        switch type {
        case .activity:
            let activityIndicatorView = ActivityIndicatorView(size: .xLarge)
            activityIndicatorView.color = Colors.HUD.activityIndicator
            activityIndicatorView.startAnimating()
            return activityIndicatorView
        case .success:
            let imageView = UIImageView(image: .staticImageNamed("checkmark-white-40x40"))
            imageView.accessibilityLabel = "Accessibility.HUD.Done".localized
            return imageView
        case .failure:
            let imageView = UIImageView(image: .staticImageNamed("cancel-white-40x40"))
            imageView.accessibilityLabel = "Accessibility.HUD.Failed".localized
            return imageView
        case .custom(let image):
            return UIImageView(image: image)
        }
    }

    private let contentView: UIView

    init(type: MSHUDType) {
        contentView = MSHUDIndicatorView.createContentView(type: type)

        super.init(frame: .zero)

        addSubview(contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame.size = contentView.sizeThatFits(bounds.size)
        contentView.centerInSuperview(horizontally: true, vertically: true)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: Constants.width, height: Constants.height)
    }

    override var accessibilityLabel: String? {
        get { return contentView.accessibilityLabel }
        set { }
    }
}
