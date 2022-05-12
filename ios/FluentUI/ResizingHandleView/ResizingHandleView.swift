//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - ResizingHandleView

@objc(MSFResizingHandleView)
open class ResizingHandleView: UIView, TokenizedControlInternal {
    private struct Constants {
        static let markSize = CGSize(width: 36, height: 4)
        static let markCornerRadius: CGFloat = 2
    }

    @objc public static let height: CGFloat = 20

    private lazy var markLayer: CALayer = {
        let markLayer = CALayer()
        markLayer.bounds.size = Constants.markSize
        markLayer.cornerRadius = Constants.markCornerRadius
        markLayer.backgroundColor = UIColor(dynamicColor: tokens.markColor).cgColor
        return markLayer
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(dynamicColor: tokens.backgroundColor)
        self.frame.size.height = ResizingHandleView.height
        autoresizingMask = .flexibleWidth
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
        isUserInteractionEnabled = false
        layer.addSublayer(markLayer)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: ResizingHandleView.height)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: ResizingHandleView.height)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        markLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    public func overrideTokens(_ tokens: ResizingHandleTokens?) -> Self {
        overrideTokens = tokens
        return self
    }

    /// Internal custom color to preserve deprecated Drawer API (resizingHandleViewBackgroundColor)
    var customBackgroundColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    var defaultTokens: ResizingHandleTokens = .init()
    var tokens: ResizingHandleTokens = .init()
    var overrideTokens: ResizingHandleTokens? {
        didSet {
            updateResizingHandleTokens()
            updateColors()
        }
    }

    private func updateResizingHandleTokens() {
        self.tokens = resolvedTokens
    }

    private func updateColors() {
        markLayer.backgroundColor = UIColor(dynamicColor: tokens.markColor).cgColor
        backgroundColor = customBackgroundColor ?? UIColor(dynamicColor: tokens.backgroundColor)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let window = window, window.isEqual(notification.object) else {
            return
        }
        updateResizingHandleTokens()
        updateColors()
    }
}
