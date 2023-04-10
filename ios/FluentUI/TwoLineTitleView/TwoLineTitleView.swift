//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: NavigationBarTitleAccessory enum extensions

extension NavigationBarTitleAccessory: TwoLineTitleViewDelegate {
    public func twoLineTitleViewDidTapOnTitle(_ twoLineTitleView: TwoLineTitleView) {
        guard let delegate = delegate,
              let navigationBar = twoLineTitleView.findSuperview(of: NavigationBar.self) as? NavigationBar else {
            return
        }
        delegate.navigationBarDidTapOnTitle(navigationBar)
    }
}

fileprivate extension NavigationBarTitleAccessory.Location {
    var twoLineTitleViewInteractivePart: TwoLineTitleView.InteractivePart {
        switch self {
        case .title:
            return .title
        case .subtitle:
            return .subtitle
        }
    }
}

fileprivate extension NavigationBarTitleAccessory.Style {
    var twoLineTitleViewAccessoryType: TwoLineTitleView.AccessoryType {
        switch self {
        case .downArrow:
            return .downArrow
        case .disclosure:
            return .disclosure
        }
    }
}

// MARK: TwoLineTitleViewDelegate

/// Handles user interactions with a `TwoLineTitleView`.
@objc(MSFTwoLineTitleViewDelegate)
public protocol TwoLineTitleViewDelegate: AnyObject {
    /// Tells the delegate that a particular `TwoLineTitleView` was tapped.
    func twoLineTitleViewDidTapOnTitle(_ twoLineTitleView: TwoLineTitleView)
}

// MARK: - TwoLineTitleView

@objc(MSFTwoLineTitleView)
open class TwoLineTitleView: UIView, TokenizedControlInternal {
    @objc(MSFTwoLineTitleViewStyle)
    public enum Style: Int {
        case primary
        case system
    }

    @objc(MSFTwoLineTitleViewAlignment)
    public enum Alignment: Int {
        case center
        case leading
    }

    @objc(MSFTwoLineTitleViewInteractivePart)
    public enum InteractivePart: Int {
        // The @objc requirement doesn't let us use OptionSet, so we provide the bitmasks and the `contains` method ourselves
        case none = 0
        case title = 0b01
        case subtitle = 0b10
        case all = 0b11

        func contains(_ other: InteractivePart) -> Bool {
            return rawValue & other.rawValue != 0
        }
    }

    @objc(MSFTwoLineTitleViewAccessoryType)
    public enum AccessoryType: Int {
        case none
        case disclosure
        case downArrow

        var image: UIImage? {
            let image: UIImage?
            switch self {
            case .disclosure:
                image = UIImage.staticImageNamed("chevron-right-20x20")
            case .downArrow:
                image = UIImage.staticImageNamed("chevron-down-20x20")
            case .none:
                image = nil
            }
            return image
        }

        var size: CGSize { return image?.size ?? .zero }

        var horizontalPadding: CGFloat {
            switch self {
            case .disclosure:
                return 0
            case .downArrow:
                return -1
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

    public typealias TokenSetKeyType = TwoLineTitleViewTokenSet.Tokens
    public lazy var tokenSet: TwoLineTitleViewTokenSet = .init(style: { [weak self] in
        self?.currentStyle ?? .system
    })

    @objc public weak var delegate: TwoLineTitleViewDelegate?

    private var alignment: Alignment = .center
    private var interactivePart: InteractivePart = .none
    private var animatesWhenPressed: Bool = true
    private var accessoryType: AccessoryType = .none

    private let titleButton = EasyTapButton()
    private var titleAccessoryType: AccessoryType {
        return interactivePart.contains(.title) ? accessoryType : .none
    }

    var currentStyle: Style {
        didSet {
            applyStyle()
        }
    }

    private lazy var titleButtonLabel: Label = {
        let label = Label()
        label.lineBreakMode = .byTruncatingTail
        label.tokenSet[.font] = tokenSet[.titleFont]
        label.textAlignment = .center
        return label
    }()

    private var titleButtonLeadingImageView = UIImageView()
    private var titleButtonTrailingImageView = UIImageView()

    private var titleButtonLeadingImageAreaWidth: CGFloat {
        return titleButtonLeadingImageView.image != nil ? 2 * TokenSetType.leadingImageTotalPadding : 0
    }

    private let subtitleButton = EasyTapButton()
    private var subtitleAccessoryType: AccessoryType {
        return interactivePart.contains(.subtitle) ? accessoryType : .none
    }

    private lazy var subtitleButtonLabel: Label = {
        let label = Label()
        label.lineBreakMode = .byTruncatingMiddle
        label.tokenSet[.font] = tokenSet[.subtitleFont]
        return label
    }()

    private var subtitleButtonImageView = UIImageView()

    @objc public convenience init(style: Style = .primary) {
        self.init(frame: .zero)
        self.currentStyle = style

        applyStyle()
    }

    public override init(frame: CGRect) {
        self.currentStyle = .system

        super.init(frame: frame)

        tokenSet.registerOnUpdate(for: self) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.applyStyle()
            strongSelf.updateFonts()
        }

        applyStyle()

        titleButton.addTarget(self, action: #selector(onTitleButtonHighlighted), for: [.touchDown, .touchDragInside, .touchDragEnter])
        titleButton.addTarget(self, action: #selector(onTitleButtonUnhighlighted), for: [.touchUpInside, .touchDragOutside, .touchDragExit])
        titleButton.addTarget(self, action: #selector(onTitleButtonTapped), for: [.touchUpInside])
        addSubview(titleButton)

        titleButton.addSubview(titleButtonLeadingImageView)
        titleButton.addSubview(titleButtonLabel)
        titleButton.addSubview(titleButtonTrailingImageView)

        subtitleButton.addTarget(self, action: #selector(onSubtitleButtonHighlighted), for: [.touchDown, .touchDragInside, .touchDragEnter])
        subtitleButton.addTarget(self, action: #selector(onSubtitleButtonUnhighlighted), for: [.touchUpInside, .touchDragOutside, .touchDragExit])
        subtitleButton.addTarget(self, action: #selector(onTitleButtonTapped), for: [.touchUpInside])
        addSubview(subtitleButton)

        subtitleButton.addSubview(subtitleButtonLabel)
        subtitleButton.addSubview(subtitleButtonImageView)

        setupTitleButtonColor(highlighted: false, animated: false)
        setupSubtitleButtonColor(highlighted: false, animated: false)

        titleButtonLeadingImageView.contentMode = .scaleAspectFit
        titleButtonTrailingImageView.contentMode = .scaleAspectFit
        subtitleButtonImageView.contentMode = .scaleAspectFit

        titleButton.accessibilityTraits = [.staticText, .header]
        subtitleButton.accessibilityTraits = [.staticText, .header]

        addInteraction(UILargeContentViewerInteraction())
        titleButtonLabel.showsLargeContentViewer = true
        subtitleButtonLabel.showsLargeContentViewer = true

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)

        updateFonts()
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
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
        setup(title: title, subtitle: subtitle, alignment: .center, interactivePart: interactivePart, animatesWhenPressed: true, accessoryType: accessoryType)
    }

    /// Sets the relevant strings and button styles for the title and subtitle.
    ///
    /// - Parameters:
    ///   - title: A title string.
    ///   - titleImage: An optional image to display before the title.
    ///   - subtitle: An optional subtitle string. If nil, title will take up entire frame.
    ///   - alignment: How to align the title and subtitle. Ignored if `subtitle` is nil.
    ///   - interactivePart: Determines which line, if any, of the view will have interactive button behavior.
    ///   - animatesWhenPressed: If true, the text color will flash when pressed. Ignored if `interactivePart` is `.none`.
    ///   - accessoryType: Determines which accessory will be shown with the `interactivePart` of the view, if any. Ignored if `interactivePart` is `.none`.
    @objc open func setup(title: String, titleImage: UIImage? = nil, subtitle: String? = nil, alignment: Alignment = .center, interactivePart: InteractivePart = .none, animatesWhenPressed: Bool = true, accessoryType: AccessoryType = .none) {
        self.alignment = alignment
        self.interactivePart = interactivePart
        self.animatesWhenPressed = animatesWhenPressed
        self.accessoryType = accessoryType

        titleButtonLeadingImageView.image = titleImage
        titleButtonLeadingImageView.isHidden = titleImage == nil

        setupButton(titleButton, label: titleButtonLabel, trailingImageView: titleButtonTrailingImageView, text: title, interactive: interactivePart.contains(.title), accessoryType: accessoryType)
        // Check for strict equality for the subtitle button's interactivity.
        // If the whole area is active, we'll stretch the title button to adjust the hit area
        // while still only keeping one button active from an accessibility standpoint.
        setupButton(subtitleButton, label: subtitleButtonLabel, trailingImageView: subtitleButtonImageView, text: subtitle, interactive: interactivePart == .subtitle, accessoryType: accessoryType)

        if #available(iOS 15.0, *) {
            let subtitleIsNilOrEmpty = subtitle?.isEmpty ?? true
            minimumContentSizeCategory = .large
            maximumContentSizeCategory = subtitleIsNilOrEmpty ? .extraExtraLarge : .large
        }

        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    @objc open func setup(navigationItem: UINavigationItem) {
        let title = navigationItem.title ?? ""
        let alignment: Alignment = navigationItem.usesLargeTitle ? .leading : .center

        let interactivePart: InteractivePart
        let accessoryType: AccessoryType
        let animatesWhenPressed: Bool
        if let titleAccessory = navigationItem.titleAccessory {
            // Use the custom action provided by the title accessory specification
            interactivePart = titleAccessory.location.twoLineTitleViewInteractivePart
            accessoryType = titleAccessory.style.twoLineTitleViewAccessoryType
            animatesWhenPressed = true
            delegate = titleAccessory
        } else {
            // Use the default behavior of requesting expansion of the hosting navigation bar
            interactivePart = .all
            accessoryType = .none
            animatesWhenPressed = false
        }

        setup(title: title, titleImage: navigationItem.titleImage, subtitle: navigationItem.subtitle, alignment: alignment, interactivePart: interactivePart, animatesWhenPressed: animatesWhenPressed, accessoryType: accessoryType)
    }

    // MARK: Highlighting

    private func applyStyle() {
        titleButtonLabel.tokenSet.setOverrideValue(tokenSet.overrideValue(forToken: .titleColor), forToken: .textColor)
        let titleColor = titleButtonLabel.tokenSet[.textColor].uiColor
        titleButtonLeadingImageView.tintColor = titleColor
        titleButtonTrailingImageView.tintColor = titleColor

        subtitleButtonLabel.tokenSet.setOverrideValue(tokenSet.overrideValue(forToken: .subtitleColor), forToken: .textColor)
        subtitleButtonImageView.tintColor = subtitleButtonLabel.tokenSet[.textColor].uiColor
    }

    private func setupTitleButtonColor(highlighted: Bool, animated: Bool) {
        setupColor(highlighted: highlighted, animated: animated, onLabel: titleButtonLabel, onImageViews: [titleButtonLeadingImageView, titleButtonTrailingImageView])
    }

    private func setupSubtitleButtonColor(highlighted: Bool, animated: Bool) {
        setupColor(highlighted: highlighted, animated: animated, onLabel: subtitleButtonLabel, onImageView: subtitleButtonImageView)
    }

    private func setupColor(highlighted: Bool, animated: Bool, onLabel label: UILabel, onImageView imageView: UIImageView) {
        setupColor(highlighted: highlighted, animated: animated, onLabel: label, onImageViews: [imageView])
    }

    private func setupColor(highlighted: Bool, animated: Bool, onLabel label: UILabel, onImageViews imageViews: [UIImageView]) {
        // Highlighting is never animated to match iOS
        let duration = !highlighted && animated ? TokenSetType.textColorAnimationDuration : 0

        UIView.animate(withDuration: duration) {
            let alpha = TokenSetType.textColorAlpha(highlighted: highlighted)

            // Button label
            label.alpha = alpha

            // Button image views
            imageViews.forEach {
                $0.alpha = alpha
            }
        }
    }

    private func setupButton(_ button: UIButton, label: UILabel, trailingImageView: UIImageView, text: String?, interactive: Bool, accessoryType: AccessoryType) {
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
        trailingImageView.image = accessoryType.image
        trailingImageView.isHidden = trailingImageView.image == nil
    }

    // MARK: Layout

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var titleSize = titleButtonLabel.sizeThatFits(size)
        titleSize.width += max(titleAccessoryType.areaWidth, titleButtonLeadingImageAreaWidth)

        var subtitleSize = subtitleButtonLabel.sizeThatFits(size)
        subtitleSize.width += subtitleAccessoryType.areaWidth

        return CGSize(width: max(titleSize.width, subtitleSize.width), height: titleSize.height + subtitleSize.height)
    }

    open override var intrinsicContentSize: CGSize {
        let size = sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return size
    }

    private func updateFonts() {
        titleButtonLabel.tokenSet.setOverrideValue(tokenSet.overrideValue(forToken: .titleFont), forToken: .font)
        subtitleButtonLabel.tokenSet.setOverrideValue(tokenSet.overrideValue(forToken: .subtitleFont), forToken: .font)

        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        applyStyle()
        updateFonts()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let titleButtonHeight = titleButtonLabel.font.lineHeight
        let titleBottomMargin = TokenSetType.titleSpacing(for: traitCollection.verticalSizeClass)
        let subtitleButtonHeight = subtitleButtonLabel.font.lineHeight
        let totalContentHeight = titleButtonHeight + titleBottomMargin + subtitleButtonHeight
        var top = ceil((bounds.height - totalContentHeight) / 2.0)

        titleButton.frame = CGRect(x: 0, y: top, width: bounds.width, height: titleButtonHeight).integral
        top += titleButtonHeight + titleBottomMargin

        let titleButtonLabelMaxWidth = titleButton.bounds.width - max(titleAccessoryType.areaWidth, titleButtonLeadingImageAreaWidth)
        titleButtonLabel.sizeToFit()
        let titleButtonLabelWidth = min(titleButtonLabelMaxWidth, titleButtonLabel.frame.width)
        titleButtonLabel.frame = CGRect(
            x: alignment == .center ? ceil((titleButton.frame.width - titleButtonLabelWidth) / 2.0) : 0,
            y: 0,
            width: titleButtonLabelWidth,
            height: titleButton.frame.height
        )

        titleButtonTrailingImageView.frame = CGRect(
            origin: CGPoint(x: titleButtonLabel.frame.maxX + titleAccessoryType.horizontalPadding, y: 0),
            size: titleAccessoryType.size
        )

        titleButtonTrailingImageView.centerInSuperview(horizontally: false, vertically: true)

        if titleButtonLeadingImageView.image != nil {
            titleButtonLeadingImageView.frame = CGRect(
                origin: CGPoint(x: titleButtonLabel.frame.minX - TokenSetType.leadingImageTotalPadding, y: 0),
                size: CGSize(width: TokenSetType.leadingImageSize, height: TokenSetType.leadingImageSize))
            titleButtonLeadingImageView.centerInSuperview(horizontally: false, vertically: true)

            if alignment == .leading {
                // Shift everything over so the leading image lines up with the leading side instead of the text
                titleButton.subviews.forEach {
                    $0.frame.origin.x += TokenSetType.leadingImageTotalPadding
                }
            }
        }

        if let subtitle = subtitleButtonLabel.text, !subtitle.isEmpty {
            subtitleButton.frame = CGRect(x: frame.origin.x, y: top, width: bounds.width, height: subtitleButtonHeight).integral

            let subtitleButtonLabelMaxWidth = interactivePart.contains(.subtitle) ? subtitleButton.bounds.width - subtitleAccessoryType.areaWidth : titleButton.bounds.width
            subtitleButtonLabel.sizeToFit()
            let subtitleButtonLabelWidth = min(subtitleButtonLabelMaxWidth, subtitleButtonLabel.frame.width)
            subtitleButtonLabel.frame = CGRect(
                x: alignment == .center ? ceil((subtitleButton.frame.width - subtitleButtonLabelWidth) / 2.0) : 0,
                y: 0,
                width: subtitleButtonLabelWidth,
                height: subtitleButton.frame.height
            )
            subtitleButtonImageView.frame = CGRect(
                x: subtitleButtonLabel.frame.maxX + subtitleAccessoryType.horizontalPadding,
                y: ceil((subtitleButton.frame.height - subtitleAccessoryType.size.height) / 2.0),
                width: subtitleAccessoryType.size.width,
                height: subtitleAccessoryType.size.height
            )
        } else {
            // The view is configured as a single line (title) view only.
            titleButton.centerInSuperview()
        }

        if interactivePart == .all {
            // Use one giant button instead of two
            titleButton.frame = titleButton.frame.union(subtitleButton.frame)
            subtitleButton.isUserInteractionEnabled = false
        }

        titleButton.flipSubviewsForRTL()
        subtitleButton.flipSubviewsForRTL()
    }

    @objc private func handleContentSizeCategoryDidChange() {
        invalidateIntrinsicContentSize()
    }

    // MARK: Actions

    @objc private func onTitleButtonHighlighted() {
        guard animatesWhenPressed else {
            return
        }
        setupTitleButtonColor(highlighted: true, animated: true)
        if interactivePart == .all {
            onSubtitleButtonHighlighted()
        }
    }

    @objc private func onTitleButtonUnhighlighted() {
        guard animatesWhenPressed else {
            return
        }
        setupTitleButtonColor(highlighted: false, animated: true)
        if interactivePart == .all {
            onSubtitleButtonUnhighlighted()
        }
    }

    @objc private func onTitleButtonTapped() {
        delegate?.twoLineTitleViewDidTapOnTitle(self)
    }

    @objc private func onSubtitleButtonHighlighted() {
        guard animatesWhenPressed else {
            return
        }
        setupSubtitleButtonColor(highlighted: true, animated: true)
    }

    @objc private func onSubtitleButtonUnhighlighted() {
        guard animatesWhenPressed else {
            return
        }
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
