//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

@objc(MSFButtonVnextStyle)
/// Pre-defined styles of the button (same values currently defined in the current FluentUI button)
public enum ButtonVnextStyle: Int, CaseIterable {
    case primaryFilled
    case primaryOutline
    case secondaryOutline
    case tertiaryOutline
    case borderless
}

// - MARK: Design tokens

/// Protocol that defines the configurable/customizable design tokens of the button
public protocol ButtonVNextTokens {
	var titleFont: Font { get set }

	var titleColor: UIColor { get set }
	var borderColor: UIColor { get set }
	var backgroundColor: UIColor { get set }

	var highlightedTitleColor: UIColor { get set }
	var highlightedBorderColor: UIColor { get set }
	var highlightedBackgroundColor: UIColor { get set }

	var disabledTitleColor: UIColor { get set }
	var disabledBorderColor: UIColor { get set }
	var disabledBackgroundColor: UIColor { get set }

	var cornerRadius: CGFloat { get set }

	var edgeInsets: UIEdgeInsets { get set }

	var hasBorders: Bool { get set }
	var borderWidth: CGFloat { get set }
}

// - MARK: FluentUI Tokens (Default)

/// Tokens for the primaryFilled style in the FluentUI StyleSheet
public class ButtonVnextPrimaryFilledTokens: ButtonVNextTokens {
	public var titleFont: Font

	public var titleColor: UIColor
	public var borderColor: UIColor
	public var backgroundColor: UIColor

	public var highlightedTitleColor: UIColor
	public var highlightedBorderColor: UIColor
	public var highlightedBackgroundColor: UIColor

	public var disabledTitleColor: UIColor
	public var disabledBorderColor: UIColor
	public var disabledBackgroundColor: UIColor

	public var cornerRadius: CGFloat = 8.0

	public var edgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)

	public var hasBorders: Bool = false
	public var borderWidth: CGFloat = 1.0

	public init() {
		titleFont = .subheadline

		titleColor = Colors.Button.titleWithFilledBackground
		borderColor = UIColor.clear
		backgroundColor = Colors.communicationBlue

		highlightedTitleColor = Colors.Button.titleWithFilledBackground
		highlightedBorderColor = UIColor.clear
		highlightedBackgroundColor = Colors.Palette.communicationBlueTint10.color

		disabledTitleColor = Colors.Button.titleWithFilledBackground
		disabledBorderColor = UIColor.clear
		disabledBackgroundColor = Colors.Button.backgroundFilledDisabled

		cornerRadius = 8.0

		edgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)

		hasBorders = false
		borderWidth = 1.0
		}
}

/// Tokens for the primaryOutline style in the FluentUI StyleSheet
public class ButtonVnextPrimaryOutlineTokens: ButtonVNextTokens {
	public var titleFont: Font

	public var titleColor: UIColor
	public var borderColor: UIColor
	public var backgroundColor: UIColor

	public var highlightedTitleColor: UIColor
	public var highlightedBorderColor: UIColor
	public var highlightedBackgroundColor: UIColor

	public var disabledTitleColor: UIColor
	public var disabledBorderColor: UIColor
	public var disabledBackgroundColor: UIColor

	public var cornerRadius: CGFloat

	public var edgeInsets: UIEdgeInsets

	public var hasBorders: Bool
	public var borderWidth: CGFloat

	public init() {
		titleFont = .headline

		titleColor = Colors.communicationBlue
		borderColor = Colors.Palette.communicationBlueTint20.color
		backgroundColor = UIColor.clear

		highlightedTitleColor = Colors.Palette.communicationBlueTint30.color
		highlightedBorderColor = Colors.Palette.communicationBlueTint30.color
		highlightedBackgroundColor = UIColor.clear

		disabledTitleColor = Colors.Button.titleDisabled
		disabledBorderColor = Colors.Button.borderDisabled
		disabledBackgroundColor = UIColor.clear

		cornerRadius = 8.0

		edgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)

		hasBorders = true
		borderWidth = 1.0
	}
}

/// Tokens for the secondaryOutline style in the FluentUI StyleSheet
public class ButtonVnextSecondaryOutlineTokens: ButtonVNextTokens {
	public var titleFont: Font

	public var titleColor: UIColor
	public var borderColor: UIColor
	public var backgroundColor: UIColor

	public var highlightedTitleColor: UIColor
	public var highlightedBorderColor: UIColor
	public var highlightedBackgroundColor: UIColor

	public var disabledTitleColor: UIColor
	public var disabledBorderColor: UIColor
	public var disabledBackgroundColor: UIColor

	public var cornerRadius: CGFloat

	public var edgeInsets: UIEdgeInsets

	public var hasBorders: Bool
	public var borderWidth: CGFloat

	public init() {
		titleFont = .footnote

		titleColor = Colors.communicationBlue
		borderColor = Colors.Palette.communicationBlueTint20.color
		backgroundColor = UIColor.clear

		highlightedTitleColor = Colors.Palette.communicationBlueTint30.color
		highlightedBorderColor = Colors.Palette.communicationBlueTint30.color
		highlightedBackgroundColor = UIColor.clear

		disabledTitleColor = Colors.Button.titleDisabled
		disabledBorderColor = Colors.Button.borderDisabled
		disabledBackgroundColor = UIColor.clear

		cornerRadius = 8.0

		edgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)

		hasBorders = true
		borderWidth = 1.0
	}
}

/// Tokens for the tertiaryOutline style in the FluentUI StyleSheet
public class ButtonVnextTertiaryOutlineTokens: ButtonVNextTokens {
	public var titleFont: Font

	public var titleColor: UIColor
	public var borderColor: UIColor
	public var backgroundColor: UIColor

	public var highlightedTitleColor: UIColor
	public var highlightedBorderColor: UIColor
	public var highlightedBackgroundColor: UIColor

	public var disabledTitleColor: UIColor
	public var disabledBorderColor: UIColor
	public var disabledBackgroundColor: UIColor

	public var cornerRadius: CGFloat

	public var edgeInsets: UIEdgeInsets

	public var hasBorders: Bool
	public var borderWidth: CGFloat

	public init() {
		titleFont = .footnote

		titleColor = Colors.communicationBlue
		borderColor = Colors.Palette.communicationBlueTint20.color
		backgroundColor = UIColor.clear

		highlightedTitleColor = Colors.Palette.communicationBlueTint30.color
		highlightedBorderColor = Colors.Palette.communicationBlueTint30.color
		highlightedBackgroundColor = UIColor.clear

		disabledTitleColor = Colors.Button.titleDisabled
		disabledBorderColor = Colors.Button.borderDisabled
		disabledBackgroundColor = UIColor.clear

		cornerRadius = 5.0

		edgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)

		hasBorders = true
		borderWidth = 1.0
	}
}

/// Tokens for the borderless style in the FluentUI StyleSheet
public class ButtonVnextBorderlessTokens: ButtonVNextTokens {
	public var titleFont: Font

	public var titleColor: UIColor
	public var borderColor: UIColor
	public var backgroundColor: UIColor

	public var highlightedTitleColor: UIColor
	public var highlightedBorderColor: UIColor
	public var highlightedBackgroundColor: UIColor

	public var disabledTitleColor: UIColor
	public var disabledBorderColor: UIColor
	public var disabledBackgroundColor: UIColor

	public var cornerRadius: CGFloat

	public var edgeInsets: UIEdgeInsets

	public var hasBorders: Bool
	public var borderWidth: CGFloat

	public init() {
		titleFont = .subheadline

		titleColor = Colors.communicationBlue
		borderColor = UIColor.clear
		backgroundColor = UIColor.clear

		highlightedTitleColor = Colors.Palette.communicationBlueTint30.color
		highlightedBorderColor = UIColor.clear
		highlightedBackgroundColor = UIColor.clear

		disabledTitleColor = Colors.Button.titleDisabled
		disabledBorderColor = UIColor.clear
		disabledBackgroundColor = UIColor.clear

		cornerRadius = 8.0

		edgeInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)

		hasBorders = false
		borderWidth = 1.0
	}
}

// - MARK: Teams Tokens (overrides only what's different from the default)

/// Tokens for the primaryFilled style in the Teams StyleSheet
public class ButtonVnextTeamsPrimaryFilledTokens: ButtonVnextPrimaryFilledTokens {
	public override init() {
		super.init()

		titleFont = .headline
		backgroundColor = UIColor(red: 0.310, green: 0.310, blue: 0.588, alpha: 1.0)
		highlightedBackgroundColor = UIColor(red: 0.310, green: 0.310, blue: 0.588, alpha: 0.8)
		cornerRadius = 0.0
		edgeInsets = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
		hasBorders = false
	}
}

/// Tokens for the primaryOutline style in the Teams StyleSheet
public class ButtonVnextTeamsPrimaryOutlineTokens: ButtonVnextPrimaryOutlineTokens {
	public override init() {
		super.init()

		titleFont = .subheadline
		titleColor = UIColor(red: 0.310, green: 0.310, blue: 0.588, alpha: 1.0)
		borderColor = UIColor(red: 0.310, green: 0.310, blue: 0.588, alpha: 0.8)
		cornerRadius = 0.0
		edgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
		hasBorders = true
	}
}

/// Tokens for the secondaryOutline style in the Teams StyleSheet
public class ButtonVnextTeamsSecondaryOutlineTokens: ButtonVnextSecondaryOutlineTokens {
	public override init() {
		super.init()

		titleFont = .caption
		titleColor = UIColor(red: 0.310, green: 0.310, blue: 0.588, alpha: 1.0)
		borderColor = UIColor(red: 0.310, green: 0.310, blue: 0.588, alpha: 0.8)
		cornerRadius = 0.0
		edgeInsets = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
		hasBorders = true
	}
}

/// Tokens for the tertiaryOutline style in the Teams StyleSheet
public class ButtonVnextTeamsTertiaryOutlineTokens: ButtonVnextTertiaryOutlineTokens {
	public override init() {
		super.init()

		titleFont = .caption
		titleColor = UIColor(red: 0.310, green: 0.310, blue: 0.588, alpha: 1.0)
		borderColor = UIColor(red: 0.310, green: 0.310, blue: 0.588, alpha: 0.8)
		cornerRadius = 0.0
		edgeInsets = UIEdgeInsets(top: 7, left: 9, bottom: 7, right: 9)
		hasBorders = true
	}
}

/// Tokens for the borderless style in the Teams StyleSheet
public class ButtonVnextTeamsBorderlessTokens: ButtonVnextBorderlessTokens {
	public override init() {
		super.init()

		titleFont = .headline
		titleColor = UIColor(red: 0.310, green: 0.310, blue: 0.588, alpha: 1.0)
		hasBorders = false
	}
}

// - MARK: Stylesheets (Group of design tokens per style)

/// Groups ButtonVNextTokens for each defined style.
public protocol StyleSheet {
	var buttonVnextTokens: [ButtonVnextStyle: ButtonVNextTokens] { get }
}

public class FluentStyleSheet: StyleSheet {
	public var buttonVnextTokens: [ButtonVnextStyle: ButtonVNextTokens] = [
		.primaryFilled: ButtonVnextPrimaryFilledTokens(),
		.primaryOutline: ButtonVnextPrimaryOutlineTokens(),
		.secondaryOutline: ButtonVnextSecondaryOutlineTokens(),
		.tertiaryOutline: ButtonVnextTertiaryOutlineTokens(),
		.borderless: ButtonVnextBorderlessTokens()]

	public init() {}
}

public class TeamsStyleSheet: StyleSheet {
	public var buttonVnextTokens: [ButtonVnextStyle: ButtonVNextTokens] = [
		.primaryFilled: ButtonVnextTeamsPrimaryFilledTokens(),
		.primaryOutline: ButtonVnextTeamsPrimaryOutlineTokens(),
		.secondaryOutline: ButtonVnextTeamsSecondaryOutlineTokens(),
		.tertiaryOutline: ButtonVnextTeamsTertiaryOutlineTokens(),
		.borderless: ButtonVnextTeamsBorderlessTokens()]

	public init() {}
}

// - MARK: Appearance Proxies

/// Source of design tokens to buttons at runtime. Each button style has its own singleton.
/// Once a property is changed on this instance, all associated buttons will automatically update their layout accordingly.
public class ButtonVnextAppearanceProxy: ObservableObject {

@Published public var titleFont: Font!

@Published public var titleColor: UIColor!
@Published public var borderColor: UIColor!
@Published public var backgroundColor: UIColor!

@Published public var highlightedTitleColor: UIColor!
@Published public var highlightedBorderColor: UIColor!
@Published public var highlightedBackgroundColor: UIColor!

@Published public var disabledTitleColor: UIColor!
@Published public var disabledBorderColor: UIColor!
@Published public var disabledBackgroundColor: UIColor!

@Published public var cornerRadius: CGFloat!

@Published public var edgeInsets: UIEdgeInsets!

@Published public var hasBorders: Bool!
@Published public var borderWidth: CGFloat!

public init(tokens: ButtonVNextTokens) {
	applyTokens(tokens: tokens)
}

public func applyTokens(tokens: ButtonVNextTokens) {
	titleFont = tokens.titleFont

	titleColor = tokens.titleColor
	borderColor = tokens.borderColor
	backgroundColor = tokens.backgroundColor

	highlightedTitleColor = tokens.highlightedTitleColor
	highlightedBorderColor = tokens.highlightedBorderColor
	highlightedBackgroundColor = tokens.highlightedBackgroundColor

	disabledTitleColor = tokens.disabledTitleColor
	disabledBorderColor = tokens.disabledBorderColor
	disabledBackgroundColor = tokens.disabledBackgroundColor

	cornerRadius = tokens.cornerRadius

	edgeInsets = tokens.edgeInsets

	hasBorders = tokens.hasBorders
	borderWidth = tokens.borderWidth
	}
}

/// Holds a sigle instance of an Appearance Proxy for each control style (currently just the button).
/// A Theme groups Appearance Proxies just like a StyleSheet groups Tokens
public class Theme: NSObject {
	private var buttonVnextAppearanceProxies: [ButtonVnextStyle: ButtonVnextAppearanceProxy] = [
																			 .primaryFilled: ButtonVnextAppearanceProxy(tokens: ButtonVnextPrimaryFilledTokens()),
																			 .primaryOutline: ButtonVnextAppearanceProxy(tokens: ButtonVnextPrimaryOutlineTokens()),
																			 .secondaryOutline: ButtonVnextAppearanceProxy(tokens: ButtonVnextSecondaryOutlineTokens()),
																			 .tertiaryOutline: ButtonVnextAppearanceProxy(tokens: ButtonVnextTertiaryOutlineTokens()),
																			 .borderless: ButtonVnextAppearanceProxy(tokens: ButtonVnextBorderlessTokens())]

	public func buttonAppearanceProxyFor(style: ButtonVnextStyle) -> ButtonVnextAppearanceProxy? {
		return buttonVnextAppearanceProxies[style]
	}

	public func applyStyleSheet(styleSheet: StyleSheet) {
		for (style, appearanceProxy) in styleSheet.buttonVnextTokens {
			if let ap = buttonAppearanceProxyFor(style: style) {
				ap.applyTokens(tokens: appearanceProxy)
			}
		}
	}
}

/// Main singleton that holds the current theme serving all controls on the application
public class StylesheetManager: NSObject {
	public static let `default`: StylesheetManager = StylesheetManager()
	public static var currentTheme = Theme()

	private override init() {
		super.init()
	}
}
