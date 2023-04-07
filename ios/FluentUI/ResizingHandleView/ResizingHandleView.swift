//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: - ResizingHandleView

@objc(MSFResizingHandleView)
open class ResizingHandleView: UIView, TokenizedControlInternal {
    @objc public static let height: CGFloat = 20

    private lazy var markLayer: CALayer = {
        let markLayer = CALayer()
        markLayer.bounds.size = ResizingHandleTokenSet.markSize
        markLayer.cornerRadius = ResizingHandleTokenSet.markCornerRadius
        markLayer.backgroundColor = tokenSet[.markColor].uiColor.cgColor
        return markLayer
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = ResizingHandleView.height
        autoresizingMask = .flexibleWidth
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
        isUserInteractionEnabled = false
        updateColors()
        layer.addSublayer(markLayer)

        tokenSet.registerOnUpdate(for: self) { [weak self] in
            self?.updateColors()
        }
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

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateColors()
    }

    public typealias TokenSetKeyType = ResizingHandleTokenSet.Tokens
    public var tokenSet = ResizingHandleTokenSet()

    /// Internal custom color to preserve deprecated Drawer API (resizingHandleViewBackgroundColor)
    var customBackgroundColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    private func updateColors() {
        markLayer.backgroundColor = tokenSet[.markColor].uiColor.cgColor
        backgroundColor = customBackgroundColor ?? tokenSet[.backgroundColor].uiColor
    }
}
