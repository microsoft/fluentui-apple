//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: HUDType

enum HUDType: Equatable {
    case activity
    case success
    case failure
    case custom(image: UIImage)
}

// MARK: - HUD Colors

public extension Colors {
    struct HUD {
        public static var activityIndicator: UIColor = .white
        public static var background = UIColor(light: gray900.withAlphaComponent(0.9), dark: gray700)
        public static var text = UIColor(light: textOnAccent, dark: textPrimary)
    }
}

// MARK: - HUDView

class HUDView: UIView {
    private struct Constants {
        static let backgroundCornerRadius: CGFloat = 4.0
        static let maxSizeInLargerContent: CGFloat = 256.0
        static let maxSize: CGFloat = 192.0
        static let minSize: CGFloat = 100.0
        static let paddingVertical: CGFloat = 20.0
        static let paddingHorizontal: CGFloat = 12.0
        static let labelMarginTop: CGFloat = 15.0
    }

    var onTap: (() -> Void)? {
        didSet {
            if onTap != nil {
                addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHUDTapped)))
                isUserInteractionEnabled = true
            }
        }
    }

    private let container: UIStackView = {
        let container = UIStackView()
        container.alignment = .center
        container.distribution = .fill
        container.spacing = Constants.labelMarginTop
        container.axis = .vertical
        return container
    }()

    private let type: HUDType

    let label: Label = {
        let label = Label()
        label.textColor = Colors.HUD.text
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let indicatorView: UIView

    public init(title: String = "", type: HUDType) {
        self.type = type
        indicatorView = HUDView.createIndicatorView(type: type)

        super.init(frame: .zero)

        isUserInteractionEnabled = false
        backgroundColor = Colors.HUD.background
        layer.cornerRadius = Constants.backgroundCornerRadius
        layer.masksToBounds = true
        layer.cornerCurve = .continuous

        container.addArrangedSubview(indicatorView)

        label.isHidden = title.isEmpty
        if !label.isHidden {
            label.text = title
            container.addArrangedSubview(label)

            label.setContentCompressionResistancePriority(.required, for: .vertical)
            if traitCollection.preferredContentSizeCategory > .large {
                label.setContentCompressionResistancePriority(.required, for: .horizontal)
                label.adjustsFontSizeToFitWidth = true
            } else {
                // label should try to grow vertically before it tries to grow horizontally
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            }
        }

        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)

        // showing the containerView in the middle of `HUDView` veritcally
        // takes precedence over having a fix padding in the bottom
        let bottom = container.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: Constants.paddingVertical * -1.0)
        bottom.priority = .defaultLow

        NSLayoutConstraint.activate([
            bottom,
            container.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: Constants.paddingVertical),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.paddingHorizontal),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.paddingHorizontal * -1.0),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: ActivityIndicatorViewSize.xLarge.sideSize),
            indicatorView.heightAnchor.constraint(equalToConstant: ActivityIndicatorViewSize.xLarge.sideSize)
        ])
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if label.isHidden {
            return CGSize(width: Constants.minSize, height: Constants.minSize)
        } else {
            let activitySize = ActivityIndicatorViewSize.xLarge.sideSize
            let maxSize = traitCollection.preferredContentSizeCategory > .large ? Constants.maxSizeInLargerContent : Constants.maxSize

            let labelSize = label.systemLayoutSizeFitting(CGSize(width: maxSize - 2 * Constants.paddingHorizontal, height: 0.0), withHorizontalFittingPriority: .defaultLow, verticalFittingPriority: .defaultLow)

            let fittingWidth = max(activitySize, labelSize.width) + 2 * Constants.paddingHorizontal
            let fittingHeight = labelSize.height + activitySize + Constants.labelMarginTop + 2 * Constants.paddingVertical

            // make sure HUD is always a square
            var suggestedSize = max(fittingWidth, fittingHeight)
            suggestedSize = max(ceil(suggestedSize), Constants.minSize)
            suggestedSize = min(maxSize, suggestedSize)
            return CGSize(width: suggestedSize, height: suggestedSize)
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

            if type == .success {
                return "Accessibility.HUD.Done".localized
            } else if type == .failure {
                return "Accessibility.HUD.Failed".localized
            } else {
                return "Accessibility.HUD.Loading".localized
            }
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

    private static func createIndicatorView(type: HUDType) -> UIView {
        switch type {
        case .activity:
            let activityIndicatorView = ActivityIndicatorView(size: .xLarge)
            activityIndicatorView.color = Colors.HUD.activityIndicator
            activityIndicatorView.startAnimating()
            return activityIndicatorView
        case .success:
            let imageView = UIImageView(image: .staticImageNamed("checkmark-36x36"))
            imageView.tintColor = Colors.HUD.activityIndicator
            return imageView
        case .failure:
            let imageView = UIImageView(image: .staticImageNamed("dismiss-36x36"))
            imageView.tintColor = Colors.HUD.activityIndicator
            return imageView
        case .custom(let image):
            return UIImageView(image: image)
        }
    }
}
