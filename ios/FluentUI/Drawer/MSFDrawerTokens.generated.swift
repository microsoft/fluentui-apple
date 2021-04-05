// swiftlint:disable all
/// Autogenerated file
import UIKit

/// Entry point for the app stylesheet
extension FluentUIStyle {

	// MARK: - MSFDrawerTokens
	open var MSFDrawerTokens: MSFDrawerTokensAppearanceProxy {
		return MSFDrawerTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFDrawerTokensAppearanceProxy {
		public let mainProxy: () -> FluentUIStyle
		public init(proxy: @escaping () -> FluentUIStyle) {
			self.mainProxy = proxy
		}

		// MARK: - backgroundClearColor 
		open var backgroundClearColor: UIColor {
			return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
		}

		// MARK: - backgroundDimmedColor 
		open var backgroundDimmedColor: UIColor {
			return mainProxy().Colors.Elevation.highElevation
		}

		// MARK: - cornerRadius 
		open var cornerRadius: CGFloat {
			return mainProxy().Border.radius.xxlarge
		}

		// MARK: - drawerHorizontalContentBackground 
		open var drawerHorizontalContentBackground: UIColor {
			return mainProxy().Colors.Background.neutral1
		}

		// MARK: - drawerVerticalContentBackground 
		open var drawerVerticalContentBackground: UIColor {
			return UIColor(light: mainProxy().Colors.Background.neutral1, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: mainProxy().Colors.Background.neutral3, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - dropShadowOffset 
		open var dropShadowOffset: CGFloat {
			return mainProxy().Spacing.xxxSmall
		}

		// MARK: - dropShadowOpacity 
		open var dropShadowOpacity: CGFloat {
			return mainProxy().Opacity.opacity05
		}

		// MARK: - dropShadowRadius 
		open var dropShadowRadius: CGFloat {
			return mainProxy().Border.radius.medium
		}

		// MARK: - horizontalShadowOffset 
		open var horizontalShadowOffset: CGFloat {
			return mainProxy().Spacing.small
		}

		// MARK: - minMargin
		open var minMargin: minMarginAppearanceProxy {
			return minMarginAppearanceProxy(proxy: mainProxy)
		}
		open class minMarginAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - horizontal 
			open var horizontal: CGFloat {
				return mainProxy().Spacing.xxxlarge
			}

			// MARK: - vertical 
			open var vertical: CGFloat {
				return mainProxy().Spacing.large
			}
		}


		// MARK: - navigationBarBackground 
		open var navigationBarBackground: UIColor {
			return UIColor(light: mainProxy().Colors.Background.surfacePrimary, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/grey14", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - popoverContentBackground 
		open var popoverContentBackground: UIColor {
			return UIColor(light: mainProxy().Colors.Background.surfacePrimary, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: mainProxy().Colors.Background.surfaceQuaternary, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - resizingHandleViewBackgroundColor 
		open var resizingHandleViewBackgroundColor: UIColor {
			return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
		}

		// MARK: - shadow1Blur 
		open var shadow1Blur: CGFloat {
			return mainProxy().Shadow.shadow28.blur1
		}

		// MARK: - shadow1Color 
		open var shadow1Color: UIColor {
			return mainProxy().Shadow.shadow28.color1
		}

		// MARK: - shadow1OffsetX 
		open var shadow1OffsetX: CGFloat {
			return mainProxy().Shadow.shadow28.x1
		}

		// MARK: - shadow1OffsetY 
		open var shadow1OffsetY: CGFloat {
			return mainProxy().Shadow.shadow28.y1
		}

		// MARK: - shadow2Blur 
		open var shadow2Blur: CGFloat {
			return mainProxy().Shadow.shadow28.blur2
		}

		// MARK: - shadow2Color 
		open var shadow2Color: UIColor {
			return mainProxy().Shadow.shadow28.color2
		}

		// MARK: - shadow2OffsetX 
		open var shadow2OffsetX: CGFloat {
			return mainProxy().Shadow.shadow28.x2
		}

		// MARK: - shadow2OffsetY 
		open var shadow2OffsetY: CGFloat {
			return mainProxy().Shadow.shadow28.y2
		}

		// MARK: - verticalShadowOffset 
		open var verticalShadowOffset: CGFloat {
			return mainProxy().Spacing.xSmall
		}
	}

}
fileprivate var __AppearanceProxyHandle: UInt8 = 0
fileprivate var __ThemeAwareHandle: UInt8 = 0
fileprivate var __ObservingDidChangeThemeHandle: UInt8 = 0

extension MSFDrawerTokens: AppearaceProxyComponent {

	public typealias AppearanceProxyType = FluentUIStyle.MSFDrawerTokensAppearanceProxy
	public var appearanceProxy: AppearanceProxyType {
		get {
			if let proxy = objc_getAssociatedObject(self, &__AppearanceProxyHandle) as? AppearanceProxyType {
				if !themeAware { return proxy }


				return proxy
			}

			return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFDrawerTokens
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
