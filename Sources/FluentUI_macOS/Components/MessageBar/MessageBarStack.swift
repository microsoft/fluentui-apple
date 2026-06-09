//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import SwiftUI

public class MessageBarStackViewModel: ObservableObject {
	public struct BarItem: Identifiable {
		public let id: Int
		public let configuration: MessageBarConfiguration
		public var isVisible: Bool = false
	}

	public init(bars: [BarItem]? = nil) {
		self.bars = bars ?? []
	}

	@Published public var bars: [BarItem] = []

	/// When `true`, the stack draws a 1pt divider line above the topmost visible
	/// bar. Inter-bar dividers between adjacent visible bars are always drawn.
	/// Defaults to `true`.
	@Published public var drawsTopDivider: Bool = true

	public var targetContentHeight: CGFloat {
		let visibleCount = bars.filter { $0.isVisible }.count
		return CGFloat(visibleCount) * MessageBar.fixedHeight
	}
}

public struct MessageBarStack: View {
	@ObservedObject public var viewModel: MessageBarStackViewModel

	public var body: some View {
		let visibleBars = viewModel.bars.filter { $0.isVisible }
		VStack(spacing: 0) {
			ForEach(Array(visibleBars.enumerated()), id: \.element.id) { index, bar in
				MessageBar(bar.configuration)
					.overlay(alignment: .top) {
						// Inter-bar dividers are drawn unconditionally; the topmost
						// bar's divider is gated on `drawsTopDivider`.
						if index > 0 || viewModel.drawsTopDivider {
							Rectangle()
								.fill(tokenSet[.dividerColor].color)
								.frame(height: 1.0)
						}
					}
			}
		}
	}

	private let tokenSet: MessageBarTokenSet = .init()
}
