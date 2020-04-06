//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSHUDDelegate

@objc public protocol MSHUDDelegate: class {
    func defaultWindowForHUD(_ hud: MSHUD) -> UIWindow?
}

// MARK: - MSHUDParams

public class MSHUDParams: NSObject {
    @objc open var caption: String
    @objc open var image: UIImage? {
        get {
            if case let .custom(image) = hudType {
                return image
            } else {
                return nil
            }
        }
        set {
            if let image = newValue {
                hudType = .custom(image: image)
            } else {
                hudType = .activity
            }
        }
    }
    @objc open var isBlocking: Bool
    @objc open var isPersistent: Bool

    fileprivate var hudType: MSHUDType

    // For Objective-C
    @objc public override convenience init() {
        self.init(caption: "", image: nil, isPersistent: true, isBlocking: true)
    }

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

    @objc public static let shared = MSHUD()

    @objc public weak var delegate: MSHUDDelegate?

    private var presentedHUDView: MSHUDView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let presentedHUDView = presentedHUDView {
                containerView.addSubview(presentedHUDView)
            }
        }
    }

    private lazy var containerView: MSTouchForwardingView = {
        let view = MSTouchForwardingView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = .clear
        containerViewFrameObservation = view.observe(\MSTouchForwardingView.frame) { [unowned self] (_, _) in
            self.layout()
        }
        return view
    }()
    private var containerViewFrameObservation: NSKeyValueObservation?

    private var keyboardHeight: CGFloat = 0

    private override init() {
        super.init()

        // Keyboard observation
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        containerViewFrameObservation = nil
    }

    // Using a separate overload method for Objective-C instead of default parameters
    @objc public func show(in view: UIView) {
        show(in: view, with: MSHUDParams())
    }

    @objc public func show(in view: UIView, with params: MSHUDParams) {
        show(in: view, with: params, onTap: nil)
    }

    @objc public func show(in view: UIView, with params: MSHUDParams, onTap: (() -> Void)? = nil) {
        resetIfNeeded()

        presentedHUDView = MSHUDView(label: params.caption, type: params.hudType)

        guard let presentedHUDView = presentedHUDView else {
            fatalError("MSHUD could not create MSHUDView")
        }

        containerView.forwardsTouches = !params.isBlocking
        view.addSubview(containerView)
        containerView.frame = view.bounds

        presentedHUDView.onTap = onTap

        // Setup MSHUD view start state
        presentedHUDView.alpha = 0.0
        presentedHUDView.transform = CGAffineTransform(scaleX: Constants.showAnimationScale, y: Constants.showAnimationScale)

        // Animate presentation
        UIView.animate(withDuration: Constants.showAnimationDuration, animations: {
            presentedHUDView.alpha = 1.0
            presentedHUDView.transform = .identity
        }, completion: { _ in
            UIAccessibility.post(notification: .screenChanged, argument: presentedHUDView)
        })

        // Dismiss after delay if needed
        if !params.isPersistent {
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.autoDismissTime) {
                self.hide()
            }
        }
    }

    // Using a separate overload method for Objective-C instead of default parameters
    @objc public func show(from controller: UIViewController) {
        show(from: controller, with: MSHUDParams())
    }

    @objc public func show(from controller: UIViewController, with params: MSHUDParams) {
        guard let hostWindow = hostWindow(for: controller) else {
            // No valid window found to host the MSHUD, don't present it
            return
        }

        show(in: hostWindow, with: params)
    }

    @objc public func showSuccess(in view: UIView, with caption: String = "") {
        show(in: view, with: MSHUDParams(caption: caption, hudType: .success, isPersistent: false, isBlocking: true))
    }

    @objc public func showSuccess(from controller: UIViewController, with caption: String = "") {
        guard let hostWindow = hostWindow(for: controller) else {
            // No valid window found to host the MSHUD, don't present it
            return
        }

        showSuccess(in: hostWindow, with: caption)
    }

    @objc public func showFailure(in view: UIView, with caption: String = "") {
        show(in: view, with: MSHUDParams(caption: caption, hudType: .failure, isPersistent: false, isBlocking: true))
    }

    @objc public func showFailure(from controller: UIViewController, with caption: String = "") {
        guard let hostWindow = hostWindow(for: controller) else {
            // No valid window found to host the MSHUD, don't present it
            return
        }

        showFailure(in: hostWindow, with: caption)
    }

    @objc(hideAnimated:)
    public func hide(animated: Bool = true) {
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
            UIAccessibility.post(notification: .screenChanged, argument: presentedHUDView.accessibilityMessageForHide)
        }

        if animated {
            UIView.animate(withDuration: Constants.hideAnimationDuration, animations: transition, completion: completion)
        } else {
            transition()
            completion(true)
        }
    }

    @objc public func update(with caption: String) {
        presentedHUDView?.label.text = caption
        layout()
    }

    private func hostWindow(for controller: UIViewController) -> UIWindow? {
        return controller.view.window ?? delegate?.defaultWindowForHUD(self)
    }

    private func resetIfNeeded() {
        containerView.removeFromSuperview()
        presentedHUDView = nil
    }

    private func layout() {
        guard let presentedHUDView = self.presentedHUDView else {
            return
        }

        let hudViewSize = presentedHUDView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))

        let keyboardMarginTop = keyboardHeight != 0 ? Constants.keyboardMarginTop : 0

        let maxHUDViewCenterY = containerView.frame.height - keyboardHeight - keyboardMarginTop - hudViewSize.height / 2.0
        let hudViewCenterY = UIScreen.main.roundToDevicePixels(min(maxHUDViewCenterY, containerView.frame.height / 2))

        // Use `position` and `bounds` to ensure we don't override the transform value
        presentedHUDView.layer.position = CGPoint(x: containerView.frame.width / 2, y: hudViewCenterY)
        presentedHUDView.layer.bounds = CGRect(origin: .zero, size: hudViewSize)
    }

    // MARK: Observations

    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                // Invalid keyboard notification
                return
        }

        // Animate position of MSHUD view
        keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: keyboardAnimationDuration, animations: layout)
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                // Invalid keyboard notification
                return
        }

        // Animate position of MSHUD view
        keyboardHeight = 0
        UIView.animate(withDuration: keyboardAnimationDuration, animations: layout)
    }
}
