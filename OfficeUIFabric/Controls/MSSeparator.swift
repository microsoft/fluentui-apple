//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

@objc public enum MSSeparatorStyle: Int {
    case `default`
    case shadow

    fileprivate var color: UIColor {
        switch self {
        case .default:
            return MSColors.separator
        case .shadow:
            // Matches shadow used in UINavigationBar
            return UIColor.black.withAlphaComponent(0.3)
        }
    }
}

open class MSSeparator: UIView {
    public init(style: MSSeparatorStyle = .default) {
        super.init(frame: .zero)
        initialize(style: style)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize(style: MSSeparatorStyle) {
        backgroundColor = style.color
        height = UIScreen.main.devicePixel
        autoresizingMask = .flexibleWidth
        isAccessibilityElement = false
        isUserInteractionEnabled = false
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: height)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: height)
    }
}
