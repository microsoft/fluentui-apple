//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
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
