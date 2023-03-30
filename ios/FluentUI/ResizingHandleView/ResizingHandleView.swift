//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import Combine

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
        markLayer.backgroundColor = UIColor(dynamicColor: tokenSet[.markColor].dynamicColor).cgColor
        return markLayer
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = ResizingHandleView.height
        autoresizingMask = .flexibleWidth
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
        isUserInteractionEnabled = false
        updateMarkLayerBackgroundColor()
        updateColors()
        layer.addSublayer(markLayer)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeDidChange),
                                               name: .didChangeTheme,
                                               object: nil)

        // Update appearance whenever `tokenSet` changes.
        tokenSetSink = tokenSet.objectWillChange.sink { [weak self] _ in
            // Values will be updated on the next run loop iteration.
            DispatchQueue.main.async {
                self?.updateColors()
            }
        }
        updateMarkLayerBackgroundColor()
   }

    private func updateMarkLayerBackgroundColor() {
        markLayer.backgroundColor = fluentTheme.color(.strokeAccessible).cgColor
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

    public typealias TokenSetKeyType = ResizingHandleTokenSet.Tokens
    public var tokenSet = ResizingHandleTokenSet()

    var tokenSetSink: AnyCancellable?

    /// Internal custom color to preserve deprecated Drawer API (resizingHandleViewBackgroundColor)
    var customBackgroundColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    private func updateColors() {
        markLayer.backgroundColor = UIColor(dynamicColor: tokenSet[.markColor].dynamicColor).cgColor
        backgroundColor = customBackgroundColor ?? UIColor(dynamicColor: tokenSet[.backgroundColor].dynamicColor)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        guard let themeView = notification.object as? UIView, self.isDescendant(of: themeView) else {
            return
        }
        tokenSet.update(themeView.fluentTheme)
        updateColors()
    }
}
