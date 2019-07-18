//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSTwoLineTitleViewDelegate

@objc public protocol MSTwoLineTitleViewDelegate: class {
    func twoLineTitleViewDidTapOnTitle(_ twoLineTitleView: MSTwoLineTitleView)
}

// MARK: - MSTwoLineTitleView

open class MSTwoLineTitleView: UIView {
    private struct Constants {
        static let titleButtonLabelMarginBottomRegular: CGFloat = 0
        static let titleButtonLabelMarginBottomCompact: CGFloat = -2
        static let colorAnimationDuration: TimeInterval = 0.2
        static let colorAlpha: CGFloat = 1.0
        static let colorHighlightedAlpha: CGFloat = 0.4
    }

    @objc(MSTwoLineTitleViewStyle)
    public enum Style: Int {
        case light
        case dark
    }

    @objc(MSTwoLineTitleViewInteractivePart)
    public enum InteractivePart: Int {
        case none
        case title
        case subtitle
    }

    @objc(MSTwoLineTitleViewAccessoryType)
    public enum AccessoryType: Int {
        case none
        case disclosure
        case downArrow

        var image: UIImage? {
            switch self {
            case .disclosure:
                return UIImage.staticImageNamed("disclosure")?.imageFlippedForRightToLeftLayoutDirection()
            case .downArrow:
                return UIImage.staticImageNamed("down-arrow-20x20")
            case .none:
                return nil
            }
        }

        var size: CGSize { return image?.size ?? .zero }

        var horizontalPadding: CGFloat {
            switch self {
            case .disclosure:
                return 6
            case .downArrow:
                return 2
            case .none:
                return 0
            }
        }

        var areaWidth: CGFloat {
            return (size.width + horizontalPadding) * 2
        }
    }

    @objc open var titleAccessibilityHint: String? {
        get { return titleButton.accessibilityHint }
        set { titleButton.accessibilityHint = newValue }
    }
    @objc open var titleAccessibilityTraits: UIAccessibilityTraits {
        get { return titleButton.accessibilityTraits }
        set { titleButton.accessibilityTraits = newValue }
    }

    @objc open var subtitleAccessibilityHint: String? {
        get { return subtitleButton.accessibilityHint }
        set { subtitleButton.accessibilityHint = newValue }
    }
    @objc open var subtitleAccessibilityTraits: UIAccessibilityTraits {
        get { return subtitleButton.accessibilityTraits }
        set { subtitleButton.accessibilityTraits = newValue }
    }

    @objc public weak var delegate: MSTwoLineTitleViewDelegate?

    private var interactivePart: InteractivePart = .none
    private var accessoryType: AccessoryType = .none

    private let titleButton = MSEasyTapButton()
    private var titleAccessoryType: AccessoryType {
        return interactivePart == .title ? accessoryType : .none
    }

    private lazy var titleButtonLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = MSFonts.headlineUnscaled
        label.textAlignment = .center
        return label
    }()

    private var titleButtonImageView = UIImageView()

    private let subtitleButton = MSEasyTapButton()
    private var subtitleAccessoryType: AccessoryType {
        return interactivePart == .subtitle ? accessoryType : .none
    }

    private lazy var subtitleButtonLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingMiddle
        label.font = MSFonts.footnoteUnscaled
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    private var subtitleButtonImageView = UIImageView()

    @objc public convenience init(style: Style = .light) {
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
        subtitleButton.addTarget(self, action: #selector(onTitleButtonTapped), for: [.touchUpInside])
        addSubview(subtitleButton)

        subtitleButton.addSubview(subtitleButtonLabel)
        subtitleButton.addSubview(subtitleButtonImageView)

        setupTitleButtonColor(highlighted: false, animated: false)
        setupSubtitleButtonColor(highlighted: false, animated: false)

        titleButtonImageView.contentMode = .scaleAspectFit
        subtitleButtonImageView.contentMode = .scaleAspectFit

        titleButton.accessibilityTraits = [.staticText, .header]
        subtitleButton.accessibilityTraits = [.staticText, .header]
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    /// Sets the relevant strings and button styles for the title and subtitle.
    ///
    /// - Parameters:
    ///   - title: A title string.
    ///   - subtitle: An optional subtitle string. If nil, title will take up entire frame.
    ///   - interactivePart: Determines which line, if any, of the view will have interactive button behavior.
    ///   - accessoryType: Determines which accessory will be shown with the `interactivePart` of the view, if any. Ignored if `interactivePart` is `.none`.
    @objc open func setup(title: String, subtitle: String? = nil, interactivePart: InteractivePart = .none, accessoryType: AccessoryType = .none) {
        self.interactivePart = interactivePart
        self.accessoryType = accessoryType

        setupButton(titleButton, label: titleButtonLabel, imageView: titleButtonImageView, text: title, interactive: interactivePart == .title, accessoryType: accessoryType)
        setupButton(subtitleButton, label: subtitleButtonLabel, imageView: subtitleButtonImageView, text: subtitle, interactive: interactivePart == .subtitle, accessoryType: accessoryType)

        setNeedsLayout()
    }

    // MARK: Highlighting

    private func applyStyle(style: Style) {
        switch style {
        case .dark:
            titleButtonLabel.textColor = MSColors.TwoLineTitle.titleDark
            subtitleButtonLabel.textColor = MSColors.TwoLineTitle.subtitleDark
        case .light:
            titleButtonLabel.textColor = MSColors.TwoLineTitle.titleLight
            subtitleButtonLabel.textColor = MSColors.TwoLineTitle.subtitleLight
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
        let duration = !highlighted && animated ? Constants.colorAnimationDuration : 0

        UIView.animate(withDuration: duration) {
            // Button label
            label.alpha = (highlighted) ? Constants.colorHighlightedAlpha : Constants.colorAlpha

            // Button image view
            imageView.alpha = (highlighted) ? Constants.colorHighlightedAlpha : Constants.colorAlpha
        }
    }

    private func setupButton(_ button: UIButton, label: UILabel, imageView: UIImageView, text: String?, interactive: Bool, accessoryType: AccessoryType) {
        button.isUserInteractionEnabled = interactive
        button.accessibilityLabel = text
        if interactive {
            button.accessibilityTraits.insert(.button)
            button.accessibilityTraits.remove(.staticText)
        } else {
            button.accessibilityTraits.insert(.staticText)
            button.accessibilityTraits.remove(.button)
        }

        label.text = text
        imageView.image = accessoryType.image
        imageView.isHidden = imageView.image == nil
    }

    // MARK: Layout

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var titleSize = titleButtonLabel.sizeThatFits(size)
        titleSize.width += titleAccessoryType.areaWidth

        var subtitleSize = subtitleButtonLabel.sizeThatFits(size)
        subtitleSize.width += subtitleAccessoryType.areaWidth

        return CGSize(width: max(titleSize.width, subtitleSize.width), height: titleSize.height + subtitleSize.height)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let isCompact = traitCollection.verticalSizeClass == .compact

        let titleButtonHeight = titleButtonLabel.font.deviceLineHeight
        let titleBottomMargin = isCompact ? Constants.titleButtonLabelMarginBottomCompact : Constants.titleButtonLabelMarginBottomRegular
        let subtitleButtonHeight = subtitleButtonLabel.font.deviceLineHeight
        let totalContentHeight = titleButtonHeight + titleBottomMargin + subtitleButtonHeight
        var top = UIScreen.main.middleOrigin(bounds.height, containedSizeValue: totalContentHeight)

        titleButton.frame = CGRect(x: 0, y: top, width: bounds.width, height: titleButtonHeight).integral
        top += titleButtonHeight + titleBottomMargin

        let titleButtonLabelMaxWidth = titleButton.bounds.width - titleAccessoryType.areaWidth
        titleButtonLabel.sizeToFit()
        let titleButtonLabelWidth = min(titleButtonLabelMaxWidth, titleButtonLabel.width)
        titleButtonLabel.frame = CGRect(
            x: UIScreen.main.middleOrigin(titleButton.width, containedSizeValue: titleButtonLabelWidth),
            y: 0,
            width: titleButtonLabelWidth,
            height: titleButton.height
        )

        titleButtonImageView.frame = CGRect(
            origin: CGPoint(x: titleButtonLabel.right + titleAccessoryType.horizontalPadding, y: 0),
            size: titleAccessoryType.size
        )

        titleButtonImageView.centerInSuperview(horizontally: false, vertically: true)

        if subtitleButtonLabel.text != nil {
            subtitleButton.frame = CGRect(x: left, y: top, width: bounds.width, height: subtitleButtonHeight).integral

            let subtitleButtonLabelMaxWidth = interactivePart == .subtitle ? subtitleButton.bounds.width - subtitleAccessoryType.areaWidth : titleButton.bounds.width
            subtitleButtonLabel.sizeToFit()
            let subtitleButtonLabelWidth = min(subtitleButtonLabelMaxWidth, subtitleButtonLabel.width)
            subtitleButtonLabel.frame = CGRect(
                x: UIScreen.main.middleOrigin(subtitleButton.width, containedSizeValue: subtitleButtonLabelWidth),
                y: 0,
                width: subtitleButtonLabelWidth,
                height: subtitleButton.height
            )
            subtitleButtonImageView.frame = CGRect(
                x: subtitleButtonLabel.right + subtitleAccessoryType.horizontalPadding,
                y: UIScreen.main.middleOrigin(subtitleButton.height, containedSizeValue: subtitleAccessoryType.size.height),
                width: subtitleAccessoryType.size.width,
                height: subtitleAccessoryType.size.height
            )
        } else {
            // The view is configured as a single line (title) view only.
            titleButton.centerInSuperview()
        }

        titleButton.flipSubviewsForRTL()
        subtitleButton.flipSubviewsForRTL()
    }

    // MARK: Actions

    @objc private func onTitleButtonHighlighted() {
        setupTitleButtonColor(highlighted: true, animated: true)
    }

    @objc private func onTitleButtonUnhighlighted() {
        setupTitleButtonColor(highlighted: false, animated: true)
    }

    @objc private func onTitleButtonTapped() {
        delegate?.twoLineTitleViewDidTapOnTitle(self)
    }

    @objc private func onSubtitleButtonHighlighted() {
        setupSubtitleButtonColor(highlighted: true, animated: true)
    }

    @objc private func onSubtitleButtonUnhighlighted() {
        setupSubtitleButtonColor(highlighted: false, animated: true)
    }

    // MARK: Accessibility

    open override var isAccessibilityElement: Bool { get { return false } set { } }

    open override func accessibilityElementCount() -> Int {
        return subtitleButtonLabel.text != nil ? 2 : 1
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
