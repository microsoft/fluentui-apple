// swiftlint:disable all
/// Autogenerated file
import UIKit

/// Entry point for the app stylesheet
extension FluentUIStyle {

	// MARK: - MSFDangerToastNotificationTokens
	open var MSFDangerToastNotificationTokens: MSFDangerToastNotificationTokensAppearanceProxy {
		return MSFDangerToastNotificationTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFDangerToastNotificationTokensAppearanceProxy: MSFNotificationTokensAppearanceProxy {

		// MARK: - backgroundColor 
		open override var backgroundColor: UIColor {
			return UIColor(light: UIColor(named: "FluentColors/redTint60", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/redShade40", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - cornerRadius 
		open override var cornerRadius: CGFloat {
			return mainProxy().Border.radius.xLarge
		}

		// MARK: - foregroundColor 
		open override var foregroundColor: UIColor {
			return UIColor(light: UIColor(named: "FluentColors/redShade10", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/redTint20", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - presentationOffSet 
		open override var presentationOffSet: CGFloat {
			return mainProxy().Spacing.small
		}
	}
	// MARK: - MSFNeutralBarNotificationTokens
	open var MSFNeutralBarNotificationTokens: MSFNeutralBarNotificationTokensAppearanceProxy {
		return MSFNeutralBarNotificationTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFNeutralBarNotificationTokensAppearanceProxy: MSFNotificationTokensAppearanceProxy {

		// MARK: - backgroundColor 
		open override var backgroundColor: UIColor {
			return UIColor(light: UIColor(named: "FluentColors/charcoalTint50", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/charcoalPrimary", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - cornerRadius 
		open override var cornerRadius: CGFloat {
			return mainProxy().Border.radius.none
		}

		// MARK: - foregroundColor 
		open override var foregroundColor: UIColor {
			return UIColor(light: UIColor(named: "FluentColors/charcoalShade50", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/charcoalTint60", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - presentationOffSet 
		open override var presentationOffSet: CGFloat {
			return mainProxy().Spacing.none
		}

		// MARK: - shadowColor 
		open override var shadowColor: UIColor {
			return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
		}
	}
	// MARK: - MSFNeutralToastNotificationTokens
	open var MSFNeutralToastNotificationTokens: MSFNeutralToastNotificationTokensAppearanceProxy {
		return MSFNeutralToastNotificationTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFNeutralToastNotificationTokensAppearanceProxy: MSFNotificationTokensAppearanceProxy {

		// MARK: - backgroundColor 
		open override var backgroundColor: UIColor {
			return UIColor(light: UIColor(named: "FluentColors/charcoalTint60", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/charcoalPrimary", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - cornerRadius 
		open override var cornerRadius: CGFloat {
			return mainProxy().Border.radius.xLarge
		}

		// MARK: - foregroundColor 
		open override var foregroundColor: UIColor {
			return UIColor(light: UIColor(named: "FluentColors/charcoalPrimary", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/charcoalTint60", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - presentationOffSet 
		open override var presentationOffSet: CGFloat {
			return mainProxy().Spacing.small
		}
	}
	// MARK: - MSFNotificationTokens
	open var MSFNotificationTokens: MSFNotificationTokensAppearanceProxy {
		return MSFNotificationTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFNotificationTokensAppearanceProxy {
		public let mainProxy: () -> FluentUIStyle
		public init(proxy: @escaping () -> FluentUIStyle) {
			self.mainProxy = proxy
		}

		// MARK: - backgroundColor 
		open var backgroundColor: UIColor {
			return mainProxy().Colors.Brand.tint40
		}

		// MARK: - cornerRadius 
		open var cornerRadius: CGFloat {
			return mainProxy().Border.radius.xLarge
		}

		// MARK: - foregroundColor 
		open var foregroundColor: UIColor {
			return mainProxy().Colors.Brand.shade10
		}

		// MARK: - horizontalPadding 
		open var horizontalPadding: CGFloat {
			return CGFloat(16.0)
		}

		// MARK: - horizontalSpacing 
		open var horizontalSpacing: CGFloat {
			return CGFloat(16.0)
		}

		// MARK: - minimumHeight 
		open var minimumHeight: CGFloat {
			return CGFloat(64.0)
		}

		// MARK: - minimumHeightForOneLine 
		open var minimumHeightForOneLine: CGFloat {
			return CGFloat(56.0)
		}

		// MARK: - presentationOffSet 
		open var presentationOffSet: CGFloat {
			return mainProxy().Spacing.small
		}

		// MARK: - shadowBlur 
		open var shadowBlur: CGFloat {
			return mainProxy().Shadow.shadow16.blur1
		}

		// MARK: - shadowColor 
		open var shadowColor: UIColor {
			return mainProxy().Shadow.shadow16.color1
		}

		// MARK: - shadowOffsetX 
		open var shadowOffsetX: CGFloat {
			return mainProxy().Shadow.shadow16.x1
		}

		// MARK: - shadowOffsetY 
		open var shadowOffsetY: CGFloat {
			return mainProxy().Shadow.shadow16.y1
		}

		// MARK: - verticalPadding 
		open var verticalPadding: CGFloat {
			return CGFloat(12.0)
		}

		// MARK: - verticalPaddingForOneLine 
		open var verticalPaddingForOneLine: CGFloat {
			return CGFloat(16.0)
		}
	}
	// MARK: - MSFPrimaryBarNotificationTokens
	open var MSFPrimaryBarNotificationTokens: MSFPrimaryBarNotificationTokensAppearanceProxy {
		return MSFPrimaryBarNotificationTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFPrimaryBarNotificationTokensAppearanceProxy: MSFNotificationTokensAppearanceProxy {

		// MARK: - backgroundColor 
		open override var backgroundColor: UIColor {
			return UIColor(light: mainProxy().Colors.Brand.tint40, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: mainProxy().Colors.Brand.tint10, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - cornerRadius 
		open override var cornerRadius: CGFloat {
			return mainProxy().Border.radius.none
		}

		// MARK: - foregroundColor 
		open override var foregroundColor: UIColor {
			return UIColor(light: mainProxy().Colors.Brand.shade20, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/black", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - presentationOffSet 
		open override var presentationOffSet: CGFloat {
			return mainProxy().Spacing.none
		}

		// MARK: - shadowColor 
		open override var shadowColor: UIColor {
			return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
		}
	}
	// MARK: - MSFPrimaryOutlineBarNotificationTokens
	open var MSFPrimaryOutlineBarNotificationTokens: MSFPrimaryOutlineBarNotificationTokensAppearanceProxy {
		return MSFPrimaryOutlineBarNotificationTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFPrimaryOutlineBarNotificationTokensAppearanceProxy: MSFNotificationTokensAppearanceProxy {

		// MARK: - backgroundColor 
		open override var backgroundColor: UIColor {
			return UIColor(light: UIColor(named: "FluentColors/white", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/charcoalPrimary", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - cornerRadius 
		open override var cornerRadius: CGFloat {
			return mainProxy().Border.radius.none
		}

		// MARK: - foregroundColor 
		open override var foregroundColor: UIColor {
			return UIColor(light: mainProxy().Colors.Brand.primary, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/charcoalTint60", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - presentationOffSet 
		open override var presentationOffSet: CGFloat {
			return mainProxy().Spacing.none
		}

		// MARK: - shadowColor 
		open override var shadowColor: UIColor {
			return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
		}
	}
	// MARK: - MSFPrimaryToastNotificationTokens
	open var MSFPrimaryToastNotificationTokens: MSFPrimaryToastNotificationTokensAppearanceProxy {
		return MSFPrimaryToastNotificationTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFPrimaryToastNotificationTokensAppearanceProxy: MSFNotificationTokensAppearanceProxy {

		// MARK: - backgroundColor 
		open override var backgroundColor: UIColor {
			return mainProxy().Colors.Brand.tint40
		}

		// MARK: - cornerRadius 
		open override var cornerRadius: CGFloat {
			return mainProxy().Border.radius.xLarge
		}

		// MARK: - foregroundColor 
		open override var foregroundColor: UIColor {
			return UIColor(light: mainProxy().Colors.Brand.shade10, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: mainProxy().Colors.Brand.shade30, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - presentationOffSet 
		open override var presentationOffSet: CGFloat {
			return mainProxy().Spacing.small
		}
	}
	// MARK: - MSFWarningToastNotificationTokens
	open var MSFWarningToastNotificationTokens: MSFWarningToastNotificationTokensAppearanceProxy {
		return MSFWarningToastNotificationTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFWarningToastNotificationTokensAppearanceProxy: MSFNotificationTokensAppearanceProxy {

		// MARK: - backgroundColor 
		open override var backgroundColor: UIColor {
			return UIColor(light: UIColor(named: "FluentColors/yellowTint50", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/yellowShade40", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - cornerRadius 
		open override var cornerRadius: CGFloat {
			return mainProxy().Border.radius.xLarge
		}

		// MARK: - foregroundColor 
		open override var foregroundColor: UIColor {
			return UIColor(light: UIColor(named: "FluentColors/yellowShade50", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, lightHighContrast: nil, lightElevated: nil, lightElevatedHighContrast: nil, dark: UIColor(named: "FluentColors/yellowTint20", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!, darkHighContrast: nil, darkElevated: nil, darkElevatedHighContrast: nil)
		}

		// MARK: - presentationOffSet 
		open override var presentationOffSet: CGFloat {
			return mainProxy().Spacing.small
		}
	}

}
fileprivate var __AppearanceProxyHandle: UInt8 = 0
fileprivate var __ThemeAwareHandle: UInt8 = 0
fileprivate var __ObservingDidChangeThemeHandle: UInt8 = 0

extension MSFNotificationTokens: AppearaceProxyComponent {

	public typealias AppearanceProxyType = FluentUIStyle.MSFNotificationTokensAppearanceProxy
	public var appearanceProxy: AppearanceProxyType {
		get {
			if let proxy = objc_getAssociatedObject(self, &__AppearanceProxyHandle) as? AppearanceProxyType {
				if !themeAware { return proxy }

				if let proxyString = Optional(String(reflecting: type(of: proxy))), proxyString.hasPrefix("FluentUI") == false {
					return proxy
				}

				if proxy is FluentUIStyle.MSFDangerToastNotificationTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFDangerToastNotificationTokens
				} else if proxy is FluentUIStyle.MSFNeutralBarNotificationTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFNeutralBarNotificationTokens
				} else if proxy is FluentUIStyle.MSFNeutralToastNotificationTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFNeutralToastNotificationTokens
				} else if proxy is FluentUIStyle.MSFPrimaryBarNotificationTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFPrimaryBarNotificationTokens
				} else if proxy is FluentUIStyle.MSFPrimaryOutlineBarNotificationTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFPrimaryOutlineBarNotificationTokens
				} else if proxy is FluentUIStyle.MSFPrimaryToastNotificationTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFPrimaryToastNotificationTokens
				} else if proxy is FluentUIStyle.MSFWarningToastNotificationTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFWarningToastNotificationTokens
				}
				return proxy
			}

			return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFNotificationTokens
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
