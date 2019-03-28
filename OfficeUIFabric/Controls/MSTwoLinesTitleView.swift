//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSTwoLinesTitleViewDelegate

@objc public protocol MSTwoLinesTitleViewDelegate: class {
    func twoLinesTitleView(_ twoLinesTitleView: MSTwoLinesTitleView, didTapOnTitle title: String)
}

// MARK: - MSTwoLinesTitleViewButtonStyle

@objc public enum MSTwoLinesTitleViewButtonStyle: Int {
    case disclosure
    case downArrow

    public var imageName: String {
        switch self {
        case .disclosure:
            return "disclosure-indicator"
        case .downArrow:
            return "down-arrow-20x20"
        }
    }

    public var width: CGFloat {
        switch self {
        case .disclosure:
            return 8
        case .downArrow:
            return 14
        }
    }

    public var height: CGFloat {
        switch self {
        case .disclosure:
            return 20
        case .downArrow:
            return 12
        }
    }

    public var horizontalPadding: CGFloat {
        switch self {
        case .disclosure:
            return 6
        case .downArrow:
            return 2
        }
    }
}

// MARK: - MSTwoLinesTitleStyle

@objc public enum MSTwoLinesTitleStyle: Int {
    case light
    case dark
}

// MARK: - MSTwoLinesTitleView

open class MSTwoLinesTitleView: UIView {
    private struct Constants {
        static let titleButtonLabelMarginBottomRegular: CGFloat = 0
        static let titleButtonLabelMarginBottomCompact: CGFloat = -2
        static let colorAnimationDuration: TimeInterval = 0.2
        static let colorAlpha: CGFloat = 1.0
        static let colorHighlightedAlpha: CGFloat = 0.4
    }

    open var titleAccessibilityHint: String? {
        didSet {
            titleButton.accessibilityHint = titleAccessibilityHint
        }
    }
    open var titleAccessibilityTrait: UIAccessibilityTraits = [.staticText, .header] {
        didSet {
            titleButton.accessibilityTraits = titleAccessibilityTrait
        }
    }

    open var subtitleAccessibilityHint: String? {
        didSet {
            subtitleButton.accessibilityHint = subtitleAccessibilityHint
        }
    }
    open var subtitleAccessibilityTrait: UIAccessibilityTraits = [.staticText, .header] {
        didSet {
            subtitleButton.accessibilityTraits = subtitleAccessibilityTrait
        }
    }

    public weak var delegate: MSTwoLinesTitleViewDelegate?

    private let titleButton = MSEasyTapButton()

    private lazy var titleButtonLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = MSFonts.headline
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    private var titleButtonImageView = UIImageView()
    private var titleButtonStyle: MSTwoLinesTitleViewButtonStyle?

    private let subtitleButton = MSEasyTapButton()

    private lazy var subtitleButtonLabel: UILabel = {
        let subtitleButtonLabel = UILabel()
        subtitleButtonLabel.lineBreakMode = .byTruncatingMiddle
        subtitleButtonLabel.font = MSFonts.footnote
        subtitleButtonLabel.adjustsFontSizeToFitWidth = true
        subtitleButtonLabel.minimumScaleFactor = 0.8
        return subtitleButtonLabel
    }()

    private var subtitleButtonImageView = UIImageView()
    private var subtitleButtonStyle: MSTwoLinesTitleViewButtonStyle?

    @objc public convenience init(style: MSTwoLinesTitleStyle = .light) {
        self.init(frame: .zero)
        applyStyle(style: style)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        applyStyle(style: .dark)

        titleButton.addTarget(self, action: #selector(onTitleButtonHighlighted), for: [.touchDown, .touchDragInside, .touchDragEnter])
        titleButton.addTarget(self, action: #selector(onTitleButtonUnhighlighted), for: [.touchUpInside, .touchDragOutside, .touchDragExit])
        titleButton.addTarget(self, action: #selector(onTitleButtonTapped), for: [.touchUpInside])
        addSubview(titleButton)

        titleButton.addSubview(titleButtonLabel)
        titleButton.addSubview(titleButtonImageView)

        subtitleButton.addTarget(self, action: #selector(onSubtitleButtonHighlighted), for: [.touchDown, .touchDragInside, .touchDragEnter])
        subtitleButton.addTarget(self, action: #selector(onSubtitleButtonUnhighlighted), for: [.touchUpInside, .touchDragOutside, .touchDragExit])
        addSubview(subtitleButton)

        subtitleButton.addSubview(subtitleButtonLabel)
        subtitleButton.addSubview(subtitleButtonImageView)

        setupTitleButtonColor(highlighted: false, animated: false)
        setupSubtitleButtonColor(highlighted: false, animated: false)

        titleButtonImageView.contentMode = .scaleAspectFit
        subtitleButtonImageView.contentMode = .scaleAspectFit
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    open func setup(title: String, subtitle: String? = nil, titleButtonStyle: MSTwoLinesTitleViewButtonStyle? = nil, subtitleButtonStyle: MSTwoLinesTitleViewButtonStyle? = nil) {
        let hasTitleButton: Bool = titleButtonStyle != nil
        titleButtonLabel.text = title
        titleButton.accessibilityLabel = titleButtonLabel.text
        titleButton.isUserInteractionEnabled = hasTitleButton
        titleButtonImageView.isHidden = !hasTitleButton
        self.titleButtonStyle = titleButtonStyle
        if let titleButtonStyle = titleButtonStyle {
            titleButtonImageView.image = UIImage(named: titleButtonStyle.imageName)
        }

        let hasSubtitleButton: Bool = subtitleButtonStyle != nil
        subtitleButtonLabel.text = subtitle
        subtitleButton.isUserInteractionEnabled = hasSubtitleButton
        subtitleButton.accessibilityLabel = subtitle
        subtitleButtonImageView.isHidden = !hasSubtitleButton
        self.subtitleButtonStyle = subtitleButtonStyle
        if let subtitleButtonStyle = subtitleButtonStyle {
            subtitleButtonImageView.image = UIImage(named: subtitleButtonStyle.imageName)
        }

        setNeedsLayout()
    }

    // MARK: Highlighting

    private func applyStyle(style: MSTwoLinesTitleStyle) {
        switch style {
        case .dark:
            titleButtonLabel.textColor = MSColors.primary
            subtitleButtonLabel.textColor = MSColors.gray
        case .light:
            titleButtonLabel.textColor = MSColors.white
            subtitleButtonLabel.textColor = MSColors.white.withAlphaComponent(0.8)
        }
    }

    private func setupTitleButtonColor(highlighted: Bool, animated: Bool) {
        setupColor(highlighted: highlighted, animated: animated, onLabel: titleButtonLabel, onImageView: titleButtonImageView)
    }

    private func setupSubtitleButtonColor(highlighted: Bool, animated: Bool) {
        setupColor(highlighted: highlighted, animated: animated, onLabel: subtitleButtonLabel, onImageView: subtitleButtonImageView)
    }

    private func setupColor(highlighted: Bool, animated: Bool, onLabel label: UILabel, onImageView imageView: UIImageView) {
        // Highlighting is never animated to match iOS
        let duration = !highlighted && animated ? Constants.colorAnimationDuration : 0.0

        UIView.animate(withDuration: duration) {
            // Button label
            label.alpha = (highlighted) ? Constants.colorHighlightedAlpha : Constants.colorAlpha

            // Button image view
            imageView.alpha = (highlighted) ? Constants.colorHighlightedAlpha : Constants.colorAlpha
        }
    }

    // MARK: Layout

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var titleSize = titleButtonLabel.sizeThatFits(size)
        if let titleButtonStyle = titleButtonStyle {
            titleSize.width += 2 * (titleButtonStyle.width + titleButtonStyle.horizontalPadding)
        }

        var subtitleSize = subtitleButtonLabel.sizeThatFits(size)
        if let subtitleButtonStyle = subtitleButtonStyle {
            subtitleSize.width += 2 * (subtitleButtonStyle.width + subtitleButtonStyle.horizontalPadding)
        }

        return CGSize(width: max(titleSize.width, subtitleSize.width), height: titleSize.height + subtitleSize.height)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let isCompact = traitCollection.verticalSizeClass == .compact

        let titleButtonHeight = ceil(titleButtonLabel.font.lineHeight)
        let titleBottomMargin = isCompact ? Constants.titleButtonLabelMarginBottomCompact : Constants.titleButtonLabelMarginBottomRegular
        let subtitleButtonHeight = ceil(subtitleButtonLabel.font.lineHeight)
        let totalContentHeight = titleButtonHeight + titleBottomMargin + subtitleButtonHeight
        var top = UIScreen.main.middleOrigin(bounds.height, containedSizeValue: totalContentHeight)

        titleButton.frame = CGRect(x: 0, y: top, width: bounds.width, height: titleButtonHeight).integral
        top += titleButtonHeight + titleBottomMargin

        let titleButtonLabelMaxWidth = titleButtonStyle != nil ? titleButton.bounds.width - 2 * ((titleButtonStyle?.width ?? 0) + (titleButtonStyle?.horizontalPadding ?? 0)) : titleButton.bounds.width
        titleButtonLabel.sizeToFit()
        let titleButtonLabelWidth = min(titleButtonLabelMaxWidth, titleButtonLabel.width)
        titleButtonLabel.frame = CGRect(
            x: UIScreen.main.middleOrigin(titleButton.width, containedSizeValue: titleButtonLabelWidth),
            y: 0,
            width: titleButtonLabelWidth,
            height: titleButton.height
        )

        if let titleButtonStyle = self.titleButtonStyle {
            titleButtonImageView.frame = CGRect(
                x: titleButtonLabel.right + titleButtonStyle.horizontalPadding,
                y: 0,
                width: titleButtonStyle.width,
                height: titleButtonStyle.height
            )
        } else {
            titleButtonImageView.frame = .zero
        }

        titleButtonImageView.centerInSuperview(horizontally: false, vertically: true)

        if subtitleButtonLabel.text != nil {
            subtitleButton.frame = CGRect(x: left, y: top, width: bounds.width, height: subtitleButtonHeight).integral

            let subtitleButtonLabelMaxWidth = subtitleButtonStyle != nil ? subtitleButton.bounds.width - 2 * ((subtitleButtonStyle?.width ?? 0) + (subtitleButtonStyle?.horizontalPadding ?? 0)) : titleButton.bounds.width // "2 *" is here so that if the label fills the max width, it will stay centered against the titleLabel.
            subtitleButtonLabel.sizeToFit()
            let subtitleButtonLabelWidth = min(subtitleButtonLabelMaxWidth, subtitleButtonLabel.width)
            subtitleButtonLabel.frame = CGRect(
                x: UIScreen.main.middleOrigin(subtitleButton.width, containedSizeValue: subtitleButtonLabelWidth),
                y: 0,
                width: subtitleButtonLabelWidth,
                height: subtitleButton.height
            )

            if let subtitleButtonStyle = self.subtitleButtonStyle {
                subtitleButtonImageView.frame = CGRect(
                    x: subtitleButtonLabel.right + subtitleButtonStyle.horizontalPadding,
                    y: ceil(UIScreen.main.middleOrigin(subtitleButton.height, containedSizeValue: subtitleButtonStyle.height)) + 1.0,
                    width: subtitleButtonStyle.width,
                    height: subtitleButtonStyle.height
                )
            } else {
                subtitleButtonImageView.frame = .zero
            }
        } else {
            // The view is configured as a single line (title) view only.
            titleButton.centerInSuperview()
        }
    }

    // MARK: Actions

    @objc func onTitleButtonHighlighted() {
        setupTitleButtonColor(highlighted: true, animated: true)
    }

    @objc func onTitleButtonUnhighlighted() {
        setupTitleButtonColor(highlighted: false, animated: true)
    }

    @objc func onTitleButtonTapped() {
        delegate?.twoLinesTitleView(self, didTapOnTitle: titleButtonLabel.text ?? "")
    }

    @objc func onSubtitleButtonHighlighted() {
        setupSubtitleButtonColor(highlighted: true, animated: true)
    }

    @objc func onSubtitleButtonUnhighlighted() {
        setupSubtitleButtonColor(highlighted: false, animated: true)
    }

    // MARK: Accessibility

    open override var isAccessibilityElement: Bool { get { return false } set { } }

    open override func accessibilityElementCount() -> Int {
        return 2
    }

    open override func accessibilityElement(at index: Int) -> Any? {
        if index == 0 {
            return titleButton
        } else if index == 1 {
            return subtitleButton
        }
        return nil
    }

    open override func index(ofAccessibilityElement element: Any) -> Int {
        if let view = element as? UIView {
            return view == titleButton ? 0 : 1
        }
        return -1
    }
}
