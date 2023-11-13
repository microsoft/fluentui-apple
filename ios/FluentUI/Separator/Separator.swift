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
open class Separator: UIView, TokenizedControlInternal {
    public typealias TokenSetKeyType = SeparatorTokenSet.Tokens
    lazy public var tokenSet: SeparatorTokenSet = .init()

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
    @objc public static var thickness: CGFloat { return SeparatorTokenSet.thickness }

    @objc public static func separatorDefaultColor(fluentTheme: FluentTheme) -> UIColor {
        return fluentTheme.color(.stroke2)
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
    }

    private func initialize(orientation: SeparatorOrientation) {
        backgroundColor = tokenSet[.color].uiColor
        self.orientation = orientation
        switch orientation {
        case .horizontal:
            frame.size.height = SeparatorTokenSet.thickness
            autoresizingMask = .flexibleWidth
        case .vertical:
            frame.size.width = SeparatorTokenSet.thickness
            autoresizingMask = .flexibleHeight
        }
        isAccessibilityElement = false
        isUserInteractionEnabled = false

        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.backgroundColor = self?.tokenSet[.color].uiColor
        }
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
