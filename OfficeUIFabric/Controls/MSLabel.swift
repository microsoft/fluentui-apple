//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

open class MSLabel: UILabel {
    open var colorStyle: MSTextColorStyle = .regular {
        didSet {
            textColor = colorStyle.color
        }
    }
    open var style: MSTextStyle = .body {
        didSet {
            font = style.font
        }
    }

    public convenience init(style: MSTextStyle = .body, colorStyle: MSTextColorStyle = .regular) {
        self.init(frame: .zero)
        defer {
            self.style = style
            self.colorStyle = colorStyle
        }
    }
}
