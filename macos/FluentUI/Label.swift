//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

@objc(MSFTextStyle)
public enum TextStyle: Int, CaseIterable {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption1
    case caption2
	
	public func font() -> NSFont
	{
		switch self {
		case .largeTitle:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .largeTitle)
			} else {
				return NSFont.systemFont(ofSize: 26, weight: .regular)
			}
		case .title1:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .title1)
			} else {
				return NSFont.systemFont(ofSize: 22, weight: .regular)
			}
		case .title2:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .title2)
			} else {
				return NSFont.systemFont(ofSize: 17, weight: .regular)
			}
		case .title3:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .title3)
			} else {
				return NSFont.systemFont(ofSize: 15, weight: .regular)
			}
		case .headline:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .headline)
			} else {
				return NSFont.systemFont(ofSize: 13, weight: .black)
			}
		case .body:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .body)
			} else {
				return NSFont.systemFont(ofSize: 13, weight: .regular)
			}
		case .callout:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .callout)
			} else {
				return NSFont.systemFont(ofSize: 12, weight: .regular)
			}
		case .subheadline:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .subheadline)
			} else {
				return NSFont.systemFont(ofSize: 11, weight: .regular)
			}
		case .footnote:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .footnote)
			} else {
				return NSFont.systemFont(ofSize: 10, weight: .regular)
			}
		case .caption1:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .caption1)
			} else {
				return NSFont.systemFont(ofSize:10, weight: .regular)
			}
		case .caption2:
			if #available(macOS 11.0, *) {
				return NSFont.preferredFont(forTextStyle: .caption2)
			} else {
				return NSFont.systemFont(ofSize: 10, weight: .medium)
			}
		}
	}
}

public func Label(withString string: String, forTextStyle TextStyle: TextStyle) -> NSTextField {
	let label = NSTextField(labelWithString: string)
	label.font = TextStyle.font()
	return label
}
