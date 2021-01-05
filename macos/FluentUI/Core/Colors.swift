//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

// MARK: Colors

@objc(MSFColors)
public final class Colors: NSObject {
	// MARK: - MSFColorPalette
	
	/// colors defined in asset catalog
	@objc(MSFColorPalette)
	public enum Palette: Int {
		case pinkRed10
		case red20
		case red10
		case orange30
		case orange20
		case orangeYellow20
		case green20
		case green10
		case cyan30
		case cyan20
		case cyanBlue20
		case cyanBlue10
		case blue10
		case blueMagenta30
		case blueMagenta20
		case magenta20
		case magenta10
		case magentaPink10
		case gray950
		case gray900
		case gray800
		case gray700
		case gray600
		case gray500
		case gray400
		case gray300
		case gray200
		case gray100
		case gray50
		case gray40
		case gray30
		case gray25
		case gray20
		case communicationBlue
		case communicationBlueTint40
		case communicationBlueTint30
		case communicationBlueTint20
		case communicationBlueTint10
		case communicationBlueShade30
		case communicationBlueShade20
		case communicationBlueShade10
		case dangerPrimary
		case dangerTint40
		case dangerTint30
		case dangerTint20
		case dangerTint10
		case dangerShade30
		case dangerShade20
		case dangerShade10
		case warningPrimary
		case warningTint40
		case warningTint30
		case warningTint20
		case warningTint10
		case warningShade30
		case warningShade20
		case warningShade10
		case successPrimary
		case successTint40
		case successTint30
		case successTint20
		case successTint10
		case successShade30
		case successShade20
		case successShade10
		case presenceAvailable
		case presenceAway
		case presenceBlocked
		case presenceBusy
		case presenceDnd
		case presenceOffline
		case presenceOof
		case presenceUnknown
		
		public var color: NSColor {
			if let fluentColor = NSColor(named: "FluentColors/" + self.name, bundle: FluentUIResources.resourceBundle) {
				return fluentColor
			} else {
				preconditionFailure("invalid fluent color")
			}
		}
		
		public var name: String {
			switch self {
			case .pinkRed10:
				return "pinkRed10"
			case .red20:
				return "red20"
			case .red10:
				return "red10"
			case .orange30:
				return "orange30"
			case .orange20:
				return "orange20"
			case .orangeYellow20:
				return "orangeYellow20"
			case .green20:
				return "green20"
			case .green10:
				return "green10"
			case .cyan30:
				return "cyan30"
			case .cyan20:
				return "cyan20"
			case .cyanBlue20:
				return "cyanBlue20"
			case .cyanBlue10:
				return "cyanBlue10"
			case .blue10:
				return "blue10"
			case .blueMagenta30:
				return "blueMagenta30"
			case .blueMagenta20:
				return "blueMagenta20"
			case .magenta20:
				return "magenta20"
			case .magenta10:
				return "magenta10"
			case .magentaPink10:
				return "magentaPink10"
			case .gray950:
				return "gray950"
			case .gray900:
				return "gray900"
			case .gray800:
				return "gray800"
			case .gray700:
				return "gray700"
			case .gray600:
				return "gray600"
			case .gray500:
				return "gray500"
			case .gray400:
				return "gray400"
			case .gray300:
				return "gray300"
			case .gray200:
				return "gray200"
			case .gray100:
				return "gray100"
			case .gray50:
				return "gray50"
			case .gray40:
				return "gray40"
			case .gray30:
				return "gray30"
			case .gray25:
				return "gray25"
			case .gray20:
				return "gray20"
			case .communicationBlue:
				return "communicationBlue"
			case .communicationBlueTint40:
				return "communicationBlueTint40"
			case .communicationBlueTint30:
				return "communicationBlueTint30"
			case .communicationBlueTint20:
				return "communicationBlueTint20"
			case .communicationBlueTint10:
				return "communicationBlueTint10"
			case .communicationBlueShade30:
				return "communicationBlueShade30"
			case .communicationBlueShade20:
				return "communicationBlueShade20"
			case .communicationBlueShade10:
				return "communicationBlueShade10"
			case .dangerPrimary:
				return "dangerPrimary"
			case .dangerTint40:
				return "dangerTint40"
			case .dangerTint30:
				return "dangerTint30"
			case .dangerTint20:
				return "dangerTint20"
			case .dangerTint10:
				return "dangerTint10"
			case .dangerShade30:
				return "dangerShade30"
			case .dangerShade20:
				return "dangerShade20"
			case .dangerShade10:
				return "dangerShade10"
			case .warningPrimary:
				return "warningPrimary"
			case .warningTint40:
				return "warningTint40"
			case .warningTint30:
				return "warningTint30"
			case .warningTint20:
				return "warningTint20"
			case .warningTint10:
				return "warningTint10"
			case .warningShade30:
				return "warningShade30"
			case .warningShade20:
				return "warningShade20"
			case .warningShade10:
				return "warningShade10"
			case .successPrimary:
				return "successPrimary"
			case .successTint40:
				return "successTint40"
			case .successTint30:
				return "successTint30"
			case .successTint20:
				return "successTint20"
			case .successTint10:
				return "successTint10"
			case .successShade30:
				return "successShade30"
			case .successShade20:
				return "successShade20"
			case .successShade10:
				return "successShade10"
			case .presenceAvailable:
				return "presenceAvailable"
			case .presenceAway:
				return "presenceAway"
			case .presenceBlocked:
				return "presenceBlocked"
			case .presenceBusy:
				return "presenceBusy"
			case .presenceDnd:
				return "presenceDnd"
			case .presenceOffline:
				return "presenceOffline"
			case .presenceOof:
				return "presenceOof"
			case .presenceUnknown:
				return "presenceUnknown"
			}
		}
	}

	/// Allows Objective-C to get `NSColor` objects from `Palette` values.
	/// - Parameter palette: The `Palette` enum value.
	/// - Returns: The `NSColor` for the given `palette` value.
	/// # Example #
	/// `NSColor *communicationBlue = [MSFColors colorFrom:MSFColorPaletteCommunicationBlue];`
	@objc public static func colorFrom(_ palette: Palette) -> NSColor {
		return palette.color
	}

	// MARK: Primary
	
	@objc public static var primary: NSColor = Colors.Palette.communicationBlue.color
	
	@objc public static var primaryTint10: NSColor = Colors.Palette.communicationBlueTint10.color
	
	@objc public static var primaryTint20: NSColor = Colors.Palette.communicationBlueTint20.color
	
	@objc public static var primaryTint30: NSColor = Colors.Palette.communicationBlueTint30.color
	
	@objc public static var primaryTint40: NSColor = Colors.Palette.communicationBlueTint40.color
	
	@objc public static var primaryShade10: NSColor = Colors.Palette.communicationBlueShade10.color
	
	@objc public static var primaryShade20: NSColor = Colors.Palette.communicationBlueShade20.color
	
	@objc public static var primaryShade30: NSColor = Colors.Palette.communicationBlueShade30.color
}

/// Make palette enum CaseIterable for unit testing purposes
extension Colors.Palette: CaseIterable {}
