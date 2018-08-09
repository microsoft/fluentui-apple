//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

open class MSLabel: UILabel {
    public convenience init(style: MSTextStyle = .body, colorStyle: MSTextColorStyle = .regular) {
        self.init(frame: .zero)
        defer {
            self.style = style
            self.colorStyle = colorStyle
        }
    }

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
}
