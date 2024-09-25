//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import UIKit

class FocusRingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false

        layer.borderColor = FluentTheme.shared.color(.strokeFocus2).cgColor
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
        view.layer.borderColor = FluentTheme.shared.color(.strokeFocus1).cgColor
        view.layer.borderWidth = GlobalTokens.stroke(.width30)

        return view
    }()

    private var ringViewConstraints: [NSLayoutConstraint] = []
}
