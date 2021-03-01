// swiftlint:disable all
/// Autogenerated file
import UIKit

/// Entry point for the app stylesheet
extension FluentUIStyle {

	// MARK: - MSFButtonTokens
	open var MSFButtonTokens: MSFButtonTokensAppearanceProxy {
		return MSFButtonTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFButtonTokensAppearanceProxy {
		public let mainProxy: () -> FluentUIStyle
		public init(proxy: @escaping () -> FluentUIStyle) {
			self.mainProxy = proxy
		}

		// MARK: - backgroundColor
		open var backgroundColor: backgroundColorAppearanceProxy {
			return backgroundColorAppearanceProxy(proxy: mainProxy)
		}
		open class backgroundColorAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - disabled 
			open var disabled: UIColor {
				return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
			}

			// MARK: - hover 
			open var hover: UIColor {
				return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
			}

			// MARK: - pressed 
			open var pressed: UIColor {
				return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
			}

			// MARK: - rest 
			open var rest: UIColor {
				return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
			}

			// MARK: - selected 
			open var selected: UIColor {
				return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
			}
		}


		// MARK: - borderColor
		open var borderColor: borderColorAppearanceProxy {
			return borderColorAppearanceProxy(proxy: mainProxy)
		}
		open class borderColorAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - disabled 
			open var disabled: UIColor {
				return mainProxy().Colors.Background.brandDisabled
			}

			// MARK: - hover 
			open var hover: UIColor {
				return mainProxy().Colors.Background.brandHover
			}

			// MARK: - pressed 
			open var pressed: UIColor {
				return mainProxy().Colors.Background.brandPressed
			}

			// MARK: - rest 
			open var rest: UIColor {
				return mainProxy().Colors.Background.brandRest
			}

			// MARK: - selected 
			open var selected: UIColor {
				return mainProxy().Colors.Background.brandSelected
			}
		}


		// MARK: - borderRadius
		open var borderRadius: borderRadiusAppearanceProxy {
			return borderRadiusAppearanceProxy(proxy: mainProxy)
		}
		open class borderRadiusAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - large 
			open var large: CGFloat {
				return mainProxy().Border.radius.xlarge
			}

			// MARK: - medium 
			open var medium: CGFloat {
				return mainProxy().Border.radius.large
			}

			// MARK: - small 
			open var small: CGFloat {
				return mainProxy().Border.radius.medium
			}
		}


		// MARK: - borderSize
		open var borderSize: borderSizeAppearanceProxy {
			return borderSizeAppearanceProxy(proxy: mainProxy)
		}
		open class borderSizeAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - large 
			open var large: CGFloat {
				return mainProxy().Border.size.none
			}

			// MARK: - medium 
			open var medium: CGFloat {
				return mainProxy().Border.size.none
			}

			// MARK: - small 
			open var small: CGFloat {
				return mainProxy().Border.size.none
			}
		}


		// MARK: - iconColor
		open var iconColor: iconColorAppearanceProxy {
			return iconColorAppearanceProxy(proxy: mainProxy)
		}
		open class iconColorAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - disabled 
			open var disabled: UIColor {
				return mainProxy().Colors.Foreground.brandDisabled
			}

			// MARK: - hover 
			open var hover: UIColor {
				return mainProxy().Colors.Foreground.brandHover
			}

			// MARK: - pressed 
			open var pressed: UIColor {
				return mainProxy().Colors.Foreground.brandPressed
			}

			// MARK: - rest 
			open var rest: UIColor {
				return mainProxy().Colors.Foreground.brandRest
			}

			// MARK: - selected 
			open var selected: UIColor {
				return mainProxy().Colors.Foreground.brandSelected
			}
		}


		// MARK: - iconSize
		open var iconSize: iconSizeAppearanceProxy {
			return iconSizeAppearanceProxy(proxy: mainProxy)
		}
		open class iconSizeAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - large 
			open var large: CGFloat {
				return mainProxy().Icon.size.small
			}

			// MARK: - medium 
			open var medium: CGFloat {
				return mainProxy().Icon.size.small
			}

			// MARK: - small 
			open var small: CGFloat {
				return mainProxy().Icon.size.xSmall
			}
		}


		// MARK: - interspace
		open var interspace: interspaceAppearanceProxy {
			return interspaceAppearanceProxy(proxy: mainProxy)
		}
		open class interspaceAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - large 
			open var large: CGFloat {
				return mainProxy().Spacing.xSmall
			}

			// MARK: - medium 
			open var medium: CGFloat {
				return mainProxy().Spacing.xSmall
			}

			// MARK: - small 
			open var small: CGFloat {
				return mainProxy().Spacing.xxSmall
			}
		}


		// MARK: - padding
		open var padding: paddingAppearanceProxy {
			return paddingAppearanceProxy(proxy: mainProxy)
		}
		open class paddingAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - large 
			open var large: CGFloat {
				return mainProxy().Spacing.large
			}

			// MARK: - medium 
			open var medium: CGFloat {
				return mainProxy().Spacing.small
			}

			// MARK: - small 
			open var small: CGFloat {
				return mainProxy().Spacing.xSmall
			}
		}


		// MARK: - textColor
		open var textColor: textColorAppearanceProxy {
			return textColorAppearanceProxy(proxy: mainProxy)
		}
		open class textColorAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - disabled 
			open var disabled: UIColor {
				return mainProxy().Colors.Foreground.brandDisabled
			}

			// MARK: - hover 
			open var hover: UIColor {
				return mainProxy().Colors.Foreground.brandHover
			}

			// MARK: - pressed 
			open var pressed: UIColor {
				return mainProxy().Colors.Foreground.brandPressed
			}

			// MARK: - rest 
			open var rest: UIColor {
				return mainProxy().Colors.Foreground.brandRest
			}

			// MARK: - selected 
			open var selected: UIColor {
				return mainProxy().Colors.Foreground.brandSelected
			}
		}


		// MARK: - textFont
		open var textFont: textFontAppearanceProxy {
			return textFontAppearanceProxy(proxy: mainProxy)
		}
		open class textFontAppearanceProxy {
			public let mainProxy: () -> FluentUIStyle
			public init(proxy: @escaping () -> FluentUIStyle) {
				self.mainProxy = proxy
			}

			// MARK: - large 
			open var large: UIFont {
				return mainProxy().Typography.subheadline
			}

			// MARK: - medium 
			open var medium: UIFont {
				return mainProxy().Typography.subheadline
			}

			// MARK: - small 
			open var small: UIFont {
				return mainProxy().Typography.footnote
			}
		}

	}
	// MARK: - MSFGhostButtonTokens
	open var MSFGhostButtonTokens: MSFGhostButtonTokensAppearanceProxy {
		return MSFGhostButtonTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFGhostButtonTokensAppearanceProxy: MSFButtonTokensAppearanceProxy {

		// MARK: - MSFGhostButtonTokensborderColor
		open override var borderColor: MSFGhostButtonTokensborderColorAppearanceProxy {
			return MSFGhostButtonTokensborderColorAppearanceProxy(proxy: mainProxy)
		}
		open class MSFGhostButtonTokensborderColorAppearanceProxy: MSFButtonTokensAppearanceProxy.borderColorAppearanceProxy {

			// MARK: - disabled 
			open override var disabled: UIColor {
				return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
			}

			// MARK: - hover 
			open override var hover: UIColor {
				return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
			}

			// MARK: - pressed 
			open override var pressed: UIColor {
				return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
			}

			// MARK: - rest 
			open override var rest: UIColor {
				return UIColor(named: "FluentColors/clear", in: FluentUIFramework.resourceBundle, compatibleWith: nil)!
			}

			// MARK: - selected 
			open override var selected: UIColor {
				return mainProxy().Colors.Brand.shade10
			}
		}

	}
	// MARK: - MSFPrimaryButtonTokens
	open var MSFPrimaryButtonTokens: MSFPrimaryButtonTokensAppearanceProxy {
		return MSFPrimaryButtonTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFPrimaryButtonTokensAppearanceProxy: MSFButtonTokensAppearanceProxy {

		// MARK: - MSFPrimaryButtonTokensbackgroundColor
		open override var backgroundColor: MSFPrimaryButtonTokensbackgroundColorAppearanceProxy {
			return MSFPrimaryButtonTokensbackgroundColorAppearanceProxy(proxy: mainProxy)
		}
		open class MSFPrimaryButtonTokensbackgroundColorAppearanceProxy: MSFButtonTokensAppearanceProxy.backgroundColorAppearanceProxy {

			// MARK: - disabled 
			open override var disabled: UIColor {
				return mainProxy().Colors.Background.brandDisabled
			}

			// MARK: - hover 
			open override var hover: UIColor {
				return mainProxy().Colors.Background.brandHover
			}

			// MARK: - pressed 
			open override var pressed: UIColor {
				return mainProxy().Colors.Background.brandPressed
			}

			// MARK: - rest 
			open override var rest: UIColor {
				return mainProxy().Colors.Background.brandRest
			}

			// MARK: - selected 
			open override var selected: UIColor {
				return mainProxy().Colors.Background.brandSelected
			}
		}


		// MARK: - MSFPrimaryButtonTokensiconColor
		open override var iconColor: MSFPrimaryButtonTokensiconColorAppearanceProxy {
			return MSFPrimaryButtonTokensiconColorAppearanceProxy(proxy: mainProxy)
		}
		open class MSFPrimaryButtonTokensiconColorAppearanceProxy: MSFButtonTokensAppearanceProxy.iconColorAppearanceProxy {

			// MARK: - disabled 
			open override var disabled: UIColor {
				return mainProxy().Colors.Foreground.neutralInverted
			}

			// MARK: - hover 
			open override var hover: UIColor {
				return mainProxy().Colors.Foreground.neutralInverted
			}

			// MARK: - pressed 
			open override var pressed: UIColor {
				return mainProxy().Colors.Foreground.neutralInverted
			}

			// MARK: - rest 
			open override var rest: UIColor {
				return mainProxy().Colors.Foreground.neutralInverted
			}

			// MARK: - selected 
			open override var selected: UIColor {
				return mainProxy().Colors.Foreground.neutralInverted
			}
		}


		// MARK: - MSFPrimaryButtonTokenstextColor
		open override var textColor: MSFPrimaryButtonTokenstextColorAppearanceProxy {
			return MSFPrimaryButtonTokenstextColorAppearanceProxy(proxy: mainProxy)
		}
		open class MSFPrimaryButtonTokenstextColorAppearanceProxy: MSFButtonTokensAppearanceProxy.textColorAppearanceProxy {

			// MARK: - disabled 
			open override var disabled: UIColor {
				return mainProxy().Colors.Foreground.neutralInverted
			}

			// MARK: - hover 
			open override var hover: UIColor {
				return mainProxy().Colors.Foreground.neutralInverted
			}

			// MARK: - pressed 
			open override var pressed: UIColor {
				return mainProxy().Colors.Foreground.neutralInverted
			}

			// MARK: - rest 
			open override var rest: UIColor {
				return mainProxy().Colors.Foreground.neutralInverted
			}

			// MARK: - selected 
			open override var selected: UIColor {
				return mainProxy().Colors.Foreground.neutralInverted
			}
		}

	}
	// MARK: - MSFSecondaryButtonTokens
	open var MSFSecondaryButtonTokens: MSFSecondaryButtonTokensAppearanceProxy {
		return MSFSecondaryButtonTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFSecondaryButtonTokensAppearanceProxy: MSFButtonTokensAppearanceProxy {

		// MARK: - MSFSecondaryButtonTokensborderColor
		open override var borderColor: MSFSecondaryButtonTokensborderColorAppearanceProxy {
			return MSFSecondaryButtonTokensborderColorAppearanceProxy(proxy: mainProxy)
		}
		open class MSFSecondaryButtonTokensborderColorAppearanceProxy: MSFButtonTokensAppearanceProxy.borderColorAppearanceProxy {

			// MARK: - disabled 
			open override var disabled: UIColor {
				return mainProxy().Colors.Stroke.brandDisabled
			}

			// MARK: - hover 
			open override var hover: UIColor {
				return mainProxy().Colors.Stroke.brandHover
			}

			// MARK: - pressed 
			open override var pressed: UIColor {
				return mainProxy().Colors.Stroke.brandPressed
			}

			// MARK: - rest 
			open override var rest: UIColor {
				return mainProxy().Colors.Stroke.brandRest
			}

			// MARK: - selected 
			open override var selected: UIColor {
				return mainProxy().Colors.Stroke.brandSelected
			}
		}


		// MARK: - MSFSecondaryButtonTokensborderSize
		open override var borderSize: MSFSecondaryButtonTokensborderSizeAppearanceProxy {
			return MSFSecondaryButtonTokensborderSizeAppearanceProxy(proxy: mainProxy)
		}
		open class MSFSecondaryButtonTokensborderSizeAppearanceProxy: MSFButtonTokensAppearanceProxy.borderSizeAppearanceProxy {

			// MARK: - large 
			open override var large: CGFloat {
				return mainProxy().Border.size.thin
			}

			// MARK: - medium 
			open override var medium: CGFloat {
				return mainProxy().Border.size.thin
			}

			// MARK: - small 
			open override var small: CGFloat {
				return mainProxy().Border.size.thin
			}
		}

	}

}
fileprivate var __AppearanceProxyHandle: UInt8 = 0
fileprivate var __ThemeAwareHandle: UInt8 = 0
fileprivate var __ObservingDidChangeThemeHandle: UInt8 = 0

extension MSFButtonTokens: AppearaceProxyComponent {

	public typealias AppearanceProxyType = FluentUIStyle.MSFButtonTokensAppearanceProxy
	public var appearanceProxy: AppearanceProxyType {
		get {
			if let proxy = objc_getAssociatedObject(self, &__AppearanceProxyHandle) as? AppearanceProxyType {
				if !themeAware { return proxy }

				if let proxyString = Optional(String(reflecting: type(of: proxy))), proxyString.hasPrefix("FluentUI") == false {
					return proxy
				}

				if proxy is FluentUIStyle.MSFGhostButtonTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFGhostButtonTokens
				} else if proxy is FluentUIStyle.MSFPrimaryButtonTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFPrimaryButtonTokens
				} else if proxy is FluentUIStyle.MSFSecondaryButtonTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFSecondaryButtonTokens
				}
				return proxy
			}

			return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFButtonTokens
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
