//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import XCTest
@testable import FluentUI_macos

class GlassButtonTests: XCTestCase {
	func testSingleAccessibleButton() {
		let button = makeButton()

		for trailingImage in [nil, makeImage(description: "Chevron"), nil] {
			button.trailingImage = trailingImage

			XCTAssertTrue(button.isAccessibilityElement())
			XCTAssertEqual(button.accessibilityRole(), .button)
			XCTAssertTrue((NSAccessibility.unignoredDescendant(of: button) as? NSView) === button)
			XCTAssertTrue(button.accessibilityChildren()?.isEmpty ?? true)
			XCTAssertTrue(button.subviews.filter { $0 is NSImageView || $0 is NSTextField }.allSatisfy {
				!$0.isAccessibilityElement()
			})
		}
	}

	func testDecorativeContentIsIgnoredByWindowHitTesting() throws {
		let button = makeButton()
		let window = NSWindow(
			contentRect: NSRect(x: 100, y: 100, width: 320, height: 120),
			styleMask: [.titled],
			backing: .buffered,
			defer: false
		)
		window.isReleasedWhenClosed = false
		let contentView = try XCTUnwrap(window.contentView)
		contentView.addSubview(button)
		button.setFrameOrigin(NSPoint(x: 20, y: 20))
		window.orderBack(nil)
		defer { window.orderOut(nil) }

		for trailingImage in [makeImage(description: "Chevron"), makeImage(description: "Menu"), nil, makeImage(description: "Chevron")] {
			button.trailingImage = trailingImage

			for imagePosition: NSControl.ImagePosition in [.imageLeading, .imageOnly] {
				button.imagePosition = imagePosition
				button.setFrameSize(button.intrinsicContentSize)
				button.layoutSubtreeIfNeeded()

				let decorativeViews = button.subviews.filter { $0 is NSImageView || $0 is NSTextField }
				if #available(macOS 26.0, *), trailingImage != nil {
					XCTAssertEqual(decorativeViews.count, 3)
				}
				for view in decorativeViews {
					XCTAssertNil(NSAccessibility.unignoredDescendant(of: view), "\(type(of: view)) exposes an accessibility descendant")
					if !view.isHidden {
						XCTAssertFalse(view.bounds.isEmpty)
						let center = NSPoint(x: view.bounds.midX, y: view.bounds.midY)
						let screenPoint = window.convertPoint(toScreen: view.convert(center, to: nil))
						XCTAssertTrue(
							(window.accessibilityHitTest(screenPoint) as? NSView) === button,
							"Hit-testing \(type(of: view)) should return the button"
						)
					}
				}
			}
		}
	}

	func testLabelFollowsTitleAndLayoutChanges() {
		let button = makeButton()
		XCTAssertEqual(button.accessibilityLabel(), "Share")

		button.trailingImage = makeImage(description: "Chevron")
		XCTAssertEqual(button.accessibilityLabel(), "Share")

		button.title = "Share document"
		XCTAssertEqual(button.accessibilityLabel(), "Share document")

		button.imagePosition = .imageOnly
		XCTAssertEqual(button.accessibilityLabel(), "Share document")

		button.imagePosition = .imageLeading
		button.trailingImage = nil
		XCTAssertEqual(button.accessibilityLabel(), "Share document")

		button.trailingImage = makeImage(description: "Chevron")
		XCTAssertEqual(button.accessibilityLabel(), "Share document")
	}

	func testImageOnlyLabelFollowsImageDescription() {
		let button = makeButton()
		button.title = ""
		button.imagePosition = .imageOnly
		button.image = makeImage(description: "Share document")
		button.trailingImage = makeImage(description: "Chevron")
		XCTAssertEqual(button.accessibilityLabel(), "Share document")

		button.image = makeImage(description: "More options")
		XCTAssertEqual(button.accessibilityLabel(), "More options")

		button.image?.accessibilityDescription = "Additional options"
		XCTAssertEqual(button.accessibilityLabel(), "Additional options")

		button.trailingImage = nil
		XCTAssertEqual(button.accessibilityLabel(), "Additional options")
	}

	func testExplicitLabelSurvivesContentAndLayoutChanges() {
		let button = makeButton()
		button.setAccessibilityLabel("Sharing options")
		button.trailingImage = makeImage(description: "Chevron")
		button.title = "Share document"
		button.image = makeImage(description: "Share icon")
		button.imagePosition = .imageOnly
		XCTAssertEqual(button.accessibilityLabel(), "Sharing options")

		button.trailingImage = nil
		XCTAssertEqual(button.accessibilityLabel(), "Sharing options")

		button.setAccessibilityLabel("")
		XCTAssertEqual(button.accessibilityLabel(), "")

		button.trailingImage = makeImage(description: "Chevron")
		button.setAccessibilityLabel(nil)
		XCTAssertEqual(button.accessibilityLabel(), "Share document")

		button.title = ""
		XCTAssertEqual(button.accessibilityLabel(), "Share icon")
	}

	func testAccessibilityMetadataIsPreserved() {
		let button = makeButton()
		button.toolTip = "Share this document"
		button.setAccessibilityIdentifier("shareButton")
		button.setAccessibilityHelp("Choose who can access this document")
		button.setAccessibilityTitle("Document sharing")

		for trailingImage in [nil, makeImage(description: "Chevron"), nil] {
			button.trailingImage = trailingImage
			XCTAssertEqual(button.accessibilityIdentifier(), "shareButton")
			XCTAssertEqual(button.accessibilityHelp(), "Choose who can access this document")
			XCTAssertEqual(button.accessibilityTitle(), "Document sharing")
		}
	}

	func testPressAndDisabledState() {
		let button = makeButton()
		let receiver = ActionReceiver()
		button.target = receiver
		button.action = #selector(ActionReceiver.press(_:))

		for trailingImage in [nil, makeImage(description: "Chevron"), nil] {
			button.trailingImage = trailingImage
			button.isEnabled = true
			XCTAssertTrue(button.isAccessibilityEnabled())
			let previousCount = receiver.pressCount
			_ = button.accessibilityPerformPress()
			XCTAssertEqual(receiver.pressCount, previousCount + 1)
			XCTAssertTrue(receiver.lastSender === button)

			button.isEnabled = false
			XCTAssertFalse(button.isAccessibilityEnabled())
			_ = button.accessibilityPerformPress()
			XCTAssertEqual(receiver.pressCount, previousCount + 1)
		}
	}

	private func makeButton() -> GlassButton {
		_ = NSApplication.shared
		return GlassButton(title: "Share", image: makeImage(description: "Share icon"))
	}

	private func makeImage(description: String) -> NSImage {
		let image = NSImage(size: NSSize(width: 16, height: 16))
		image.accessibilityDescription = description
		return image
	}
}

private class ActionReceiver: NSObject {
	var pressCount: Int = 0
	weak var lastSender: NSButton?

	@objc func press(_ sender: NSButton) {
		pressCount += 1
		lastSender = sender
	}
}
