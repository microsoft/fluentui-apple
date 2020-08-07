//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public class ButtonVnextState: ObservableObject {
	@Published var title: String = ""
	@Published var isDisabled: Bool = false
}

public struct ButtonVnextViewButtonStyle: ButtonStyle {
	var targetButton: ButtonVnextView

	public init(targetButton: ButtonVnextView) {
		self.targetButton = targetButton
	}

	public func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.foregroundColor(Color(targetButton.state.isDisabled ?
									targetButton.tokens.disabledTitleColor :
									(configuration.isPressed ?
										targetButton.tokens.highlightedTitleColor :
										targetButton.tokens.titleColor)))
			.background(targetButton.tokens.hasBorders ?
				AnyView(RoundedRectangle(cornerRadius: targetButton.tokens.cornerRadius)
					.strokeBorder(lineWidth: targetButton.tokens.borderWidth, antialiased: false)
					.foregroundColor(Color(targetButton.state.isDisabled ?
											targetButton.tokens.disabledBorderColor :
											(configuration.isPressed ?
												targetButton.tokens.highlightedBorderColor :
												targetButton.tokens.borderColor)))) :
				AnyView(RoundedRectangle(cornerRadius: targetButton.tokens.cornerRadius)
					.fill(Color(targetButton.state.isDisabled ?
									targetButton.tokens.disabledBackgroundColor :
									(configuration.isPressed ?
										targetButton.tokens.highlightedBackgroundColor :
										targetButton.tokens.backgroundColor))))
				)
	}
}

public struct ButtonVnextView: View {
	var action: () -> Void
	@ObservedObject var tokens: ButtonVnextAppearanceProxy
	@ObservedObject var state: ButtonVnextState

	public init(action: @escaping () -> Void, style: ButtonVnextStyle) {
		self.action = action
		self.tokens = StylesheetManager.currentTheme.buttonAppearanceProxyFor(style: style) ?? ButtonVnextAppearanceProxy(tokens: ButtonVnextPrimaryFilledTokens())
		self.state = ButtonVnextState()
	}

	public var body: some View {
		Button(action: action) {
			Text(state.title)
				.font(tokens.titleFont)
				.fontWeight(.medium)
				.padding(EdgeInsets(top: tokens.edgeInsets.top,
									leading: tokens.edgeInsets.left,
									bottom: tokens.edgeInsets.bottom,
									trailing: tokens.edgeInsets.right))
		}
			.buttonStyle(ButtonVnextViewButtonStyle(targetButton: self))
			.disabled(state.isDisabled)
			.fixedSize()
	}
}

@objc(MSFButtonVnext)
open class ButtonVnext: UIHostingController<ButtonVnextView> {

	@objc open var buttonTitle: String = "" {
		didSet {
			self.rootView.state.title = buttonTitle
		}
	}

	open var isDisabled: Bool = false {
		didSet {
			self.rootView.state.isDisabled = isDisabled
		}
	}

	@objc public init(style: ButtonVnextStyle = .secondaryOutline, action: @escaping () -> Void) {
		super.init(rootView: ButtonVnextView(action: action, style: style))
		self.view.backgroundColor = UIColor.clear
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
