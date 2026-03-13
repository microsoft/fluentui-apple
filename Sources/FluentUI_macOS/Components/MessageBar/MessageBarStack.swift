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

	public var targetContentHeight: CGFloat {
		let visibleCount = bars.filter { $0.isVisible }.count
		return CGFloat(visibleCount) * MessageBar.fixedHeight
	}
}

public struct MessageBarStack: View {
	@ObservedObject public var viewModel: MessageBarStackViewModel

	public var body: some View {
		VStack(spacing: 0) {
			ForEach(viewModel.bars.filter { $0.isVisible }) { bar in
				MessageBar(bar.configuration)
			}
		}
	}
}
