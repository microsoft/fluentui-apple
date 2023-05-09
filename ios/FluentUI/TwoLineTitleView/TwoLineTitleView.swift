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

        var stackViewAlignment: UIStackView.Alignment {
            switch self {
            case .center:
                return .center
            case .leading:
                return .leading
            }
        }
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

        public func image(forSize size: GlobalTokens.IconSizeToken) -> UIImage? {
            let image: UIImage?
            switch (self, size) {
            case (.disclosure, .size120):
                image = UIImage.staticImageNamed("chevron-right-12x12")
            case (.disclosure, .size160):
                image = UIImage.staticImageNamed("chevron-right-16x16")
            case (.downArrow, .size120):
                image = UIImage.staticImageNamed("chevron-down-12x12")
            case (.downArrow, .size160):
                image = UIImage.staticImageNamed("chevron-down-16x16")
            case (.disclosure, _), (.downArrow, _), (.none, _):
                image = nil
            }
            return image
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

    var currentStyle: Style {
        didSet {
            applyStyle()
        }
    }

    private var alignment: Alignment = .center
    private var interactivePart: InteractivePart = .none
    private var animatesWhenPressed: Bool = true
    private var accessoryType: AccessoryType = .none

    private let containerButton = EasyTapButton()
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()

    private static func titleLineStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = TokenSetType.titleStackSpacing
        return stackView
    }

    private lazy var titleContainer = Self.titleLineStackView()
    private lazy var subtitleContainer = Self.titleLineStackView()

    private let titleButton = EasyTapButton() // TODO: remove me!
    private var titleAccessoryType: AccessoryType {
        return interactivePart.contains(.title) ? accessoryType : .none
    }

    private lazy var titleLabel: Label = {
        let label = Label(textStyle: TokenSetType.defaultTitleFont)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()

    private var titleLeadingImageView = UIImageView()
    private var titleTrailingImageView = UIImageView()

    private let subtitleButton = EasyTapButton() // TODO: remove me!
    private var subtitleAccessoryType: AccessoryType {
        return interactivePart.contains(.subtitle) ? accessoryType : .none
    }

    private lazy var subtitleLabel: Label = {
        let label = Label(textStyle: TokenSetType.defaultSubtitleFont)
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()

    private var subtitleImageView = UIImageView()

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

        contain(view: containerButton)
        containerButton.contain(view: containerStackView)

        // Ensure image views maintain their aspect ratios
        titleLeadingImageView.contentMode = .scaleAspectFit
        titleTrailingImageView.contentMode = .scaleAspectFit
        subtitleImageView.contentMode = .scaleAspectFit

        // Accessibility features
        titleButton.accessibilityTraits = [.staticText, .header]
        subtitleButton.accessibilityTraits = [.staticText, .header]

        addInteraction(UILargeContentViewerInteraction())
        titleLabel.showsLargeContentViewer = true
        subtitleLabel.showsLargeContentViewer = true

        /*titleButton.addTarget(self, action: #selector(onTitleButtonHighlighted), for: [.touchDown, .touchDragInside, .touchDragEnter])
        titleButton.addTarget(self, action: #selector(onTitleButtonUnhighlighted), for: [.touchUpInside, .touchDragOutside, .touchDragExit])
        titleButton.addTarget(self, action: #selector(onTitleButtonTapped), for: [.touchUpInside])
        addSubview(titleButton)

        titleButton.addSubview(titleLeadingImageView)
        titleButton.addSubview(titleLabel)
        titleButton.addSubview(titleTrailingImageView)

        subtitleButton.addTarget(self, action: #selector(onSubtitleButtonHighlighted), for: [.touchDown, .touchDragInside, .touchDragEnter])
        subtitleButton.addTarget(self, action: #selector(onSubtitleButtonUnhighlighted), for: [.touchUpInside, .touchDragOutside, .touchDragExit])
        subtitleButton.addTarget(self, action: #selector(onTitleButtonTapped), for: [.touchUpInside])
        addSubview(subtitleButton)

        subtitleButton.addSubview(subtitleLabel)
        subtitleButton.addSubview(subtitleImageView)

        setupTitleColor(highlighted: false, animated: false)
        setupSubtitleColor(highlighted: false, animated: false)*/

        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
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

        titleLeadingImageView.image = titleImage
        titleLeadingImageView.isHidden = titleImage == nil

        setupTitleLine(titleContainer, label: titleLabel, trailingImageView: titleTrailingImageView, imageSize: TokenSetType.titleImageSizeToken, text: title, interactive: interactivePart.contains(.title), accessoryType: accessoryType)
        if titleLeadingImageView.image != nil {
            titleContainer.insertArrangedSubview(titleLeadingImageView, at: 0)
        }

        // Check for strict equality for the subtitle button's interactivity.
        // If the whole area is active, we'll use the title as the main accessibility item.
        setupTitleLine(subtitleContainer, label: subtitleLabel, trailingImageView: subtitleImageView, imageSize: TokenSetType.subtitleImageSizeToken, text: subtitle, interactive: interactivePart == .subtitle, accessoryType: accessoryType)

        minimumContentSizeCategory = .large

        containerStackView.removeAllSubviews()
        containerStackView.alignment = alignment.stackViewAlignment
        containerStackView.addArrangedSubview(titleContainer)

        if subtitle?.isEmpty == false {
            maximumContentSizeCategory = .large
            containerStackView.addArrangedSubview(subtitleContainer)
        } else {
            maximumContentSizeCategory = .extraExtraLarge
        }

        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    @objc open func setup(navigationItem: UINavigationItem) {
        let title = navigationItem.title ?? ""
        let alignment: Alignment = navigationItem.titleStyle == .system ? .center : .leading

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
        // Reset color styles since they might have changed
        titleLabel.colorStyle = TokenSetType.defaultTitleColorStyle(for: currentStyle)
        subtitleLabel.colorStyle = TokenSetType.defaultSubtitleColorStyle(for: currentStyle)

        titleLabel.tokenSet.setOverrides(from: tokenSet, mapping: [.textColor: .titleColor])
        let titleColor = titleLabel.tokenSet[.textColor].uiColor
        titleLeadingImageView.tintColor = titleColor
        titleTrailingImageView.tintColor = titleColor

        subtitleLabel.tokenSet.setOverrides(from: tokenSet, mapping: [.textColor: .subtitleColor])
        subtitleImageView.tintColor = subtitleLabel.tokenSet[.textColor].uiColor
    }

    private func setupTitleColor(highlighted: Bool, animated: Bool) {
        setupColor(highlighted: highlighted, animated: animated, onLabel: titleLabel, onImageViews: [titleLeadingImageView, titleTrailingImageView])
    }

    private func setupSubtitleColor(highlighted: Bool, animated: Bool) {
        setupColor(highlighted: highlighted, animated: animated, onLabel: subtitleLabel, onImageView: subtitleImageView)
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

    private func setupTitleLine(_ container: UIStackView, label: UILabel, trailingImageView: UIImageView, imageSize: GlobalTokens.IconSizeToken, text: String?, interactive: Bool, accessoryType: AccessoryType) {
        container.removeAllSubviews()

        container.isUserInteractionEnabled = interactive
        container.accessibilityLabel = text
        label.text = text

        container.addArrangedSubview(label)

        if interactive {
            container.accessibilityTraits.insert(.button)
            container.accessibilityTraits.remove(.staticText)
            trailingImageView.image = accessoryType.image(forSize: imageSize)
        } else {
            container.accessibilityTraits.insert(.staticText)
            container.accessibilityTraits.remove(.button)
            trailingImageView.image = nil
        }

        trailingImageView.isHidden = trailingImageView.image == nil
        if trailingImageView.image != nil {
            container.addArrangedSubview(trailingImageView)
        }
    }

    // MARK: Layout

    private func updateFonts() {
        titleLabel.tokenSet.setOverrides(from: tokenSet, mapping: [.font: .titleFont])
        subtitleLabel.tokenSet.setOverrides(from: tokenSet, mapping: [.font: .subtitleFont])

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

    @objc private func handleContentSizeCategoryDidChange() {
        invalidateIntrinsicContentSize()
    }

    // MARK: Actions

    @objc private func onTitleButtonHighlighted() {
        guard animatesWhenPressed else {
            return
        }
        setupTitleColor(highlighted: true, animated: true)
        if interactivePart == .all {
            onSubtitleButtonHighlighted()
        }
    }

    @objc private func onTitleButtonUnhighlighted() {
        guard animatesWhenPressed else {
            return
        }
        setupTitleColor(highlighted: false, animated: true)
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
        setupSubtitleColor(highlighted: true, animated: true)
    }

    @objc private func onSubtitleButtonUnhighlighted() {
        guard animatesWhenPressed else {
            return
        }
        setupSubtitleColor(highlighted: false, animated: true)
    }

    // MARK: Accessibility

    open override var isAccessibilityElement: Bool { get { return false } set { } }

    open override func accessibilityElementCount() -> Int {
        return subtitleLabel.text != nil ? 2 : 1
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
