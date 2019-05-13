//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
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

@objc public enum MSSeparatorOrientation: Int {
    case horizontal
    case vertical
}

open class MSSeparator: UIView {
    open override var backgroundColor: UIColor? { get { return super.backgroundColor } set { } }

    private var orientation: MSSeparatorOrientation = .horizontal

    public init(style: MSSeparatorStyle = .default, orientation: MSSeparatorOrientation = .horizontal) {
        super.init(frame: .zero)
        initialize(style: style, orientation: orientation)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize(style: MSSeparatorStyle, orientation: MSSeparatorOrientation) {
        super.backgroundColor = style.color
        self.orientation = orientation
        switch orientation {
        case .horizontal:
            height = UIScreen.main.devicePixel
            autoresizingMask = .flexibleWidth
        case .vertical:
            width = UIScreen.main.devicePixel
            autoresizingMask = .flexibleHeight
        }
        isAccessibilityElement = false
        isUserInteractionEnabled = false
    }

    open override var intrinsicContentSize: CGSize {
        switch orientation {
        case .horizontal:
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        case .vertical:
            return CGSize(width: width, height: UIView.noIntrinsicMetric)
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        switch orientation {
        case .horizontal:
            return CGSize(width: size.width, height: height)
        case .vertical:
            return CGSize(width: width, height: size.height)
        }
    }
}
