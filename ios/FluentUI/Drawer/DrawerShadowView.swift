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

    private var drawerToken: DrawerTokens

//    private var shadow1 = CALayer()
//
//    private var shadow2 = CALayer()

    init(shadowDirection: DrawerPresentationDirection?, token: DrawerTokens) {
        self.drawerToken = token
        super.init(frame: .zero)
        self.shadowDirection = shadowDirection
        updateApperance()
        isAccessibilityElement = false
        isUserInteractionEnabled = false

//        layer.insertSublayer(shadow2, at: 0)
//        layer.insertSublayer(shadow1, below: shadow2)
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
//        guard let shadowDirection = shadowDirection else {
//            return
//        }
        
        layer.shadowRadius = drawerToken.dropShadowRadius
                    layer.shadowOffset = shadowOffset(for: shadowDirection)
                    layer.shadowOpacity = 0.5 //drawerToken.dropShadowOpacity
                    layer.shadowColor = UIColor.green.cgColor

//        shadow1.shadowColor = UIColor.blue.cgColor
//        shadow1.shadowRadius = drawerToken.shadow1Blur
//        shadow1.shadowOpacity = 1
//        shadow1.shadowOffset = shadow1Offset(for: shadowDirection)
//        shadow1.backgroundColor = backgroundColor?.cgColor
//
//        shadow2.shadowColor = UIColor.green.cgColor
//        shadow2.shadowRadius = drawerToken.shadow2Blur
//        shadow2.shadowOpacity = 1
//        shadow2.shadowOffset = shadow2Offset(for: shadowDirection)
//        shadow2.backgroundColor = backgroundColor?.cgColor

//        if shadowDirection.isHorizontal {
//            shadow1.shadowColor = UIColor.blue.cgColor
//            shadow1.shadowRadius = 4
//            shadow1.shadowOpacity = 0.5
//            shadow1.shadowOffset = shadowOffset(for: shadowDirection)
//            shadow1.backgroundColor = backgroundColor?.cgColor
//
//            shadow2.shadowColor = UIColor.green.cgColor
//            shadow2.shadowRadius = 4
//            shadow2.shadowOpacity = 0.5
//            shadow2.shadowOffset = shadowOffset(for: shadowDirection)
//            shadow2.backgroundColor = backgroundColor?.cgColor
//        } else {
//            layer.shadowRadius = drawerToken.dropShadowRadius
//            layer.shadowOffset = shadowOffset(for: shadowDirection)
//            layer.shadowOpacity = 0.5 //drawerToken.dropShadowOpacity
//            layer.shadowColor = UIColor.green.cgColor
//        }
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
                offset.height = drawerToken.dropShadowOffset
            case .up:
                offset.height = -drawerToken.dropShadowOffset
            case .fromLeading:
                offset.width = drawerToken.dropShadowOffset
            case .fromTrailing:
                offset.width = -drawerToken.dropShadowOffset
            }
        }
        return offset
    }

//    private func shadow1Offset(for shadowDirection: DrawerPresentationDirection?) -> CGSize {
//        var offset = CGSize.zero
//        if let shadowDirection = shadowDirection {
//            switch shadowDirection {
//            case .down:
//                offset.width = drawerToken.shadow1DepthX
//                offset.height = drawerToken.shadow1DepthY
//            case .up:
//                offset.width = -drawerToken.shadow1DepthX
//                offset.height = -drawerToken.shadow1DepthY
//            case .fromLeading:
//                offset.width = drawerToken.shadow1DepthX
//                offset.height = drawerToken.shadow1DepthY
//            case .fromTrailing:
//                offset.width = -drawerToken.shadow1DepthX
//                offset.height = -drawerToken.shadow1DepthY
//            }
//        }
//        return offset
//    }

//    private func shadow2Offset(for shadowDirection: DrawerPresentationDirection?) -> CGSize {
//        var offset = CGSize.zero
//        if let shadowDirection = shadowDirection {
//            switch shadowDirection {
//            case .down:
//                offset.width = drawerToken.shadow2DepthX
//                offset.height = drawerToken.shadow2DepthY
//            case .up:
//                offset.width = -drawerToken.shadow2DepthX
//                offset.height = -drawerToken.shadow2DepthY
//            case .fromLeading:
//                offset.width = drawerToken.shadow2DepthX
//                offset.height = drawerToken.shadow2DepthY
//            case .fromTrailing:
//                offset.width = -drawerToken.shadow2DepthX
//                offset.height = -drawerToken.shadow2DepthY
//            }
//        }
//        return offset
//    }

    private func updateFrame() {
        if let owner = owner, let ownerSuperview = owner.superview {
            frame = ownerSuperview.convert(owner.frame, to: superview)
        } else {
            frame = .zero
        }
//        shadow1.frame = frame
//        shadow2.frame = frame
        updateShadowPath()
        updateShadowPath()
    }

    private func updateShadowPath() {
        let shadow = layer
        let oldShadowPath = shadow.shadowPath

        if let ownerLayer = owner?.layer {
            if let mask = ownerLayer.mask as? CAShapeLayer {
                shadow.shadowPath = mask.path
            } else {
                shadow.shadowPath = UIBezierPath(
                    roundedRect: ownerLayer.bounds,
                    byRoundingCorners: ownerLayer.roundedCorners,
                    cornerRadii: CGSize(width: ownerLayer.cornerRadius, height: ownerLayer.cornerRadius)
                ).cgPath
            }
        } else {
            shadow.shadowPath = nil
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
