//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

class DrawerShadowView: UIView {
    private struct Constants {
        static let shadowRadius: CGFloat = 4
        static let shadowOffset: CGFloat = 2
        static let shadowOpacity: Float = 0.05
    }

    var owner: UIView? {
        didSet {
            if let oldOwner = oldValue {
                oldOwner.removeObserver(self, forKeyPath: #keyPath(frame), context: nil)
                oldOwner.removeObserver(self, forKeyPath: #keyPath(bounds), context: nil)
                oldOwner.layer.removeObserver(self, forKeyPath: #keyPath(CALayer.mask), context: nil)
            }
            if let owner = owner {
                owner.addObserver(self, forKeyPath: #keyPath(frame), options: [], context: nil)
                owner.addObserver(self, forKeyPath: #keyPath(bounds), options: [], context: nil)
                owner.layer.addObserver(self, forKeyPath: #keyPath(CALayer.mask), options: [], context: nil)
            }
            updateFrame()
            updateShadowPath()
        }
    }

    private var animationDuration: TimeInterval = 0

    init(shadowDirection: MSDrawerPresentationDirection) {
        super.init(frame: .zero)
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOffset = CGSize(width: 0, height: Constants.shadowOffset * (shadowDirection == .down ? 1 : -1))
        layer.shadowOpacity = Constants.shadowOpacity
        isAccessibilityElement = false
        isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        owner = nil
    }

    func animate(withDuration duration: TimeInterval, animations: () -> Void) {
        animationDuration = duration
        animations()
        animationDuration = 0
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateFrame()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let owner = owner {
            if object as? UIView == owner && (keyPath == #keyPath(frame) || keyPath == #keyPath(bounds)) {
                updateFrame()
                return
            }
            if object as? CALayer == owner.layer && keyPath == #keyPath(CALayer.mask) {
                updateShadowPath()
                return
            }
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }

    private func updateFrame() {
        if let owner = owner, let ownerSuperview = owner.superview {
            frame = ownerSuperview.convert(owner.frame, to: superview)
        } else {
            frame = .zero
        }
    }

    private func updateShadowPath() {
        let oldShadowPath = layer.shadowPath
        layer.shadowPath = (owner?.layer.mask as? CAShapeLayer)?.path
        animateShadowPath(from: oldShadowPath)
    }

    private func animateShadowPath(from oldShadowPath: CGPath?) {
        if animationDuration == 0 {
            return
        }

        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.shadowPath))
        animation.fromValue = oldShadowPath
        animation.duration = animationDuration
        // To match default timing function used in UIView.animate
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        layer.add(animation, forKey: animation.keyPath)
    }
}
