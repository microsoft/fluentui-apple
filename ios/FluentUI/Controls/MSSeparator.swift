//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

@objc public enum MSSeparatorStyle: Int {
    case `default`
    case shadow

    fileprivate var color: UIColor {
        switch self {
        case .default:
            return MSColors.Separator.default
        case .shadow:
            return MSColors.Separator.shadow
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
        preconditionFailure("init(coder:) has not been implemented")
    }

    private func initialize(style: MSSeparatorStyle, orientation: MSSeparatorOrientation) {
        super.backgroundColor = style.color
        self.orientation = orientation
        switch orientation {
        case .horizontal:
            frame.size.height = UIScreen.main.devicePixel
            autoresizingMask = .flexibleWidth
        case .vertical:
            frame.size.width = UIScreen.main.devicePixel
            autoresizingMask = .flexibleHeight
        }
        isAccessibilityElement = false
        isUserInteractionEnabled = false
    }

    open override var intrinsicContentSize: CGSize {
        switch orientation {
        case .horizontal:
            return CGSize(width: UIView.noIntrinsicMetric, height: frame.height)
        case .vertical:
            return CGSize(width: frame.width, height: UIView.noIntrinsicMetric)
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        switch orientation {
        case .horizontal:
            return CGSize(width: size.width, height: frame.height)
        case .vertical:
            return CGSize(width: frame.width, height: size.height)
        }
    }
}
