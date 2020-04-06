//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSBlurringView

open class MSBlurringView: UIView {
    private let blurEffect: UIBlurEffect
    private let blurVisualEffectView: UIVisualEffectView
    private let backgroundView: UIView

    @objc public init(style: UIBlurEffect.Style, backgroundColor: UIColor? = nil) {
        blurEffect = UIBlurEffect(style: style)
        blurVisualEffectView = UIVisualEffectView(effect: blurEffect)

        backgroundView = UIView()
        backgroundView.backgroundColor = backgroundColor

        super.init(frame: .zero)

        isUserInteractionEnabled = false // Allow taps to pass through

        addSubview(blurVisualEffectView)
        addSubview(backgroundView) // backgroundView on top of blur
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        blurVisualEffectView.frame = bounds
        backgroundView.frame = bounds
    }

    @objc public func updateBackground(backgroundColor: UIColor?) {
        backgroundView.backgroundColor = backgroundColor
    }
}

// MARK: - MSBlurringView: Obscurable

extension MSBlurringView: Obscurable {
    var view: UIView { return self }
    var isObscuring: Bool {
        get {
            return blurVisualEffectView.effect != nil
        }
        set {
            blurVisualEffectView.effect = newValue ? blurEffect : nil
        }
    }
}
