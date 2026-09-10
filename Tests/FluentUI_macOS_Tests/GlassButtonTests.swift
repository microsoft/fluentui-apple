//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit
import XCTest
@testable import FluentUI_macos

class GlassButtonTests: XCTestCase {
	func testIconOnlySystemButtonUsesCompactPadding() throws {
		guard #available(macOS 26.0, *) else {
			throw XCTSkip("System glass requires macOS 26.")
		}

		let button = makeButton()
		let image = makeImage(description: "Search")
		image.size = NSSize(width: 20, height: 20)
		button.image = image
		button.title = ""

		for imagePosition: NSControl.ImagePosition in [.imageLeading, .imageOnly] {
			button.imagePosition = imagePosition
			XCTAssertEqual(button.intrinsicContentSize, NSSize(width: 28, height: 28))
		}

		button.title = "Search"
		button.imagePosition = .imageOnly
		XCTAssertEqual(button.intrinsicContentSize, NSSize(width: 28, height: 28))

		button.title = ""
		button.image = nil
		XCTAssertEqual(button.intrinsicContentSize.width, 16)
	}

	func testSystemButtonKeepsStandardPaddingForTitleOrChevron() throws {
		guard #available(macOS 26.0, *) else {
			throw XCTSkip("System glass requires macOS 26.")
		}

		let button = makeButton()
		let image = makeImage(description: "Share")
		image.size = NSSize(width: 20, height: 20)
		button.image = image
		let font = try XCTUnwrap(button.font)
		let titleWidth = button.title.size(withAttributes: [.font: font]).width
		XCTAssertEqual(button.intrinsicContentSize.width, ceil(20 + 4 + titleWidth + 16))

		button.trailingImage = makeImage(description: "Chevron")
		button.title = ""
		XCTAssertEqual(button.intrinsicContentSize.width, 20 + 4 + 16 + 16)

		button.imagePosition = .imageOnly
		XCTAssertEqual(button.intrinsicContentSize.width, 20 + 4 + 16 + 16)

		button.trailingImage = nil
		XCTAssertEqual(button.intrinsicContentSize, NSSize(width: 28, height: 28))

		button.title = "Share"
		button.imagePosition = .imageLeading
		XCTAssertEqual(button.intrinsicContentSize.width, ceil(20 + 4 + titleWidth + 16))

		button.imagePosition = .noImage
		XCTAssertEqual(button.intrinsicContentSize.width, ceil(titleWidth + 16))
	}

	func testCustomContentImagePositionControlsLayout() throws {
		guard #available(macOS 26.0, *) else {
			throw XCTSkip("System glass requires macOS 26.")
		}

		let button = makeButton()
		button.trailingImage = makeImage(description: "Chevron")

		for imagePosition: NSControl.ImagePosition in [.imageLeading, .noImage, .imageOnly, .imageLeading, .noImage] {
			button.imagePosition = imagePosition
			try assertCustomContentLayout(
				button,
				imageIsHidden: imagePosition == .noImage,
				titleIsHidden: imagePosition == .imageOnly
			)
		}
	}

	func testNoImageSurvivesCustomContentChanges() throws {
		guard #available(macOS 26.0, *) else {
			throw XCTSkip("System glass requires macOS 26.")
		}

		let button = makeButton()
		button.imagePosition = .noImage
		button.trailingImage = makeImage(description: "Chevron")
		try assertCustomContentLayout(button, imageIsHidden: true, titleIsHidden: false)

		for image in [makeImage(description: "Replacement"), nil, makeImage(description: "Restored")] {
			button.image = image
			try assertCustomContentLayout(button, imageIsHidden: true, titleIsHidden: false)
		}

		button.title = "Sharing options"
		try assertCustomContentLayout(button, imageIsHidden: true, titleIsHidden: false)

		button.trailingImage = nil
		button.trailingImage = makeImage(description: "Menu")
		try assertCustomContentLayout(button, imageIsHidden: true, titleIsHidden: false)

		button.imagePosition = .imageLeading
		try assertCustomContentLayout(button, imageIsHidden: false, titleIsHidden: false)

		button.image = nil
		try assertCustomContentLayout(button, imageIsHidden: true, titleIsHidden: false)
		button.image = makeImage(description: "Share icon")
		try assertCustomContentLayout(button, imageIsHidden: false, titleIsHidden: false)
	}

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

			for imagePosition: NSControl.ImagePosition in [.imageLeading, .noImage, .imageOnly] {
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

	private func assertCustomContentLayout(
		_ button: GlassButton,
		imageIsHidden: Bool,
		titleIsHidden: Bool,
		file: StaticString = #filePath,
		line: UInt = #line
	) throws {
		let imageViews = button.subviews.compactMap { $0 as? NSImageView }
		let imageView = try XCTUnwrap(imageViews.first { $0.image === button.image }, file: file, line: line)
		let trailingImageView = try XCTUnwrap(imageViews.first { $0.image === button.trailingImage }, file: file, line: line)
		let label = try XCTUnwrap(button.subviews.compactMap { $0 as? NSTextField }.first, file: file, line: line)
		let cell = try XCTUnwrap(button.cell as? ButtonCell, file: file, line: line)
		button.setFrameSize(button.intrinsicContentSize)
		button.layoutSubtreeIfNeeded()

		XCTAssertEqual(imageView.isHidden, imageIsHidden, file: file, line: line)
		XCTAssertEqual(label.isHidden, titleIsHidden, file: file, line: line)
		XCTAssertFalse(trailingImageView.isHidden, file: file, line: line)
		if !titleIsHidden {
			let imageRect = imageView.alignmentRect(forFrame: imageView.frame)
			let titleRect = label.alignmentRect(forFrame: label.frame)
			let trailingImageRect = trailingImageView.alignmentRect(forFrame: trailingImageView.frame)
			let expectedLeading = imageIsHidden ? cell.horizontalPadding : imageRect.maxX + cell.titleToImageSpacing
			XCTAssertEqual(titleRect.minX, expectedLeading, accuracy: 0.01, file: file, line: line)
			XCTAssertLessThanOrEqual(titleRect.maxX + cell.titleToImageSpacing, trailingImageRect.minX + 0.01, file: file, line: line)
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
