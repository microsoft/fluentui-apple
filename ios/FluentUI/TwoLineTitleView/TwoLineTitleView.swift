//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

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

        var xAxisKeyPath: KeyPath<UIView, NSLayoutXAxisAnchor> {
            switch self {
            case .center:
                return \.centerXAnchor
            case .leading:
                return \.leadingAnchor
            }
        }
    }

    @objc(MSFTwoLineTitleViewInteractivePart)
    public enum InteractivePart: Int {
        // The @objc requirement doesn't let us use OptionSet, so we provide the bitmasks and the `contains` method ourselves
        case none = 0
        case title = 1 // 0b01
        case subtitle = 2 // 0b10
        case all = 3 // 0b11

        func contains(_ other: InteractivePart) -> Bool {
            return rawValue & other.rawValue != 0
        }
    }

    @objc(MSFTwoLineTitleViewAccessoryType)
    public enum AccessoryType: Int {
        case none
        case disclosure
        case downArrow
        case custom

        public func image(isTitle: Bool) -> UIImage? {
            switch self {
            case .disclosure:
                return UIImage.staticImageNamed(isTitle ? "chevron-right-16x16" : "chevron-right-12x12")
            case .downArrow:
                return UIImage.staticImageNamed(isTitle ? "chevron-down-16x16" : "chevron-down-12x12")
            case .none, .custom:
                return nil
            }
        }
    }

    private var customSubtitleTrailingImage: UIImage?

    @objc open var titleAccessibilityHint: String? {
        get { return titleLabel.accessibilityHint }
        set { titleLabel.accessibilityHint = newValue }
    }
    @objc open var titleAccessibilityTraits: UIAccessibilityTraits {
        get { return titleLabel.accessibilityTraits }
        set { titleLabel.accessibilityTraits = newValue }
    }

    @objc open var subtitleAccessibilityHint: String? {
        get { return subtitleLabel.accessibilityHint }
        set { subtitleLabel.accessibilityHint = newValue }
    }
    @objc open var subtitleAccessibilityTraits: UIAccessibilityTraits {
        get { return subtitleLabel.accessibilityTraits }
        set { subtitleLabel.accessibilityTraits = newValue }
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

    private lazy var alignmentConstraint: NSLayoutConstraint = centerXAnchor.constraint(equalTo: containingStackView.centerXAnchor)
    private var alignment: Alignment = .center {
        didSet {
            guard alignment != oldValue else {
                return
            }
            alignmentConstraint.isActive = false
            let keyPath = alignment.xAxisKeyPath
            alignmentConstraint = self[keyPath: keyPath].constraint(equalTo: containingStackView[keyPath: keyPath])
            alignmentConstraint.isActive = true
        }
    }
    private var interactivePart: InteractivePart = .none
    private var animatesWhenPressed: Bool = true
    private var accessoryType: AccessoryType = .none

    // View hierarchy:
    // containingStackView
    // |--titleContainer
    // |  |--titleLeadingImageView (user-defined, optional)
    // |  |--titleLabel
    // |  |--titleTrailingImageView (chevron, optional)
    // |--subtitleContainer
    // |  |--subtitleLabel
    // |  |--subtitleImageView (optional)

    private lazy var containingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()

    // Container used for the title and subtitle when the title image is leading for both.
    private lazy var titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0.0
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let titleContainer: UIStackView
    private let subtitleContainer: UIStackView

    private lazy var titleLabel: Label = {
        let label = Label(textStyle: TokenSetType.defaultTitleFont, colorForTheme: { _ in self.tokenSet[.titleColor].uiColor })
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()

    private var titleLeadingImageView = UIImageView()
    private var titleTrailingImageView = UIImageView()

    private lazy var subtitleLabel: Label = {
        let label = Label(textStyle: TokenSetType.defaultSubtitleFont, colorForTheme: { _ in self.tokenSet[.subtitleColor].uiColor })
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

        titleContainer = UIStackView()
        subtitleContainer = UIStackView()

        super.init(frame: frame)

        tokenSet.registerOnUpdate(for: self) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.applyStyle()
            strongSelf.updateFonts()
        }

        applyStyle()

        titleContainer.axis = .horizontal
        titleContainer.spacing = TokenSetType.titleStackSpacing
        subtitleContainer.axis = .horizontal
        subtitleContainer.spacing = TokenSetType.titleStackSpacing

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTitleTapped)))

        // We do all of this instead of a simple contain(view:) to account for the minimum touch size
        addSubview(containingStackView)
        containingStackView.translatesAutoresizingMaskIntoConstraints = false

        // We lower the priority of the height constraint to allow auto-layout to fit the
        // TwoLineTitleView vertically as needed when used in the NavigationBar.
        let heightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: TokenSetType.minimumTouchSize.height)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            // Ensure minimum touch size
            widthAnchor.constraint(greaterThanOrEqualToConstant: TokenSetType.minimumTouchSize.width),
            heightConstraint,
            // Contain and center containingStackView within ourself
            centerXAnchor.constraint(equalTo: containingStackView.centerXAnchor),
            centerYAnchor.constraint(equalTo: containingStackView.centerYAnchor),
            widthAnchor.constraint(greaterThanOrEqualTo: containingStackView.widthAnchor),
            heightAnchor.constraint(greaterThanOrEqualTo: containingStackView.heightAnchor)
        ])

        // Initial setup of subviews
        setupTitleColor(highlighted: false, animated: false)
        setupSubtitleColor(highlighted: false, animated: false)

        titleLeadingImageView.contentMode = .scaleAspectFit
        titleTrailingImageView.contentMode = .scaleAspectFit
        subtitleImageView.contentMode = .scaleAspectFit

        titleLabel.accessibilityTraits = [.staticText, .header]
        subtitleLabel.accessibilityTraits = [.staticText, .header]

        addInteraction(UILargeContentViewerInteraction())
        titleLabel.showsLargeContentViewer = true
        subtitleLabel.showsLargeContentViewer = true
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
    ///   - customSubtitleTrailingImage: An optional image to be used as the trailing image of the subtitle if `interactivePart` is `.custom`.
    ///   - isTitleImageLeadingForTitleAndSubtitle: Determines whether the provided `titleImage` is used on the leading end of both the title and subtitle. Both `titleImage` and `subtitle` must be provided when this value is set to `true`.
    @objc open func setup(title: String, subtitle: String? = nil, interactivePart: InteractivePart = .none, accessoryType: AccessoryType = .none, customSubtitleTrailingImage: UIImage? = nil, isTitleImageLeadingForTitleAndSubtitle: Bool = false) {
        setup(title: title, subtitle: subtitle, alignment: .center, interactivePart: interactivePart, animatesWhenPressed: true, accessoryType: accessoryType, customSubtitleTrailingImage: customSubtitleTrailingImage, isTitleImageLeadingForTitleAndSubtitle: isTitleImageLeadingForTitleAndSubtitle)
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
    ///   - customSubtitleTrailingImage: An optional image to be used as the trailing image of the subtitle if `interactivePart` is `.custom`.
    ///   - isTitleImageLeadingForTitleAndSubtitle: Determines whether the provided `titleImage` is used on the leading end of both the title and subtitle. Both `titleImage` and `subtitle` must be provided when this value is set to `true`.
    @objc open func setup(title: String, titleImage: UIImage? = nil, subtitle: String? = nil, alignment: Alignment = .center, interactivePart: InteractivePart = .none, animatesWhenPressed: Bool = true, accessoryType: AccessoryType = .none, customSubtitleTrailingImage: UIImage? = nil, isTitleImageLeadingForTitleAndSubtitle: Bool = false) {
        self.alignment = alignment
        self.interactivePart = interactivePart
        self.animatesWhenPressed = animatesWhenPressed
        self.accessoryType = accessoryType
        self.customSubtitleTrailingImage = customSubtitleTrailingImage

        titleLeadingImageView.image = titleImage
        titleLeadingImageView.isHidden = titleImage == nil

        setupTitleLine(titleContainer, label: titleLabel, trailingImageView: titleTrailingImageView, text: title, interactive: interactivePart.contains(.title), accessoryType: accessoryType)

        if !isTitleImageLeadingForTitleAndSubtitle && titleLeadingImageView.image != nil {
            titleContainer.insertArrangedSubview(titleLeadingImageView, at: 0)
        }

        // Check for strict equality for the subtitle button's interactivity.
        // If the whole area is active, we'll use the title as the main accessibility item.
        setupTitleLine(subtitleContainer, label: subtitleLabel, trailingImageView: subtitleImageView, text: subtitle, interactive: interactivePart.contains(.subtitle), accessoryType: accessoryType)

        minimumContentSizeCategory = .large
        setupContainingStackView(isTitleImageLeadingForTitleAndSubtitle: isTitleImageLeadingForTitleAndSubtitle,
                                 alignment: alignment.stackViewAlignment)

        if isTitleImageLeadingForTitleAndSubtitle {
            guard subtitle?.isEmpty == false, titleImage != nil else {
                preconditionFailure("A title image and a subtitle must be provided when `isTitleImageLeadingForTitleAndSubtitle` is set to true.")
            }
            maximumContentSizeCategory = .large

            titlesStackView.addArrangedSubview(titleContainer)
            titlesStackView.addArrangedSubview(subtitleContainer)

            containingStackView.addArrangedSubview(titleLeadingImageView)
            containingStackView.addArrangedSubview(titlesStackView)
        } else {
            containingStackView.addArrangedSubview(titleContainer)

            if subtitle?.isEmpty == false {
                maximumContentSizeCategory = .large
                containingStackView.addArrangedSubview(subtitleContainer)
            } else {
                maximumContentSizeCategory = .extraExtraLarge
            }
        }
    }

    private func setupContainingStackView(isTitleImageLeadingForTitleAndSubtitle: Bool, alignment: UIStackView.Alignment) {
        containingStackView.removeAllSubviews()
        containingStackView.alignment = isTitleImageLeadingForTitleAndSubtitle ? .center : alignment
        containingStackView.axis = isTitleImageLeadingForTitleAndSubtitle ? .horizontal : .vertical
        containingStackView.spacing = isTitleImageLeadingForTitleAndSubtitle ? TwoLineTitleViewTokenSet.leadingImageAndTitleSpacing : 0.0
    }

    // MARK: Highlighting

    private func applyStyle() {
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

    private func setupTitleLine(_ container: UIStackView, label: UILabel, trailingImageView: UIImageView, text: String?, interactive: Bool, accessoryType: AccessoryType) {
        container.accessibilityLabel = text
        label.text = text

        container.removeAllSubviews()
        container.addArrangedSubview(label)

        if interactive {
            let isTitle = container == titleContainer
            container.accessibilityTraits.insert(.button)
            container.accessibilityTraits.remove(.staticText)
            trailingImageView.image = (!isTitle && accessoryType == .custom) ? customSubtitleTrailingImage : accessoryType.image(isTitle: isTitle)
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

    // MARK: Actions

    @objc private func onTitleTapped() {
        delegate?.twoLineTitleViewDidTapOnTitle(self)
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard animatesWhenPressed, touches.contains(where: { bounds.contains($0.location(in: self)) }) else {
            return
        }
        setTitleHighlight(true)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard animatesWhenPressed else {
            return
        }
        setTitleHighlight(false)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard animatesWhenPressed else {
            return
        }
        setTitleHighlight(touches.allSatisfy { bounds.contains($0.location(in: self)) })
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard animatesWhenPressed else {
            return
        }
        setTitleHighlight(false)
    }

    private func setTitleHighlight(_ value: Bool) {
        assert(animatesWhenPressed, "setTitleHighlight(_) should only be called when animatesWhenPressed is true")
        setupTitleColor(highlighted: value && interactivePart.contains(.title), animated: true)
        setupSubtitleColor(highlighted: value && interactivePart.contains(.subtitle), animated: true)
    }

    // MARK: Accessibility

    open override var isAccessibilityElement: Bool { get { return false } set { } }

    open override func accessibilityElementCount() -> Int {
        return subtitleLabel.text != nil ? 2 : 1
    }

    open override func accessibilityElement(at index: Int) -> Any? {
        if index == 0 {
            return titleLabel
        } else if index == 1 {
            return subtitleLabel
        }
        return nil
    }

    open override func index(ofAccessibilityElement element: Any) -> Int {
        if let view = element as? UIView {
            return view == titleLabel ? 0 : 1
        }
        return -1
    }
}
