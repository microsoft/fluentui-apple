// swiftlint:disable all
/// Autogenerated file
import UIKit

/// Entry point for the app stylesheet
extension FluentUIStyle {

	// MARK: - MSFPersonaGridItemTokens
	open var MSFPersonaGridItemTokens: MSFPersonaGridItemTokensAppearanceProxy {
		return MSFPersonaGridItemTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFPersonaGridItemTokensAppearanceProxy {
		public let mainProxy: () -> FluentUIStyle
		public init(proxy: @escaping () -> FluentUIStyle) {
			self.mainProxy = proxy
		}

		// MARK: - avatarInterspace
		open var avatarInterspace: avatarInterspaceAppearanceProxy {
			return avatarInterspaceAppearanceProxy(proxy: mainProxy)
		}
		open class avatarInterspaceAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - large 
			open var large: CGFloat {
				return mainProxy().Spacing.small
			}

			// MARK: - small 
			open var small: CGFloat {
				return mainProxy().Spacing.xSmall
			}
		}


		// MARK: - backgroundColor 
		open var backgroundColor: UIColor {
			return mainProxy().Colors.Background.neutral1
		}

		// MARK: - labelColor 
		open var labelColor: UIColor {
			return mainProxy().Colors.Foreground.neutral1
		}

		// MARK: - labelFont
		open var labelFont: labelFontAppearanceProxy {
			return labelFontAppearanceProxy(proxy: mainProxy)
		}
		open class labelFontAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - large 
			open var large: UIFont {
				return mainProxy().Typography.subheadline
			}

			// MARK: - small 
			open var small: UIFont {
				return mainProxy().Typography.caption1
			}
		}


		// MARK: - padding 
		open var padding: CGFloat {
			return mainProxy().Spacing.xSmall
		}

		// MARK: - sublabelColor 
		open var sublabelColor: UIColor {
			return mainProxy().Colors.Foreground.neutral3
		}

		// MARK: - sublabelFont 
		open var sublabelFont: UIFont {
			return mainProxy().Typography.footnote
		}
	}

}
fileprivate var __AppearanceProxyHandle: UInt8 = 0
fileprivate var __ThemeAwareHandle: UInt8 = 0
fileprivate var __ObservingDidChangeThemeHandle: UInt8 = 0

extension MSFPersonaGridItemTokens: AppearaceProxyComponent {

	public typealias AppearanceProxyType = FluentUIStyle.MSFPersonaGridItemTokensAppearanceProxy
	public var appearanceProxy: AppearanceProxyType {
		get {
			if let proxy = objc_getAssociatedObject(self, &__AppearanceProxyHandle) as? AppearanceProxyType {
				if !themeAware { return proxy }


				return proxy
			}

			return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFPersonaGridItemTokens
		}
		set {
			objc_setAssociatedObject(self, &__AppearanceProxyHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			didChangeAppearanceProxy()
		}
	}

	public var themeAware: Bool {
		get {
			guard let proxy = objc_getAssociatedObject(self, &__ThemeAwareHandle) as? Bool else { return true }
			return proxy
		}
		set {
			objc_setAssociatedObject(self, &__ThemeAwareHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			isObservingDidChangeTheme = newValue
		}
	}

	fileprivate var isObservingDidChangeTheme: Bool {
		get {
			guard let observing = objc_getAssociatedObject(self, &__ObservingDidChangeThemeHandle) as? Bool else { return false }
			return observing
		}
		set {
			if newValue == isObservingDidChangeTheme { return }
			if newValue {
				NotificationCenter.default.addObserver(self, selector: #selector(didChangeAppearanceProxy), name: Notification.Name.didChangeTheme, object: nil)
			} else {
				NotificationCenter.default.removeObserver(self, name: Notification.Name.didChangeTheme, object: nil)
			}
			objc_setAssociatedObject(self, &__ObservingDidChangeThemeHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}
