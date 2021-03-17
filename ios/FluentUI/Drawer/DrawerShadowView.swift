//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class DrawerShadowView: UIView {

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

    private var drawerTokens: MSFDrawerTokens

    private var shadow1 = CALayer()

    private var shadow2 = CALayer()

    init(shadowDirection: DrawerPresentationDirection?, token: MSFDrawerTokens) {
        self.drawerTokens = token
        super.init(frame: .zero)
        self.shadowDirection = shadowDirection
        updateApperance()
        isAccessibilityElement = false
        isUserInteractionEnabled = false
        if let direction = shadowDirection, direction.isHorizontal {
            layer.insertSublayer(shadow2, at: 0)
            layer.insertSublayer(shadow1, below: shadow2)
        } else {
            layer.insertSublayer(shadow1, at: 0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    deinit {
        owner = nil
    }

    func animate(withDuration duration: TimeInterval, animations: () -> Void) {
        animationDuration = duration
        animations()
        animationDuration = 0
    }

    func updateApperance() {
        guard let shadowDirection = shadowDirection else {
            return
        }
        shadow1.shadowColor = drawerTokens.shadow1Color.cgColor
        shadow1.shadowRadius = drawerTokens.shadow1Blur
        shadow1.shadowOpacity = 1 // delegate opacity to style sheet
        shadow1.shadowOffset = shadowOffset(for: shadowDirection, isFirst: true)

        if shadowDirection.isHorizontal {
            shadow2.shadowColor = drawerTokens.shadow2Color.cgColor
            shadow2.shadowRadius = drawerTokens.shadow2Blur
            shadow2.shadowOpacity = 1 // delegate opacity to style sheet
            shadow2.shadowOffset = shadowOffset(for: shadowDirection)
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
                updateShadowPath(shadow1)
                updateShadowPath(shadow2)
                return
            }
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }

    private func shadowOffset(for shadowDirection: DrawerPresentationDirection?, isFirst: Bool = false) -> CGSize {
        var offset = CGSize.zero
        if let shadowDirection = shadowDirection {
            switch shadowDirection {
            case .down:
                offset.height = drawerTokens.verticalShadowOffset
            case .up:
                offset.height = -drawerTokens.verticalShadowOffset
            case .fromLeading:
                offset.width = isFirst ? drawerTokens.shadow1DepthX : drawerTokens.shadow2DepthX
                offset.height = isFirst ? drawerTokens.shadow1DepthY : drawerTokens.shadow2DepthY
            case .fromTrailing:
                offset.width = -1 * (isFirst ? drawerTokens.shadow1DepthX : drawerTokens.shadow2DepthX)
                offset.height = -1 * (isFirst ? drawerTokens.shadow1DepthY : drawerTokens.shadow2DepthY)
            }
        }
        return offset
    }

    private func updateFrame() {
        if let owner = owner, let ownerSuperview = owner.superview {
            frame = ownerSuperview.convert(owner.frame, to: superview)
        } else {
            frame = .zero
        }
        shadow1.frame = bounds
        shadow2.frame = bounds
        updateShadowPath(shadow1)
        updateShadowPath(shadow2)
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
