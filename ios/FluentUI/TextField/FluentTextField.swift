//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import Combine

@objc(MSFTextField)
public final class FluentTextField: UIView, UITextFieldDelegate, TokenizedControlInternal {
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        tokenSet.update(fluentTheme)
        updateTokenizedValues()
    }

    public typealias TokenSetKeyType = TextFieldTokenSet.Tokens
    lazy public var tokenSet: TextFieldTokenSet = .init(state: { [weak self] in
        return self?.state ?? .unfocused
    })

    @objc public var leadingImage: UIImage? {
        didSet {
            if let image = leadingImage {
                leadingImageView.image = image
                leadingImageContainerView.isHidden = false
            } else {
                leadingImageContainerView.isHidden = true
            }
        }
    }
    @objc public var labelText: String? {
        didSet {
            if let text = labelText {
                label.text = text
                label.isHidden = false
            } else {
                label.isHidden = true
            }
        }
    }
    @objc public var text: String? {
        get {
            return textfield.text
        }
        set {
            textfield.text = newValue
        }
    }
    @objc public var placeholder: String? {
        didSet {
            textfield.attributedPlaceholder = attributedPlaceholder
        }
    }
    @objc public var assistiveText: String? {
        didSet {
            updateAssistiveText()
        }
    }

    @objc public var onEditingChanged: ((FluentTextField) -> Void)?
    @objc public var onDidBeginEditing: ((FluentTextField) -> Void)?
    @objc public var onDidEndEditing: ((FluentTextField) -> Void)?
    @objc public var onReturn: ((FluentTextField) -> Bool)?
    @objc public var error: FluentTextInputError? {
        didSet {
            updateState()
            updateAssistiveText()
        }
    }

    @objc public init() {
        super.init(frame: .zero)
        textfield.validateInputText = editingChanged
        textfield.delegate = self
        textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

        let textStack = UIStackView(arrangedSubviews: [label, textfield, separator, assistiveTextLabel])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = TextFieldTokenSet.labelInputTextSpacing()
        textStack.setCustomSpacing(4, after: separator)
        textStack.layoutMargins = UIEdgeInsets(top: TextFieldTokenSet.topPadding(),
                                               left: 0,
                                               bottom: TextFieldTokenSet.bottomPadding(),
                                               right: 0)
        textStack.isLayoutMarginsRelativeArrangement = true

        leadingImageContainerView.addSubview(leadingImageView)

        let imageTextStack = UIStackView(arrangedSubviews: [leadingImageContainerView, textStack])
        imageTextStack.axis = .horizontal
        imageTextStack.spacing = TextFieldTokenSet.leadingIconInputTextSpacing()
        imageTextStack.distribution = .fill
        imageTextStack.translatesAutoresizingMaskIntoConstraints = false
        imageTextStack.alignment = .center

        let leftInset: CGFloat
        let rightInset: CGFloat
        if effectiveUserInterfaceLayoutDirection == .leftToRight {
            leftInset = TextFieldTokenSet.horizontalPadding()
            rightInset = 0
        } else {
            leftInset = 0
            rightInset = TextFieldTokenSet.horizontalPadding()
        }
        imageTextStack.layoutMargins = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        imageTextStack.isLayoutMarginsRelativeArrangement = true

        addSubview(imageTextStack)

        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalTo: textStack.widthAnchor),
            textfield.leadingAnchor.constraint(equalTo: textStack.leadingAnchor),
            textfield.trailingAnchor.constraint(equalTo: textStack.trailingAnchor),
            imageTextStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageTextStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            imageTextStack.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageTextStack.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            leadingImageContainerView.leadingAnchor.constraint(equalTo: leadingImageView.leadingAnchor),
            leadingImageContainerView.trailingAnchor.constraint(equalTo: leadingImageView.trailingAnchor),
            leadingImageView.centerYAnchor.constraint(equalTo: textfield.centerYAnchor)
        ])

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
        updateTokenizedValues()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITextFieldDelegate
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let onDidBeginEditing = onDidBeginEditing {
            onDidBeginEditing(self)
        }
        updateState()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let onDidEndEditing = onDidEndEditing {
            onDidEndEditing(self)
        }
        updateState()
        if text?.isEmpty == true {
            textfield.rightViewMode = .whileEditing
        } else {
            textfield.rightViewMode = .always
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // add check for error == nil?
        if let onReturn = onReturn {
            return onReturn(self)
        }
        // what is a good default?
        return true
    }

    var attributedPlaceholder: NSAttributedString? {
        guard let placeholder = placeholder else {
            return nil
        }
        return NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(dynamicColor: tokenSet[.placeholderColor].dynamicColor)])
    }

    // The leadingImageView needs a contianer to be vertically centered on the
    // textfield
    let leadingImageContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    let leadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let label: Label = {
        let label = Label()
        label.isHidden = true
        return label
    }()

    let textfield: FluentTextFieldInternal = {
        let field = FluentTextFieldInternal()
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return field
    }()

    let separator: Separator = {
        let separator = Separator(style: .default, orientation: .horizontal)
        return separator
    }()

    let assistiveTextLabel: Label = {
        let label = Label()
        label.isHidden = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(fluentTheme)
        updateTokenizedValues()
    }

    @objc private func editingChanged() {
        guard let onEditingChanged = onEditingChanged else {
            return
        }
        onEditingChanged(self)
    }

    private func updateTokenizedValues() {
        leadingImageView.tintColor = UIColor(dynamicColor: tokenSet[.leadingIconColor].dynamicColor)

        label.font = UIFont.fluent(tokenSet[.labelFont].fontInfo)
        label.textColor = UIColor(dynamicColor: tokenSet[.labelColor].dynamicColor)
        assistiveTextLabel.font = UIFont.fluent(tokenSet[.assistiveTextFont].fontInfo)
        assistiveTextLabel.textColor = UIColor(dynamicColor: tokenSet[.assistiveTextColor].dynamicColor)

        separator.backgroundColor = UIColor(dynamicColor: tokenSet[.strokeColor].dynamicColor)

        textfield.font = UIFont.fluent(tokenSet[.inputTextFont].fontInfo)
        textfield.tintColor = UIColor(dynamicColor: tokenSet[.cursorColor].dynamicColor)
        textfield.textColor = UIColor(dynamicColor: tokenSet[.inputTextColor].dynamicColor)
        let buttonColor = tokenSet[.trailingIconColor]
        textfield.clearButton.tokenSet[.foregroundColor] = buttonColor
    }

    private func updateState() {
        if error != nil {
            state = .error
        } else {
            state = textfield.isFirstResponder ? .focused : .unfocused
        }
    }

    private func updateAssistiveText() {
        if let error = error {
            assistiveTextLabel.text = error.localizedDescription
            assistiveTextLabel.isHidden = false
        } else if let assistiveText = assistiveText {
            assistiveTextLabel.text = assistiveText
            assistiveTextLabel.isHidden = false
        } else {
            assistiveTextLabel.text = nil
            assistiveTextLabel.isHidden = true
        }
    }

    private var state: FluentTextFieldState = .unfocused {
        didSet {
            updateTokenizedValues()
        }
    }
    private var tokenSetSink: AnyCancellable?
}

class FluentTextFieldInternal: UITextField {
    init() {
        super.init(frame: .zero)

        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        rightView = clearButton

        rightViewMode = .whileEditing
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let origin = super.rightViewRect(forBounds: bounds).origin
        return CGRect(x: origin.x - trailingViewSpacing, y: origin.y, width: trailingViewSize, height: trailingViewSize)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        let origin = rect.origin
        let size = rect.size
        return CGRect(x: origin.x, y: origin.y, width: size.width - (trailingViewSpacing + inputTextTrailingIconSpacing), height: size.height)
    }

    let trailingViewSpacing: CGFloat = TextFieldTokenSet.horizontalPadding()
    let inputTextTrailingIconSpacing: CGFloat = TextFieldTokenSet.inputTextTrailingIconSpacing()
    let trailingViewSize: CGFloat = TextFieldTokenSet.iconSize()
    var clearButton: Button = {
        let button = Button(style: .borderless)
        button.image = UIImage.staticImageNamed("ic_fluent_dismiss_circle_24_regular")
        button.edgeInsets = .zero
        return button
    }()

    override var text: String? {
        didSet {
            guard let validateInputText = validateInputText else {
                return
            }
            validateInputText()
        }
    }

    @objc private func clearText() {
        text = nil
        rightViewMode = .whileEditing
    }
    
    var validateInputText: (() -> Void)?
}

// TODO: Better, less confusing name. Since this is nothing like the other state objects
public enum FluentTextFieldState: Int, CaseIterable {
    case unfocused
    case focused
    case error
}

public class TextFieldTokenSet: ControlTokenSet<TextFieldTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        case assistiveTextColor
        case assistiveTextFont
        case backgroundColor
        case cursorColor
        case inputTextColor
        case inputTextFont
        case labelColor
        case labelFont
        case leadingIconColor
        case placeholderColor
        case strokeColor
        case trailingIconColor
    }

    init(state: @escaping () -> FluentTextFieldState) {
        self.state = state
        super.init { [state] token, theme in
            switch token {
            case .assistiveTextColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused, .focused:
                        // Foreground 2
                        return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                            dark: GlobalTokens.neutralColors(.grey84))
                    case .error:
                        // Danger foreground 1
                        return DynamicColor(light: GlobalTokens.sharedColors(.red, .shade10),
                                            dark: GlobalTokens.sharedColors(.red, .tint30))
                    }
                }
            case .assistiveTextFont:
                return .fontInfo { theme.aliasTokens.typography[.caption2] }
            case .backgroundColor:
                return .dynamicColor {
                    // Background 1
                    DynamicColor(light: GlobalTokens.neutralColors(.white),
                                 dark: GlobalTokens.neutralColors(.black),
                                 darkElevated: GlobalTokens.neutralColors(.grey4))
                }
            case .cursorColor:
                return .dynamicColor {
                    // Foreground 3
                    DynamicColor(light: GlobalTokens.neutralColors(.grey50),
                                 dark: GlobalTokens.neutralColors(.grey68))
                }
            case .inputTextColor:
                return .dynamicColor {
                    // Foreground 1
                    DynamicColor(light: GlobalTokens.neutralColors(.grey14),
                                 dark: GlobalTokens.neutralColors(.white))
                }
            case .inputTextFont:
                return .fontInfo { theme.aliasTokens.typography[.body1] }
            case .labelColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused:
                        // Foreground 2
                        return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                            dark: GlobalTokens.neutralColors(.grey84))
                    case .focused:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    case .error:
                        // Danger foreground 1
                        return DynamicColor(light: GlobalTokens.sharedColors(.red, .shade10),
                                            dark: GlobalTokens.sharedColors(.red, .tint30))
                    }
                }
            case .labelFont:
                return .fontInfo { theme.aliasTokens.typography[.caption2] }
            case .leadingIconColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused, .error:
                        // Foreground 2
                        return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                            dark: GlobalTokens.neutralColors(.grey84))
                    case .focused:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    }
                }
            case .placeholderColor:
                return .dynamicColor {
                    // Foreground 2
                    return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                        dark: GlobalTokens.neutralColors(.grey84))
                }
            case .strokeColor:
                return .dynamicColor {
                    switch state() {
                    case .unfocused:
                        // Stroke 1
                        return DynamicColor(light: GlobalTokens.neutralColors(.grey82),
                                            dark: GlobalTokens.neutralColors(.grey30),
                                            darkElevated: GlobalTokens.neutralColors(.grey36))
                    case .focused:
                        return theme.aliasTokens.foregroundColors[.brandRest]
                    case .error:
                        // Danger foreground 1
                        return DynamicColor(light: GlobalTokens.sharedColors(.red, .shade10),
                                            dark: GlobalTokens.sharedColors(.red, .tint30))
                    }
                }
            case .trailingIconColor:
                return .dynamicColor {
                    // Foreground 2
                    return DynamicColor(light: GlobalTokens.neutralColors(.grey38),
                                        dark: GlobalTokens.neutralColors(.grey84))}
            }
        }
    }

    var state: () -> FluentTextFieldState
}

extension TextFieldTokenSet {
    static func iconSize() -> CGFloat {
        return GlobalTokens.iconSize(.medium)
    }

    static func horizontalPadding() -> CGFloat {
        return GlobalTokens.spacing(.medium)
    }

    static func topPadding() -> CGFloat {
        return GlobalTokens.spacing(.small)
    }

    static func bottomPadding() -> CGFloat {
        return GlobalTokens.spacing(.xxSmall)
    }

    static func labelInputTextSpacing() -> CGFloat {
        return GlobalTokens.spacing(.small)
    }

    static func leadingIconInputTextSpacing() -> CGFloat {
        return GlobalTokens.spacing(.medium)
    }

    static func inputTextTrailingIconSpacing() -> CGFloat {
        return GlobalTokens.spacing(.xSmall)
    }

    static func inputTextStrokeSpacing() -> CGFloat {
        return GlobalTokens.spacing(.small)
    }

    static func strokeAssistiveTextSpacing() -> CGFloat {
        return GlobalTokens.spacing(.xxSmall)
    }
}

@objc(MSFTextInputError)
open class FluentTextInputError: NSObject {
    @objc public init(localizedDescription: String) {
        self.localizedDescription = localizedDescription
        super.init()
    }

    @objc public var localizedDescription: String
}
