//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Internal subclass of UITextField that allows us to adjust the position of the `rightView`.
class FluentTextFieldInternal: UITextField {
    init() {
        super.init(frame: .zero)

        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        rightView = clearButton
        rightViewMode = .whileEditing

        adjustsFontForContentSizeCategory = true
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

    let trailingViewSpacing: CGFloat = TextFieldTokenSet.horizontalPadding
    let inputTextTrailingIconSpacing: CGFloat = TextFieldTokenSet.inputTextTrailingIconSpacing
    let trailingViewSize: CGFloat = TextFieldTokenSet.iconSize
    var clearButton: Button = {
        let button = Button(style: .subtle)
        button.image = UIImage.staticImageNamed("ic_fluent_dismiss_circle_24_regular")
        button.accessibilityLabel = "Accessibility.TextField.ClearText".localized
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
