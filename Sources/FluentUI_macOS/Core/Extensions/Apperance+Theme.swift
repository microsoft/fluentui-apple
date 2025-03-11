//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

extension NSAppearance {
	var isDarkMode: Bool {
		return self.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
	}
}
