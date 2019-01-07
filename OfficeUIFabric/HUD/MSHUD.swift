//
//  Copyright © 2019 Microsoft Corporation. All rights reserved.
//

import UIKit

// MARK: MSHUDDelegate

@objc public protocol MSHUDDelegate: class {
    func defaultWindowForHUD(_ hud: MSHUD) -> UIWindow?
}

// MARK: - MSHUDParams

public class MSHUDParams: NSObject {
    fileprivate let caption: String
    fileprivate var hudType: MSHUDType
    fileprivate let isBlocking: Bool
    fileprivate let isPersistent: Bool

    @objc public convenience init(caption: String = "", image: UIImage? = nil, isPersistent: Bool = true, isBlocking: Bool = true) {
        if let image = image {
            self.init(caption: caption, hudType: .custom(image: image), isPersistent: isPersistent, isBlocking: isBlocking)
        } else {
            self.init(caption: caption, hudType: .activity, isPersistent: isPersistent, isBlocking: isBlocking)
        }
    }

    fileprivate init(caption: String, hudType: MSHUDType, isPersistent: Bool, isBlocking: Bool) {
        self.caption = caption
        self.hudType = hudType
        self.isBlocking = isBlocking
        self.isPersistent = isPersistent

        super.init()
    }
}

// MARK: - MSHUD

public class MSHUD: NSObject {
    private struct Constants {
        static let showAnimationDuration: TimeInterval = 0.2
        static let hideAnimationDuration: TimeInterval = 0.2
        static let autoDismissTime: TimeInterval = 1.0
        static let showAnimationScale: CGFloat = 1.3
        static let hideAnimationScale: CGFloat = 0.8
        static let keyboardMarginTop: CGFloat = 50.0
    }

    public static let shared = MSHUD()

    public weak var delegate: MSHUDDelegate?

    private var presentedHUDView: MSHUDView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let presentedHUDView = presentedHUDView {
                containerView.addSubview(presentedHUDView)
            }
        }
    }

    private let containerView: MSTouchForwardingView = {
        let view = MSTouchForwardingView()
        view.backgroundColor = .clear
        return view
    }()

    private var keyboardHeight: CGFloat = 0

    private override init() {
        super.init()

        // Orientation
        // `UIWindow` propagates rotation handling (eg. call to `layoutSubviews`) only to the subviews at the index 0. Because we add the MSHUD container as a sibling of such a view, we must handle rotation events ourselves.
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationDidChange(_:)), name: .UIApplicationDidChangeStatusBarOrientation, object: nil)

        // Keyboard observation
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    @objc public func show(in view: UIView, with params: MSHUDParams) {
        resetIfNeeded()

        containerView.forwardTouches = !params.isBlocking
        view.addSubview(containerView)

        presentedHUDView = MSHUDView(label: params.caption, type: params.hudType)

        guard let presentedHUDView = presentedHUDView else {
            fatalError("MSHUD could not create MSHUDView")
        }

        // Setup MSHUD view start state
        layout()
        presentedHUDView.alpha = 0.0
        presentedHUDView.transform = CGAffineTransform(scaleX: Constants.showAnimationScale, y: Constants.showAnimationScale)

        // Animate presentation
        UIView.animate(withDuration: Constants.showAnimationDuration, animations: {
            presentedHUDView.alpha = 1.0
            presentedHUDView.transform = .identity
        }, completion: { _ in
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil)
        })

        // Dismiss after delay if needed
        if !params.isPersistent {
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.autoDismissTime) {
                self.hide()
            }
        }
    }

    @objc public func show(from controller: UIViewController, with params: MSHUDParams) {
        guard let hostWindow = hostWindow(for: controller) else {
            // No valid window found to host the MSHUD, don't present it
            return
        }

        show(in: hostWindow, with: params)
    }

    @objc public func showSuccess(from controller: UIViewController, with caption: String = "") {
        guard let hostWindow = hostWindow(for: controller) else {
            // No valid window found to host the MSHUD, don't present it
            return
        }

        show(in: hostWindow, with: MSHUDParams(caption: caption, hudType: .success, isPersistent: false, isBlocking: true))
    }

    @objc public func showFailure(from controller: UIViewController, with caption: String = "") {
        guard let hostWindow = hostWindow(for: controller) else {
            // No valid window found to host the MSHUD, don't present it
            return
        }

        show(in: hostWindow, with: MSHUDParams(caption: caption, hudType: .failure, isPersistent: false, isBlocking: true))
    }

    @objc public func hide(animated: Bool = true) {
        guard let presentedHUDView = presentedHUDView else {
            return
        }

        let transition = {
            presentedHUDView.alpha = 0.0
            presentedHUDView.transform = CGAffineTransform(scaleX: Constants.hideAnimationScale, y: Constants.hideAnimationScale)
        }

        let completion = { (finished: Bool) in
            guard presentedHUDView === presentedHUDView else {
                // MSHUD has been shown before it finished being hidden
                return
            }
            self.resetIfNeeded()
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, presentedHUDView.accessibilityMessageForHide)
        }

        if animated {
            UIView.animate(withDuration: Constants.hideAnimationDuration, animations: transition, completion: completion)
        } else {
            transition()
            completion(true)
        }
    }

    private func hostWindow(for controller: UIViewController) -> UIWindow? {
        return controller.view.window ?? delegate?.defaultWindowForHUD(self)
    }

    private func resetIfNeeded() {
        containerView.removeFromSuperview()
        presentedHUDView = nil
    }

    private func layout() {
        containerView.frame = containerView.superview?.bounds ?? .zero

        guard let presentedHUDView = self.presentedHUDView else {
            return
        }

        let hudViewSize = presentedHUDView.sizeThatFits(.max)

        let keyboardMarginTop = keyboardHeight != 0 ? Constants.keyboardMarginTop : 0

        let maxHUDViewCenterY = containerView.height - keyboardHeight - keyboardMarginTop - hudViewSize.height / 2.0
        let hudViewCenterY = UIScreen.main.roundToDevicePixels(min(maxHUDViewCenterY, containerView.height / 2))

        // Use `position` and `bounds` to ensure we don't override the transform value
        presentedHUDView.layer.position = CGPoint(x: containerView.width / 2, y: hudViewCenterY)
        presentedHUDView.layer.bounds = CGRect(origin: .zero, size: hudViewSize)
    }

    // MARK: Observations

    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardAnimationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                // Invalid keyboard notification
                return
        }

        // Animate position of MSHUD view
        keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: keyboardAnimationDuration, animations: layout)
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardAnimationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                // Invalid keyboard notification
                return
        }

        // Animate position of MSHUD view
        keyboardHeight = 0
        UIView.animate(withDuration: keyboardAnimationDuration, animations: layout)
    }

    @objc private func handleOrientationDidChange(_ notification: Notification) {
        layout()
    }
}
