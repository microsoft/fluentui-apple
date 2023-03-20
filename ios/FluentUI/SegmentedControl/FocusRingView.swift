//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import UIKit

class FocusRingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.strokeFocus2]).cgColor
        layer.borderWidth = GlobalTokens.stroke(.width20)

        addSubview(innerFocusRing)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: innerFocusRing.topAnchor),
            leadingAnchor.constraint(equalTo: innerFocusRing.leadingAnchor),
            trailingAnchor.constraint(equalTo: innerFocusRing.trailingAnchor),
            bottomAnchor.constraint(equalTo: innerFocusRing.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawFocusRing(over view: UIView) {
        let viewLayer = view.layer
        let cornerRadius = viewLayer.cornerRadius
        let cornerCurve = viewLayer.cornerCurve
        let innerLayer = innerFocusRing.layer
        innerLayer.cornerRadius = cornerRadius
        innerLayer.cornerCurve = cornerCurve
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = cornerCurve

        NSLayoutConstraint.deactivate(ringViewConstraints)
        ringViewConstraints = [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(ringViewConstraints)
    }

    private var innerFocusRing: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor(dynamicColor: FluentTheme.shared.aliasTokens.colors[.strokeFocus1]).cgColor
        view.layer.borderWidth = GlobalTokens.stroke(.width30)

        return view
    }()

    private var ringViewConstraints: [NSLayoutConstraint] = []
}

protocol DrawsFocusRings {
    var innerFocusRing: CALayer { get set }
    var outerFocusRing: CALayer { get set }

    func updateFocusRings(over layer: CALayer)
}

extension DrawsFocusRings {
    func updateFocusRings(over layer: CALayer) {
        let ringBounds = layer.bounds
        outerFocusRing.frame = ringBounds
        outerFocusRing.cornerRadius = layer.cornerRadius
        outerFocusRing.cornerCurve = layer.cornerCurve
        outerFocusRing.removeAllAnimations()

        innerFocusRing.frame = ringBounds
        innerFocusRing.cornerRadius = layer.cornerRadius
        innerFocusRing.cornerCurve = layer.cornerCurve
        innerFocusRing.removeAllAnimations()
    }

    func addRings(to layer: CALayer) {
        // the inner ring needs to be added first to show under the outer ring.
        layer.addSublayer(innerFocusRing)
        layer.addSublayer(outerFocusRing)
    }

    func initializeRingLayer(isInnerRing: Bool) -> CALayer {
        let color: FluentTheme.ColorToken
        let width: GlobalTokens.StrokeWidthToken
        if isInnerRing {
            color = .strokeFocus1
            width = .width30
        } else {
            color = .strokeFocus2
            width = .width20
        }
        let ringLayer = CALayer()
        ringLayer.borderColor = UIColor(dynamicColor: FluentTheme.shared.color(color)).cgColor
        ringLayer.borderWidth = GlobalTokens.stroke(width)
        ringLayer.isHidden = true
        return ringLayer
    }
}
