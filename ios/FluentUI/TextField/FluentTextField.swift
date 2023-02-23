//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import UIKit

@objc(MSFTextField)
public final class FluentTextField: UIView, UITextFieldDelegate, TokenizedControlInternal {
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateTokenizedValues()
    }

    public typealias TokenSetKeyType = TextFieldTokenSet.Tokens
    lazy public var tokenSet: TextFieldTokenSet = .init(state: { [weak self] in
        return self?.state ?? .unfocused
    })

    /// UIImage used in the leading UIImageView. If this is nil, the leading UIImageView will be hidden.
    @objc public var leadingImage: UIImage? {
        didSet {
            if let leadingImage {
                leadingImageView.image = leadingImage
                leadingImageContainerView.isHidden = false
            } else {
                leadingImageContainerView.isHidden = true
            }
        }
    }

    /// String used in the title label. If this is nil, the title label will be hidden.
    @objc public var titleText: String? {
        didSet {
            if let titleText {
                titleLabel.text = titleText
                titleLabel.isHidden = false
            } else {
                titleLabel.isHidden = true
            }
        }
    }

    /// String representing the input text.
    @objc public var inputText: String? {
        get {
            return textfield.text
        }
        set {
            textfield.text = newValue
        }
    }

    /// String representing the placeholder text.
    @objc public var placeholder: String? {
        didSet {
            textfield.attributedPlaceholder = attributedPlaceholder
        }
    }

    /// String used in the assistive text label. If this is nil, the assistive text label will be hidden. If the `error`
    /// property of the `FluentTextField` is set, the `localizedDescription` from `error`
    /// will be displayed instead.
    @objc public var assistiveText: String? {
        didSet {
            updateAssistiveText()
        }
    }

    /// The closure for the action to be called in response to the textfield's `.editingChanged` event.
    @objc public var onEditingChanged: ((FluentTextField) -> Void)?

    /// The closure for the action to be called in `textFieldDidBeginEditing`.
    @objc public var onDidBeginEditing: ((FluentTextField) -> Void)?

    /// The closure for the action to be called in `textFieldDidEndEditing`.
    @objc public var onDidEndEditing: ((FluentTextField) -> Void)?

    /// The closure for the action to be called in `textFieldShouldReturn`. The return value of `onReturn`
    /// will be returned in `textFieldShouldReturn`.
    @objc public var onReturn: ((FluentTextField) -> Bool)?

    /// The `FluentTextInputError` containing the `localizedDescription` that will be
    /// displayed in the assistive text label.
    @objc public var error: FluentTextInputError? {
        didSet {
            updateState()
            updateAssistiveText()
        }
    }

    // Hierarchy:
    //
    // imageTextStack
    // |--leadingImageContainerView
    // |--|--leadingImageView
    // |--textStack
    // |--|--titleLabel
    // |--|--textfield
    // |--|--separator
    // |--|--assistiveTextLabel
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        textfield.validateInputText = editingChanged
        textfield.delegate = self
        textfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, textfield, separator, assistiveTextLabel])
        textStack.axis = .vertical
        textStack.spacing = TextFieldTokenSet.titleInputTextSpacing
        textStack.setCustomSpacing(TextFieldTokenSet.strokeAssistiveTextSpacing, after: separator)
        textStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: TextFieldTokenSet.topPadding,
                                                                     leading: 0,
                                                                     bottom: TextFieldTokenSet.bottomPadding,
                                                                     trailing: 0)
        textStack.isLayoutMarginsRelativeArrangement = true

        leadingImageContainerView.addSubview(leadingImageView)

        let imageTextStack = UIStackView(arrangedSubviews: [leadingImageContainerView, textStack])
        imageTextStack.spacing = TextFieldTokenSet.leadingIconInputTextSpacing
        imageTextStack.translatesAutoresizingMaskIntoConstraints = false
        imageTextStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0,
                                                                          leading: TextFieldTokenSet.horizontalPadding,
                                                                          bottom: 0,
                                                                          trailing: 0)
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

        tokenSetSink = tokenSet.sinkChanges { [weak self] in
            self?.updateTokenizedValues()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITextFieldDelegate
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let onDidBeginEditing {
            onDidBeginEditing(self)
        }
        updateState()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let onDidEndEditing {
            onDidEndEditing(self)
        }
        updateState()
        if inputText?.isEmpty == true {
            textfield.rightViewMode = .whileEditing
        } else {
            textfield.rightViewMode = .always
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let onReturn {
            return onReturn(self)
        }
        return true
    }

    var attributedPlaceholder: NSAttributedString? {
        guard let placeholder else {
            return nil
        }
        return NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(dynamicColor: tokenSet[.placeholderColor].dynamicColor)])
    }

    // The leadingImageView needs a container to be vertically centered on the
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

    let titleLabel: Label = {
        let label = Label()
        label.isHidden = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    let textfield: FluentTextFieldInternal = {
        let field = FluentTextFieldInternal()
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return field
    }()

    let separator: Separator = {
        let separator = Separator()
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
        guard let onEditingChanged else {
            return
        }
        onEditingChanged(self)
    }

    private func updateTokenizedValues() {
        backgroundColor = UIColor(dynamicColor: tokenSet[.backgroundColor].dynamicColor)

        leadingImageView.tintColor = UIColor(dynamicColor: tokenSet[.leadingIconColor].dynamicColor)

        titleLabel.font = UIFont.fluent(tokenSet[.titleLabelFont].fontInfo)
        titleLabel.textColor = UIColor(dynamicColor: tokenSet[.titleLabelColor].dynamicColor)
        assistiveTextLabel.font = UIFont.fluent(tokenSet[.assistiveTextFont].fontInfo)
        assistiveTextLabel.textColor = UIColor(dynamicColor: tokenSet[.assistiveTextColor].dynamicColor)

        separator.backgroundColor = UIColor(dynamicColor: tokenSet[.strokeColor].dynamicColor)

        textfield.font = UIFont.fluent(tokenSet[.inputTextFont].fontInfo)
        textfield.tintColor = UIColor(dynamicColor: tokenSet[.cursorColor].dynamicColor)
        textfield.textColor = UIColor(dynamicColor: tokenSet[.inputTextColor].dynamicColor)
        textfield.attributedPlaceholder = attributedPlaceholder
        textfield.clearButton.tokenSet[.foregroundColor] = tokenSet[.trailingIconColor]
    }

    private func updateState() {
        if error != nil {
            state = .error
        } else {
            state = textfield.isFirstResponder ? .focused : .unfocused
        }
    }

    private func updateAssistiveText() {
        if let error {
            assistiveTextLabel.text = error.localizedDescription
            assistiveTextLabel.isHidden = false
        } else if let assistiveText {
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
