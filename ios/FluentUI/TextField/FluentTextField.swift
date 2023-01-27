//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc(MSFTextField)
public class FluentTextField: UIView, UITextFieldDelegate {
    public var leadingImage: UIImage? {
        didSet {
            if let image = leadingImage {
                leadingImageView.image = image
                leadingImageView.isHidden = false
            } else {
                leadingImageView.isHidden = true
            }
        }
    }
    public var labelText: String? {
        didSet {
            if let text = labelText {
                label.text = text
                label.isHidden = false
            } else {
                label.isHidden = true
            }
        }
    }
    public var placeholder: String? {
        didSet {
            textfield.placeholder = placeholder
        }
    }
    public var assistiveText: String? {
        didSet {
            if let text = assistiveText {
                assistiveTextLabel.text = text
                assistiveTextLabel.isHidden = false
            } else {
                assistiveTextLabel.isHidden = true
            }
        }
    }

    public init() {
        super.init(frame: .zero)

        let textStack = UIStackView(arrangedSubviews: [label, textfield, separator, assistiveTextLabel])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 12
        textStack.setCustomSpacing(4, after: separator)
        textStack.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 4, right: 0)
        textStack.isLayoutMarginsRelativeArrangement = true

        let imageTextStack = UIStackView(arrangedSubviews: [leadingImageView, textStack])
        imageTextStack.axis = .horizontal
        imageTextStack.spacing = 16
        imageTextStack.distribution = .fill
        imageTextStack.translatesAutoresizingMaskIntoConstraints = false
        imageTextStack.alignment = .center
        imageTextStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
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
            imageTextStack.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
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

    let leadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.isHidden = true
        return imageView
    }()

    let label: UILabel = {
        let label = UILabel()
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

    let assistiveTextLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
//        tokenSet.update(fluentTheme)
        updateTokenizedValues()
    }

    // still no.... state? support.
    private func updateTokenizedValues() {
        leadingImageView.tintColor = UIColor(dynamicColor: fluentTheme.aliasTokens.brandColors[.primary])
        
        let font = UIFont.fluent(fluentTheme.aliasTokens.typography[.caption2])
        let labelColor = UIColor(dynamicColor: fluentTheme.aliasTokens.foregroundColors[.neutral4])
        label.font = font
        label.textColor = labelColor
        assistiveTextLabel.font = font
        assistiveTextLabel.textColor = labelColor

        separator.backgroundColor = UIColor(dynamicColor: fluentTheme.aliasTokens.strokeColors[.neutral1])

        textfield.font = UIFont.fluent(fluentTheme.aliasTokens.typography[.body1])
        textfield.tintColor = UIColor(dynamicColor: fluentTheme.aliasTokens.foregroundColors[.neutral3])
        textfield.textColor = UIColor(dynamicColor: fluentTheme.aliasTokens.foregroundColors[.neutral1])
        let buttonColor = fluentTheme.aliasTokens.foregroundColors[.neutral2]
        textfield.clearButton.tokenSet[.foregroundColor] = .dynamicColor { buttonColor }
    }
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
        return CGRect(x: origin.x, y: origin.y, width: size.width - (trailingViewSpacing + editingTextTrailingSpacing), height: size.height)
    }

    let trailingViewSpacing: CGFloat = 16.0
    let editingTextTrailingSpacing: CGFloat = 8.0
    let trailingViewSize: CGFloat = 24.0
    var clearButton: Button = {
        let button = Button(style: .borderless)
        // TODO: get the right image
        button.image = UIImage(named: "Dismiss_24")
        button.edgeInsets = .zero
        return button
    }()

    @objc private func clearText() {
        text = nil
    }
}
