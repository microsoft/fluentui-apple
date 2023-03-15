//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import UIKit

class FocusRingView: UIView, TokenizedControlInternal {
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let newWindow else {
            return
        }
        tokenSet.update(newWindow.fluentTheme)
        updateRingColors()
    }
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(outerFocusRing)
        layer.addSublayer(innerFocusRing)
        updateRingColors()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    typealias TokenSetKeyType = EmptyTokenSet.Tokens
    var tokenSet: EmptyTokenSet = .init()

    func drawFocusRing(over view: UIView) {
        NSLayoutConstraint.deactivate(ringViewConstraints)
        ringViewConstraints = [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(ringViewConstraints)
        updateRingBounds(for: view)
    }

    func updateRingBounds(for view: UIView) {
        let viewLayer = view.layer
        let ringBounds = view.bounds
        outerFocusRing.frame = ringBounds
        outerFocusRing.cornerRadius = viewLayer.cornerRadius
        outerFocusRing.cornerCurve = viewLayer.cornerCurve
        outerFocusRing.removeAllAnimations()

        let ringOrigin = ringBounds.origin
        innerFocusRing.cornerRadius = viewLayer.cornerRadius
        innerFocusRing.cornerCurve = viewLayer.cornerCurve
        innerFocusRing.frame = CGRect(x: ringOrigin.x + innerRingInset,
                                      y: ringOrigin.y + innerRingInset,
                                      width: ringBounds.width - innerRingInset * 2,
                                      height: ringBounds.height - innerRingInset * 2)
        innerFocusRing.removeAllAnimations()
    }

    func updateRingColors() {
        innerFocusRing.borderColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.strokeFocus1]).cgColor
        outerFocusRing.borderColor = UIColor(dynamicColor: fluentTheme.aliasTokens.colors[.strokeFocus2]).cgColor
    }

    private let innerFocusRing: CALayer = {
        let innerRing = CALayer()
        innerRing.borderWidth = GlobalTokens.stroke(.width10)

        return innerRing
    }()
    private let outerFocusRing: CALayer = {
        let outerRing = CALayer()
        outerRing.borderWidth = GlobalTokens.stroke(.width20)

        return outerRing
    }()
    private let innerRingInset: CGFloat = 1.5
    private var ringViewConstraints: [NSLayoutConstraint] = []
}
