//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

open class MSLabel: UILabel {
    @objc open var colorStyle: MSTextColorStyle = .regular {
        didSet {
            update()
        }
    }
    @objc open var style: MSTextStyle = .body {
        didSet {
            update()
        }
    }

    @objc public init(style: MSTextStyle = .body, colorStyle: MSTextColorStyle = .regular) {
        self.style = style
        self.colorStyle = colorStyle
        super.init(frame: .zero)
        initialize()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        update()
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    private func update() {
        font = style.font
        textColor = colorStyle.color
    }

    @objc private func handleContentSizeCategoryDidChange() {
        update()
    }
}
