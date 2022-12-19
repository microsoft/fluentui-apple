<<<<<<< HEAD
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - SeparatorOrientation

@objc(MSFSeparatorOrientation)
public enum SeparatorOrientation: Int {
    case horizontal
    case vertical
}

// MARK: - Separator

@objc(MSFSeparator)
open class Separator: UIView {
    private var orientation: SeparatorOrientation = .horizontal

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize(orientation: .horizontal)
    }

    @objc public init(orientation: SeparatorOrientation = .horizontal) {
        super.init(frame: .zero)
        initialize(orientation: orientation)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /**
     The default thickness for the separator: half pt.
    */
    @objc public static var thickness: CGFloat { return GlobalTokens.stroke(.width05) }

    @objc public static func separatorDefaultColor(fluentTheme: FluentTheme) -> UIColor {
        return UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.stroke2])
    }

    private func initialize(orientation: SeparatorOrientation) {
        super.backgroundColor = Separator.separatorDefaultColor(fluentTheme: fluentTheme)
        self.orientation = orientation
        switch orientation {
        case .horizontal:
            frame.size.height = Separator.thickness
            autoresizingMask = .flexibleWidth
        case .vertical:
            frame.size.width = Separator.thickness
            autoresizingMask = .flexibleHeight
        }
        isAccessibilityElement = false
        isUserInteractionEnabled = false

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        super.backgroundColor = Separator.separatorDefaultColor(fluentTheme: fluentTheme)
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
||||||| 319d20b0
=======
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: Separator Colors

public extension Colors {
    struct Separator {
        public static var `default`: UIColor = dividerOnPrimary
        public static var shadow: UIColor = dividerOnSecondary
    }
    // Objective-C support
    @objc static var separatorDefault: UIColor { return Separator.default }
}

// MARK: - SeparatorStyle

@objc(MSFSeparatorStyle)
public enum SeparatorStyle: Int {
    case `default`
    case shadow

    fileprivate var color: UIColor {
        switch self {
        case .default:
            return Colors.Separator.default
        case .shadow:
            return Colors.Separator.shadow
        }
    }
}

// MARK: - SeparatorOrientation

@objc(MSFSeparatorOrientation)
public enum SeparatorOrientation: Int {
    case horizontal
    case vertical
}

// MARK: - Separator

@objc(MSFSeparator)
open class Separator: UIView {
    private var orientation: SeparatorOrientation = .horizontal

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize(style: .default, orientation: .horizontal)
    }

    @objc public init(style: SeparatorStyle = .default, orientation: SeparatorOrientation = .horizontal) {
        super.init(frame: .zero)
        initialize(style: style, orientation: orientation)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    /**
     The default thickness for the separator: half pt.
    */
    @objc public static var thickness: CGFloat { return 0.5 }

    private func initialize(style: SeparatorStyle, orientation: SeparatorOrientation) {
        super.backgroundColor = style.color
        self.orientation = orientation
        switch orientation {
        case .horizontal:
            frame.size.height = Separator.thickness
            autoresizingMask = .flexibleWidth
        case .vertical:
            frame.size.width = Separator.thickness
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
>>>>>>> main
