//
// Copyright Microsoft Corporation
//

import AppKit

/// A scroll view that recenters its clip view when it hits the left or right edge of its document view
class DatePickerScrollView: NSScrollView {
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		
		wantsLayer = true
		translatesAutoresizingMaskIntoConstraints = false
		borderType = .noBorder
		hasVerticalScroller = false
		hasHorizontalScroller = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Disables mouse scrolling and unwanted clipView offset changes in RTL
	override func scroll(_ clipView: NSClipView, to point: NSPoint) {
		super.scroll(clipView, to: .zero)
	}
	
	func animateScroll(to point: NSPoint, duration: Double) {
		isAnimating = true
		
		NSAnimationContext.runAnimationGroup({ context in
			context.duration = duration
			contentView.animator().setBoundsOrigin(point)
		}, completionHandler: {
			self.isAnimating = false
			self.recenterIfNeeded()
		})
	}
	
	weak var delegate: DatePickerScrollViewDelegate?
	
	private(set) var isAnimating = false
	
	/// Checks distance of the documentVisibleRect to both edges and recenters the clip view if needed
	private func recenterIfNeeded() {
		guard let documentView = documentView, contentView.bounds.origin != .zero else {
			return
		}
		
		let leftEdgeDist = abs(documentVisibleRect.minX - documentView.bounds.minX)
		let rightEdgeDist = abs(documentVisibleRect.maxX - documentView.bounds.maxX)
		
		if leftEdgeDist == 0 {
			contentView.bounds.origin = .zero
			delegate?.datePickerScrollViewDidRecenterFromLeft(self)
		} else if rightEdgeDist == 0 {
			contentView.bounds.origin = .zero
			delegate?.datePickerScrollViewDidRecenterFromRight(self)
		}
	}
}

protocol DatePickerScrollViewDelegate: class {
	
	/// Tells the delegate that the scroll view recentered from the right.
	///
	/// - Parameter scrollView: The scroll view.
	func datePickerScrollViewDidRecenterFromRight(_ scrollView: DatePickerScrollView)
	
	/// Tells the delegate that the scroll view recentered from the left.
	///
	/// - Parameter scrollView: The scroll view.
	func datePickerScrollViewDidRecenterFromLeft(_ scrollView: DatePickerScrollView)
}

/// Default delegate implementation
extension DatePickerScrollViewDelegate {
	
	func datePickerScrollViewDidRecenterFromRight(_ scrollView: DatePickerScrollView) {}
	
	func datePickerScrollViewDidRecenterFromLeft(_ scrollView: DatePickerScrollView) {}
}
