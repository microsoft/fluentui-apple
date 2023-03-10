//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class DrawerShadowView: UIView, Shadowable {
    var ambientShadow: CALayer?
    var keyShadow: CALayer?

    static func shadowOffsetForPresentedView(with presentationDirection: DrawerPresentationDirection, offset: CGFloat) -> UIEdgeInsets {
        var margins: UIEdgeInsets = .zero
        switch presentationDirection {
        case .down:
            margins.bottom = offset
        case .up:
            margins.top = offset
        case .fromLeading:
            margins.right = offset
        case .fromTrailing:
            margins.left = offset
        }
        return margins
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
        }
    }

    private var animationDuration: TimeInterval = 0

    private var shadowDirection: DrawerPresentationDirection?

    private var drawerTokenSet: DrawerTokenSet

    init(shadowDirection: DrawerPresentationDirection?, tokenSet: DrawerTokenSet) {
        self.drawerTokenSet = tokenSet
        super.init(frame: .zero)
        self.shadowDirection = shadowDirection
        setupShadows()
        isAccessibilityElement = false
        isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    deinit {
        owner = nil
    }

    private func setupShadows() {
        let shadowInfo = drawerTokenSet[.shadow].shadowInfo
        ambientShadow = shadowInfo.initializeShadowLayer(view: self, isAmbientShadow: true)
        keyShadow = shadowInfo.initializeShadowLayer(view: self, isAmbientShadow: false)

        guard let direction = shadowDirection, let ambientShadow = ambientShadow, let keyShadow = keyShadow else {
            return
        }

        if direction.isHorizontal {
            layer.insertSublayer(ambientShadow, at: 0)
            layer.insertSublayer(keyShadow, below: ambientShadow)
        } else {
            layer.insertSublayer(ambientShadow, at: 0)
        }
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
                updateShadowPath(ambientShadow)
                updateShadowPath(keyShadow)
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

        ambientShadow?.frame = bounds
        keyShadow?.frame = bounds
        updateShadowPath(ambientShadow)
        updateShadowPath(keyShadow)
    }

    private func updateShadowPath(_ shadow: CALayer?) {
        let shadowLayer = shadow ?? layer
        let oldShadowPath = shadowLayer.shadowPath

        if let ownerLayer = owner?.layer {
            if let mask = ownerLayer.mask as? CAShapeLayer {
                shadowLayer.shadowPath = mask.path
            } else {
                shadowLayer.shadowPath = UIBezierPath(
                    roundedRect: ownerLayer.bounds,
                    byRoundingCorners: ownerLayer.roundedCorners,
                    cornerRadii: CGSize(width: ownerLayer.cornerRadius, height: ownerLayer.cornerRadius)
                ).cgPath
            }
        } else {
            shadowLayer.shadowPath = nil
        }

        animateShadowPath(from: oldShadowPath, baseLayer: shadowLayer)
    }

    private func animateShadowPath(from oldShadowPath: CGPath?, baseLayer: CALayer) {
        if animationDuration == 0 {
            return
        }

        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.shadowPath))
        animation.fromValue = oldShadowPath
        animation.duration = animationDuration
        // To match default timing function used in UIView.animate
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        baseLayer.add(animation, forKey: animation.keyPath)
    }
}
