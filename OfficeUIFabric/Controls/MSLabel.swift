//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

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
    /**
     The maximum allowed size point for the receiver's font. This property can be used
     to restrict the largest size of the label when scaling due to Dynamic Type. The
     default value is 0, indicating there is no maximum size.
     */
    @objc open var maxFontSize: CGFloat = 0 {
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
        textColor = colorStyle.color

        let defaultFont = style.font
        if maxFontSize > 0 && defaultFont.pointSize > maxFontSize {
            font = defaultFont.withSize(maxFontSize)
        } else {
            font = defaultFont
        }
    }

    @objc private func handleContentSizeCategoryDidChange() {
        update()
    }
}
