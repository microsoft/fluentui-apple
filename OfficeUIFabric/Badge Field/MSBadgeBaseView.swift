//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

// MARK: MSBadgeBaseViewDelegate

@objc public protocol MSBadgeBaseViewDelegate {
    func didSelectBadge(_ badge: MSBadgeBaseView)
    func didTapSelectedBadge(_ badge: MSBadgeBaseView)
}

// MARK: - MSBadgeBaseViewDataSource

open class MSBadgeBaseViewDataSource: NSObject {
    @objc open private(set) var text: String

    @objc public init(text: String) {
        self.text = text
        super.init()
    }
}

// MARK: - MSBadgeBaseView

/**
 `MSBadgeBaseView` is the base view used in `MSBadgeView` as a "badge".
 It defines the needed interface for views handled by MSBadgeView such as:
 - Colored background
 - Selection logic
 */
open class MSBadgeBaseView: UIView {
    private struct Constants {
        static let defaultMinWidth: CGFloat = 25
        static let backgroundViewCornerRadius: CGFloat = 2
    }

    open class var defaultHeight: CGFloat {
        assertionFailure("MSBadgeBaseView defaultHeight method must be overridden")
        return 0
    }

    @objc open var dataSource: MSBadgeBaseViewDataSource? {
        didSet {
            reload()
        }
    }
    open weak var delegate: MSBadgeBaseViewDelegate?

    open var isEnabled: Bool = true {
        didSet {
            updateBackgroundColor()
            accessibilityHint = nil
            isUserInteractionEnabled = isEnabled
        }
    }

    open var isSelected: Bool = false {
        didSet {
            updateBackgroundColor()
            updateAccessibility()
        }
    }

    open var minWidth: CGFloat = Constants.defaultMinWidth {
        didSet {
            setNeedsLayout()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    internal var badgeBackgroundColor: UIColor = MSColors.Badge.background {
        didSet {
            updateBackgroundColor()
        }
    }
    internal var badgeSelectedBackgroundColor: UIColor = MSColors.Badge.backgroundSelected {
        didSet {
            updateBackgroundColor()
        }
    }
    internal var badgeDisabledBackgroundColor: UIColor = MSColors.Badge.backgroundDisabled {
        didSet {
            updateBackgroundColor()
        }
    }

    private let backgroundView = UIView()

    public init() {
        super.init(frame: .zero)

        backgroundView.layer.cornerRadius = Constants.backgroundViewCornerRadius
        addSubview(backgroundView)
        updateBackgroundColor()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(badgeTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true

        accessibilityTraits = UIAccessibilityTraitButton
        updateAccessibility()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds
    }

    open func reload() { }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        assertionFailure("MSBadgeBaseView sizeThatFits method must be overridden")
        return .zero
    }

    private func updateAccessibility() {
        if isSelected {
            accessibilityValue = "Accessibility.Selected.Value".localized
            accessibilityHint = "Accessibility.Selected.Hint".localized
        } else {
            accessibilityValue = nil
            accessibilityHint = "Accessibility.Select.Hint".localized
        }
    }

    private func updateBackgroundColor() {
        if !isEnabled {
            backgroundView.backgroundColor = badgeDisabledBackgroundColor
            return
        }
        backgroundView.backgroundColor = isSelected ? badgeSelectedBackgroundColor : badgeBackgroundColor
    }

    @objc private func badgeTapped() {
        if isSelected {
            delegate?.didTapSelectedBadge(self)
        } else {
            isSelected = true
            delegate?.didSelectBadge(self)
        }
    }
}
