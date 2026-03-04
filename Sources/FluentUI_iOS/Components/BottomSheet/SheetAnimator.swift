//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// A `UIUpdateLink`-driven spring animator designed for sheet transitions.
///
/// The animator updates a value incrementally on every display frame.
/// This is analogous to how gesture-driven sheet animations happen,
/// but in this case we let screen updates drive the changes instead of pan updates.
///
/// It's more robust for sheet content layout stability than native out-of-process animations, which don't interop with SwiftUI content.
///
/// Usage:
///     let animator = SheetAnimator(view: someView)
///     animator.animate(from: currentOffset, to: targetOffset, initialVelocity: velocity) { currentValue in
///         bottomSheetView.frame = sheetFrame(offset: currentValue)
///     } completion: {
///         handleCompletedStateChange(...)
///     }
@available(iOS 18.0, *)
public class SheetAnimator {

    /// Creates a `SheetAnimator`.
    ///
    /// - Parameter view: The view to associate with the `UIUpdateLink`.
    ///   Pass the view whose frame is being animated.
    public init(view: UIView) {
        self.associatedView = view
    }

    /// When `true`, keeps the high-frame-rate update link alive even when no animation is running.
    /// Set this to `true` at pan start and `false` after the release animation completes.
    /// An active high-rate update link forces the system to deliver touch events at the display's
    /// maximum refresh rate (e.g. 120Hz on ProMotion).
    public var wantsHighFrameRateIdle: Bool = false {
        didSet {
            guard wantsHighFrameRateIdle != oldValue else { return }
            if wantsHighFrameRateIdle {
                startUpdateLinkIfNeeded()
            } else if !isRunning {
                stopUpdateLink()
            }
        }
    }

    /// Whether a spring animation is currently in progress.
    public var isRunning: Bool {
        spring != nil
    }

    /// The current animated value, or `nil` if no animation is in progress.
    public var currentValue: CGFloat? {
        spring?.position
    }

    /// The current velocity (points per second), or `nil` if no animation is in progress.
    public var currentVelocity: CGFloat? {
        spring?.velocity
    }

    /// Starts a spring animation from `fromValue` to `toValue`.
    ///
    /// - Parameters:
    ///   - fromValue: The starting value.
    ///   - toValue: The target value.
    ///   - initialVelocity: The initial velocity (in points per second) at the start of the animation.
    ///   - dampingRatio: The damping ratio for the spring. 1.0 = critically damped (no oscillation),
    ///     < 1.0 = underdamped (oscillation). Defaults to 1.0.
    ///   - duration: The approximate duration of the animation. The spring stiffness and damping
    ///     are derived from this and the damping ratio. Defaults to 0.4.
    ///   - onChange: Called on every display frame with the current interpolated value.
    ///   - completion: Called when the spring has settled and the animation is complete.
    public func animate(from fromValue: CGFloat,
                        to toValue: CGFloat,
                        initialVelocity: CGFloat = 0,
                        dampingRatio: CGFloat = 1.0,
                        duration: TimeInterval = 0.4,
                        onChange: @escaping (CGFloat) -> Void,
                        completion: @escaping () -> Void) {
        stop()

        let distance = toValue - fromValue
        guard abs(distance) > Self.settleTolerance else {
            onChange(toValue)
            completion()
            return
        }

        // Derive spring parameters from duration and damping ratio.
        // For a spring: ω = 2π / duration (natural frequency approximation),
        // damping coefficient = 2 * dampingRatio * ω.
        let omega = 2.0 * .pi / duration
        let stiffness = omega * omega          // ω²
        let damping = 2.0 * dampingRatio * omega  // 2ζω

        self.spring = SpringState(
            position: fromValue,
            velocity: initialVelocity,
            target: toValue,
            stiffness: stiffness,
            damping: damping
        )
        self.onChangeHandler = onChange
        self.completionHandler = completion
        self.lastTimestamp = nil

        startUpdateLinkIfNeeded()
    }

    /// Immediately stops the animation at its current value.
    public func stop() {
        spring = nil
        lastTimestamp = nil
        onChangeHandler = nil
        completionHandler = nil

        if !wantsHighFrameRateIdle {
            stopUpdateLink()
        }
    }

    /// Stops the animation and jumps to the target value.
    public func skipToEnd() {
        guard let spring else {
            return
        }
        let target = spring.target
        let handler = onChangeHandler
        let completion = completionHandler
        stop()
        handler?(target)
        completion?()
    }

    // MARK: - Update link management

    private func startUpdateLinkIfNeeded() {
        guard updateLink == nil, let view = associatedView else { return }

        let link = UIUpdateLink(view: view) { [weak self] _, info in
            self?.step(timestamp: info.modelTime)
        }
        link.requiresContinuousUpdates = true
        link.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 120, preferred: 120)
        link.isEnabled = true
        self.updateLink = link
    }

    private func stopUpdateLink() {
        updateLink?.isEnabled = false
        updateLink = nil
    }

    // MARK: - Frame callback

    private func step(timestamp: CFTimeInterval) {
        guard var spring else {
            return
        }

        let dt: CGFloat
        if let last = lastTimestamp {
            dt = CGFloat(timestamp - last)
        } else {
            dt = CGFloat(1.0 / 120.0) // assume high refresh for first frame
        }
        lastTimestamp = timestamp

        // Clamp dt to avoid instability from frame drops or debugger pauses.
        let clampedDt = min(dt, 1.0 / 30.0)

        // Semi-implicit Euler integration of the spring equation:
        //   acceleration = -stiffness * displacement - damping * velocity
        let displacement = spring.position - spring.target
        let acceleration = -spring.stiffness * displacement - spring.damping * spring.velocity

        spring.velocity += acceleration * clampedDt
        spring.position += spring.velocity * clampedDt

        self.spring = spring

        // Check if the spring has settled.
        if abs(spring.position - spring.target) < Self.settleTolerance &&
            abs(spring.velocity) < Self.settleTolerance {
            let target = spring.target
            let completion = completionHandler
            stop()
            onChangeHandler?(target)
            completion?()
            return
        }

        onChangeHandler?(spring.position)
    }

    // MARK: - Private state

    private struct SpringState {
        var position: CGFloat
        var velocity: CGFloat
        let target: CGFloat
        let stiffness: CGFloat   // ω²
        let damping: CGFloat     // 2ζω
    }

    private static let settleTolerance: CGFloat = 0.5

    private weak var associatedView: UIView?
    private var spring: SpringState?
    private var lastTimestamp: CFTimeInterval?
    private var onChangeHandler: ((CGFloat) -> Void)?
    private var completionHandler: (() -> Void)?
    private var updateLink: UIUpdateLink?

    deinit {
        stopUpdateLink()
    }
}
