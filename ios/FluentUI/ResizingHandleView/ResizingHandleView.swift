//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ResizingHandle Colors

private extension Colors {
    struct ResizingHandle {
        public static var mark: UIColor = iconSecondary
    }
}

// MARK: - ResizingHandleView

@objc(MSFResizingHandleView)
open class ResizingHandleView: UIView, TokenizedControlInternal {
    private struct Constants {
        static let markSize = CGSize(width: 36, height: 4)
        static let markCornerRadius: CGFloat = 2
    }

    @objc public static let height: CGFloat = 20

    private let markLayer: CALayer = {
        let markLayer = CALayer()
        markLayer.bounds.size = Constants.markSize
        markLayer.cornerRadius = Constants.markCornerRadius
        markLayer.backgroundColor = Colors.ResizingHandle.mark.cgColor
        return markLayer
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.frame.size.height = ResizingHandleView.height
        autoresizingMask = .flexibleWidth
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
        isUserInteractionEnabled = false
        layer.addSublayer(markLayer)
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

    var defaultTokens: ResizingHandleTokens = .init()
    var tokens: ResizingHandleTokens = .init()
    var overrideTokens: ResizingHandleTokens? {
        didSet {
            updateResizingHandleTokens()
            updateMarkColor()
        }
    }

    private func updateResizingHandleTokens() {
        self.tokens = resolvedTokens
    }

    private func updateMarkColor() {
        markLayer.backgroundColor = UIColor(dynamicColor: tokens.markColor).cgColor
    }
}
