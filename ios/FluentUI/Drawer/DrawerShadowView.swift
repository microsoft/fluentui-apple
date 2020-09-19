//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class DrawerShadowView: UIView {
    private struct Constants {
        static let shadowRadius: CGFloat = 4
        static let shadowOffset: CGFloat = 2
        static let shadowOpacity: Float = 0.1
    }

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

    init(shadowDirection: DrawerPresentationDirection?) {
        super.init(frame: .zero)
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOffset = shadowOffset(for: shadowDirection)
        layer.shadowOpacity = Constants.shadowOpacity
        isAccessibilityElement = false
        isUserInteractionEnabled = false
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

    private func shadowOffset(for shadowDirection: DrawerPresentationDirection?) -> CGSize {
        var offset = CGSize.zero
        if let shadowDirection = shadowDirection {
            switch shadowDirection {
            case .down:
                offset.height = Constants.shadowOffset
            case .up:
                offset.height = -Constants.shadowOffset
            case .fromLeading:
                offset.width = Constants.shadowOffset
            case .fromTrailing:
                offset.width = -Constants.shadowOffset
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
        updateShadowPath()
    }

    private func updateShadowPath() {
        let oldShadowPath = layer.shadowPath

        if let ownerLayer = owner?.layer {
            if let mask = ownerLayer.mask as? CAShapeLayer {
                layer.shadowPath = mask.path
            } else {
                layer.shadowPath = UIBezierPath(
                    roundedRect: ownerLayer.bounds,
                    byRoundingCorners: ownerLayer.roundedCorners,
                    cornerRadii: CGSize(width: ownerLayer.cornerRadius, height: ownerLayer.cornerRadius)
                ).cgPath
            }
        } else {
            layer.shadowPath = nil
        }

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
