//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import UIKit

/// Base class for all Fluent control tokenization.
public class ControlTokenSet<T: TokenSetKey>: ObservableObject {
    /// Allows us to index into this token set using square brackets.
    ///
    /// We can use square brackets to both read and write into this `TokenSet`. For example:
    /// ```
    /// let value = tokenSet[.primary]   // exercises the `get`
    /// tokenSet[.secondary] = newValue  // exercises the `set`
    /// ```
    public subscript(token: T) -> ControlTokenValue {
        get {
            if let value = overrideValue(forToken: token) {
                return value
            } else if let value = defaults?(token, self.fluentTheme) {
                return value
            } else {
                preconditionFailure()
            }
        }
        set(value) {
            setOverrideValue(value, forToken: token)
        }
    }

    /// Removes a stored override for a given token value.
    ///
    /// - Parameter token: The token value whose override should be removed.
    public func removeOverride(_ token: T) {
        valueOverrides?[token] = nil
    }

    /// Convenience method to replace all overrides with a new set of values.
    ///
    /// Any value present in `overrideTokens` will be set onto this control. All other values will be
    /// removed from this control. If overrideTokens is `nil`, then all current overrides will be removed.
    ///
    /// - Parameter overrideTokens: The set of tokens to set as custom, or `nil` to remove all overrides.
    public func replaceAllOverrides(with overrideTokens: [T: ControlTokenValue]?) {
        T.allCases.forEach { token in
            if let value = overrideTokens?[token] {
                self[token] = value
            } else {
                self.removeOverride(token)
            }
        }
    }

    /// Convenience method to override multiple tokens from another token set.
    ///
    /// This is useful if `otherTokenSet` belongs to a parent control and `self` belongs to a child control.
    ///
    /// - Parameter otherTokenSet: The token set we will be pulling values from.
    /// - Parameter mapping: A `Dictionary` that maps our own tokens that we wish to override with
    /// their corresponding tokens in `otherTokenSet`.
    func setOverrides<U>(from otherTokenSet: ControlTokenSet<U>, mapping: [T: U]) {
        // Make a copy so we write all the values at once
        var valueOverrideCopy = valueOverrides ?? [:]
        mapping.forEach { (thisToken, otherToken) in
            valueOverrideCopy[thisToken] = otherTokenSet.overrideValue(forToken: otherToken)
        }
        valueOverrides = valueOverrideCopy
    }

    /// Initialize the `ControlTokenSet` with an escaping callback for fetching default values.
    init(_ defaults: @escaping (_ token: T, _ theme: FluentTheme) -> ControlTokenValue) {
        self.defaults = defaults
    }

    deinit {
        deregisterOnUpdate()
    }

    /// Removes all `onUpdate`-based observing. Useful if you are re-registering the same tokenSet
    /// for a new instance of a control (see `Tooltip` for an example).
    func deregisterOnUpdate() {
        if let notificationObserver {
            NotificationCenter.default.removeObserver(notificationObserver,
                                                      name: .didChangeTheme,
                                                      object: nil)
        }
        changeSink = nil
        notificationObserver = nil
        onUpdate = nil
    }

    /// Prepares this token set by installing the current `FluentTheme` if it has changed.
    ///
    /// - Parameter fluentTheme: The current `FluentTheme` for the control's environment.
    func update(_ fluentTheme: FluentTheme) {
        if fluentTheme != self.fluentTheme {
            self.fluentTheme = fluentTheme
        }
    }

    // Internal accessor and setter functions for the override dictionary

    /// Returns the current override value for a given token, or nil if none exists.
    ///
    /// This API will check `valueOverrides` first for local overrides, and `fluentTheme.tokens(for:)`
    /// second, returning the first of those to be non-nil, or nil if both are unset.
    ///
    /// - Parameter token: The token key to fetch any existing override for.
    ///
    /// - Returns: the active override value for a given token, or nil if none exists.
    func overrideValue(forToken token: T) -> ControlTokenValue? {
        if let value = valueOverrides?[token] {
            return value
        } else if let value = fluentTheme.tokens(for: type(of: self))?[token] {
            return value
        }
        return nil
    }

    /// Sets an override value for a given token key.
    ///
    /// - Parameter value: The value to set as an override.
    /// - Parameter token: The token key whose value should be set.
    func setOverrideValue(_ value: ControlTokenValue?, forToken token: T) {
        if valueOverrides == nil {
            valueOverrides = [:]
        }
        valueOverrides?[token] = value
    }

    /// Registers an observing control for update calls.
    ///
    /// The `onUpdate` callback will be invoked in two cases:
    /// 1. A new override value has been set on this `ControlTokenSet`.
    /// 2. A `Notification.Name.didChangeTheme` notification was fired for either `control` or one of its superviews.
    ///
    /// Note: consecutive calls to this method will no-op; only the first invocation will be recognized. If you need to change
    /// the view requesting updates, invoke `deregisterOnUpdate()` before calling `registerOnUpdate` a second time.
    ///
    /// - Parameter control: The `UIView` instance that wishes to observe.
    /// - Parameter onUpdate: A callback to run whenever `control` should update itself.
    func registerOnUpdate(for control: UIView, onUpdate: @escaping (() -> Void)) {
        guard self.onUpdate == nil,
              changeSink == nil,
              notificationObserver == nil else {
            assertionFailure("Attempting to double-register for tokenSet updates!")
            return
        }
        self.onUpdate = onUpdate

        changeSink = self.objectWillChange.sink { [weak self] in
            // Values will be updated on the next run loop iteration.
            DispatchQueue.main.async {
                self?.onUpdate?()
            }
        }

        // Register for notifications in order to call update() when the theme changes.
        notificationObserver = NotificationCenter.default.addObserver(forName: .didChangeTheme,
                                                                      object: nil,
                                                                      queue: nil) { [weak self, weak control] notification in
            guard let strongSelf = self,
                  let control,
                  FluentTheme.isApplicableThemeChange(notification, for: control)
            else {
                return
            }
            strongSelf.update(control.fluentTheme)
        }
    }

    /// The current `FluentTheme` associated with this `ControlTokenSet`.
    var fluentTheme: FluentTheme = FluentTheme.shared {
        didSet {
            guard let onUpdate else {
                return
            }
            onUpdate()
        }
    }

    /// Access to raw overrides for the `ControlTokenSet`.
    @Published private var valueOverrides: [T: ControlTokenValue]?

    /// Reference to the default value lookup function for this control.
    private var defaults: ((_ token: T, _ theme: FluentTheme) -> ControlTokenValue)?

    /// Holds the sink for any changes to the control token set.
    private var changeSink: AnyCancellable?

    /// Stores the notification handler for .didChangeTheme notifications.
    private var notificationObserver: NSObjectProtocol?

    /// A callback to be invoked after the token set has completed updating.
    private var onUpdate: (() -> Void)?

    /// Common approach for addressing the tokens of a given control.
    public typealias Tokens = T
}

/// Union-type enumeration of all possible token values to be stored by a `ControlTokenSet`.
public enum ControlTokenValue {
    case float(() -> CGFloat)
    case uiColor(() -> UIColor)
    case uiFont(() -> UIFont)
    case shadowInfo(() -> ShadowInfo)

    public var float: CGFloat {
        if case .float(let float) = self {
            return float()
        } else {
            assertionFailure("Cannot convert token to CGFloat: \(self)")
            return 0.0
        }
    }

    public var uiColor: UIColor {
        if case .uiColor(let uiColor) = self {
            return uiColor()
        } else {
            assertionFailure("Cannot convert token to UIColor: \(self)")
            return fallbackColor
        }
    }

    public var uiFont: UIFont {
        if case .uiFont(let uiFont) = self {
            return uiFont()
        } else {
            assertionFailure("Cannot convert token to FontInfo: \(self)")
            return UIFont()
        }
    }

    public var shadowInfo: ShadowInfo {
        if case .shadowInfo(let shadowInfo) = self {
            return shadowInfo()
        } else {
            assertionFailure("Cannot convert token to ShadowInfo: \(self)")
            return ShadowInfo(keyColor: fallbackColor,
                              keyBlur: 10.0,
                              xKey: 10.0,
                              yKey: 10.0,
                              ambientColor: fallbackColor,
                              ambientBlur: 10.0,
                              xAmbient: 10.0,
                              yAmbient: 10.0)
        }
    }

    /// Creates a `ControlTokenValue` from any supported object type.
    ///
    /// Mapping for types of `value` and the resulting `ControlTokenValue`:
    ///
    /// | `value` instance type | `ControlTokenValue` |
    /// |---|---|
    /// | `NSNumber`¹  | `.float` |
    /// | `UIColor` | `.uiColor` |
    /// | `UIFont` | `.uiFont` |
    /// | `ShadowInfo` | `.shadowInfo` |
    /// | All other types | `nil` |
    ///
    /// ¹ Note that, because `value` must be an object type, floats must be passed as a wrapped `NSNumber`.
    ///
    /// - Parameter value: An object of one of the supported types for `ControlTokenValue`.
    init?(_ value: AnyObject) {
        switch value {
        case let number as NSNumber:
            self = .float { CGFloat(number.doubleValue) }
        case let color as UIColor:
            self = .uiColor { color }
        case let font as UIFont:
            self = .uiFont { font }
        case let shadowInfo as ShadowInfo:
            self = .shadowInfo { shadowInfo }
        default:
            return nil
        }
    }

    // MARK: - Helpers

    private var fallbackColor: UIColor {
#if DEBUG
        // Use our global "Hot Pink" in debug builds, to help identify unintentional conversions.
        return GlobalTokens.sharedColor(.hotPink, .primary)
#else
        return GlobalTokens.neutralColor(.black)
#endif
    }
}

#if DEBUG
extension ControlTokenValue: CustomStringConvertible {
    /// Handy debug-only description for logging these values.
    public var description: String {
        switch self {
        case .float(let float):
            return "ControlTokenValue.float (\(float())"
        case .uiColor(let uiColor):
            return "ControlTokenValue.uiColor (\(uiColor())"
        case .uiFont(let uiFont):
            return "ControlTokenValue.uiFont (\(uiFont())"
        case .shadowInfo(let shadowInfo):
            return "ControlTokenValue.shadowInfo (\(shadowInfo())"
        }
    }
}
#endif // DEBUG
