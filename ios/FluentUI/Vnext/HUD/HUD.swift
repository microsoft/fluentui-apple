//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: HUDDelegate

@objc(MSFHUDDelegate)
public protocol HUDDelegate: AnyObject {
    func defaultWindowForHUD(_ hud: HUD) -> UIWindow?
}

// MARK: - HUDParams

@objc(MSFHUDParams)
public class HUDParams: NSObject {
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

    fileprivate var hudType: HUDType

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

    fileprivate init(caption: String, hudType: HUDType, isPersistent: Bool, isBlocking: Bool) {
        self.caption = caption
        self.hudType = hudType
        self.isBlocking = isBlocking
        self.isPersistent = isPersistent

        super.init()
    }
}

// MARK: - HUD

@objc(MSFHUD)
/// Represents the controller that is able to present the Heads-up display in a `UIView` or  from a`UIViewController`.
public class HUD: NSObject {

    // MARK: Public funcs

    /// Presents a Heads-up display.
    /// - Parameter view: `UIView` in which the Heads-up display will be presented.
    @objc public func show(in view: UIView) {
        // Using a separate overload method for Objective-C instead of default parameters
        show(in: view, with: HUDParams())
    }

    /// Presents a Heads-up display.
    /// - Parameters:
    ///   - view: `UIView` in which the Heads-up display will be presented.
    ///   - params: `HUDParams` containing the confirguration of the Heads-up display.
    @objc public func show(in view: UIView,
                           with params: HUDParams) {
        show(in: view, with: params, onTap: nil)
    }

    /// Presents a Heads-up display.
    /// - Parameters:
    ///   - view: `UIView` in which the Heads-up display will be presented.
    ///   - params: `HUDParams` containing the confirguration of the Heads-up display.
    ///   - onTap: Closure or block that will be executed when the user taps on the Heads-up display.
    @objc public func show(in view: UIView,
                           with params: HUDParams,
                           onTap: (() -> Void)? = nil) {
        resetIfNeeded()

        presentedHUDView = MSFHeadsUpDisplay(type: params.hudType,
                                             label: params.caption,
                                             tapAction: onTap)

        guard let presentedHUDView = presentedHUDView else {
            preconditionFailure("HUD could not create HUDView")
        }

        containerView.forwardsTouches = !params.isBlocking
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        updateBottomConstraintConstant()

        NSLayoutConstraint.activate([
            bottomConstraint!,
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            presentedHUDView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            presentedHUDView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        // Setup MSHUD view start state
        presentedHUDView.alpha = 0.0
        presentedHUDView.transform = CGAffineTransform(scaleX: Constants.showAnimationScale,
                                                       y: Constants.showAnimationScale)

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

    /// Presents a Heads-up display.
    /// - Parameter controller: `UIViewController` for the Heads-up display to be presented from.
    @objc public func show(from controller: UIViewController) {
        // Using a separate overload method for Objective-C instead of default parameters
        show(from: controller,
             with: HUDParams())
    }

    /// Presents a Heads-up display.
    /// - Parameters:
    ///   - controller: `UIViewController` for the Heads-up display to be presented from.
    ///   - params: `HUDParams` containing the confirguration of the Heads-up display.
    @objc public func show(from controller: UIViewController,
                           with params: HUDParams) {
        // Using a separate overload method for Objective-C instead of default parameters
        show(from: controller,
             with: params,
             onTap: nil)
    }

    /// Presents a Heads-up display.
    /// - Parameters:
    ///   - controller: `UIViewController` for the Heads-up display to be presented from.
    ///   - params: `HUDParams` containing the confirguration of the Heads-up display.
    ///   - onTap: Closure or block that will be executed when the user taps on the Heads-up display.
    @objc public func show(from controller: UIViewController,
                           with params: HUDParams,
                           onTap: (() -> Void)? = nil) {
        guard let hostWindow = hostWindow(for: controller) else {
            // No valid window found to host the HUD, don't present it
            return
        }

        show(in: hostWindow,
             with: params,
             onTap: onTap)
    }

    /// Presents a success Heads-up display.
    /// - Parameters:
    ///   - view: `UIView` in which the Heads-up display will be presented.
    ///   - caption: Value of the caption of the presented Heads-up display.
    @objc public func showSuccess(in view: UIView,
                                  with caption: String = "") {
        show(in: view,
             with: HUDParams(caption: caption,
                             hudType: .success,
                             isPersistent: false,
                             isBlocking: true))
    }

    /// Presents a success Heads-up display.
    /// - Parameters:
    ///   - controller: `UIViewController` for the Heads-up display to be presented from.
    ///   - caption: Value of the caption of the presented Heads-up display.
    @objc public func showSuccess(from controller: UIViewController,
                                  with caption: String = "") {
        guard let hostWindow = hostWindow(for: controller) else {
            // No valid window found to host the HUD, don't present it
            return
        }

        showSuccess(in: hostWindow, with: caption)
    }

    /// Presents a failure Heads-up display.
    /// - Parameters:
    ///   - view: `UIView` in which the Heads-up display will be presented.
    ///   - caption: Value of the caption of the presented Heads-up display.
    @objc public func showFailure(in view: UIView,
                                  with caption: String = "") {
        show(in: view,
             with: HUDParams(caption: caption,
                             hudType: .failure,
                             isPersistent: false,
                             isBlocking: true))
    }

    /// Presents a failure Heads-up display.
    /// - Parameters:
    ///   - controller: `UIViewController` for the Heads-up display to be presented from.
    ///   - caption: Value of the caption of the presented Heads-up display.
    @objc public func showFailure(from controller: UIViewController,
                                  with caption: String = "") {
        guard let hostWindow = hostWindow(for: controller) else {
            // No valid window found to host the HUD, don't present it
            return
        }

        showFailure(in: hostWindow, with: caption)
    }

    @objc(hideAnimated:)
    /// Hides the presented Heads-up display.
    /// - Parameter animated: Whether the hide operation should be animated.
    public func hide(animated: Bool = true) {
        guard let presentedHUDView = presentedHUDView else {
            return
        }

        let transition = {
            presentedHUDView.alpha = 0.0
            presentedHUDView.transform = CGAffineTransform(scaleX: Constants.hideAnimationScale,
                                                           y: Constants.hideAnimationScale)
        }

        let completion = { (_ finished: Bool) in
            guard presentedHUDView === presentedHUDView else {
                // HUD has been shown before it finished being hidden
                return
            }
            self.resetIfNeeded()
            UIAccessibility.post(notification: .screenChanged,
                                 argument: "Accessibility.HUD.Done".localized)
        }

        if animated {
            UIView.animate(withDuration: Constants.hideAnimationDuration,
                           animations: transition,
                           completion: completion)
        } else {
            transition()
            completion(true)
        }
    }

    /// Updates the caption of the presented Heads-up display.
    /// - Parameter caption: Value of the new caption.
    @objc public func update(with caption: String) {
        guard let presentedHUDView = presentedHUDView else {
            return
        }

        presentedHUDView.state.label = caption
        UIAccessibility.post(notification: .layoutChanged, argument: presentedHUDView)
    }

    // MARK: Public properties

    /// Shared instance of the `HUD` class.
    @objc public static let shared = HUD()

    /// Optional `HUDDelegate` instance.
    @objc public weak var delegate: HUDDelegate?

    /// Optional instance of custom `HeadsUpDisplayTokens` to overrided the design tokens.
    public var overrideTokens: HeadsUpDisplayTokens? {
        didSet {
            presentedHUDView?.state.overrideTokens = overrideTokens
        }
    }

    // MARK: Internal members

    struct Constants {
        static let showAnimationDuration: TimeInterval = 0.2
        static let hideAnimationDuration: TimeInterval = 0.2
        static let autoDismissTime: TimeInterval = 1.0
        static let showAnimationScale: CGFloat = 1.3
        static let hideAnimationScale: CGFloat = 0.8
        static let keyboardMarginTop: CGFloat = 50.0
    }

    // MARK: Private funcs

    private override init() {
        super.init()

        // Keyboard observation
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func hostWindow(for controller: UIViewController) -> UIWindow? {
        return controller.view.window ?? delegate?.defaultWindowForHUD(self)
    }

    private func resetIfNeeded() {
        containerView.removeFromSuperview()
        presentedHUDView = nil
    }

    private func updateBottomConstraintConstant() {
        guard self.presentedHUDView != nil else {
            return
        }

        bottomConstraint?.constant = keyboardHeight != 0 ? -1 * (Constants.keyboardMarginTop + keyboardHeight ) : 0
    }

    // MARK: Observations

    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                // Invalid keyboard notification
                return
        }

        // Animate position of HUD view
        keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: keyboardAnimationDuration, animations: updateBottomConstraintConstant)
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                // Invalid keyboard notification
                return
        }

        // Animate position of HUD view
        keyboardHeight = 0
        UIView.animate(withDuration: keyboardAnimationDuration, animations: updateBottomConstraintConstant)
    }

    // MARK: Private properties

    private var presentedHUDView: MSFHeadsUpDisplay? {
        didSet {
            oldValue?.removeFromSuperview()
            if let presentedHUDView = presentedHUDView {
                presentedHUDView.translatesAutoresizingMaskIntoConstraints = false
                presentedHUDView.state.overrideTokens = overrideTokens
                containerView.addSubview(presentedHUDView)
            }
        }
    }

    private lazy var containerView: TouchForwardingView = {
        let view = TouchForwardingView()
        view.backgroundColor = .clear
        return view
    }()

    private var bottomConstraint: NSLayoutConstraint?
    private var keyboardHeight: CGFloat = 0
}
