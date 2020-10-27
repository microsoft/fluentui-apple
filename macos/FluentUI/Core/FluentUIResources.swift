//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit


/// A class for accessing the bundle and resource bundle associated with the FluentUI Framework
class FluentUIResources: NSObject {
	
	/// The bundle of the FluentUI framework
	static let resourceBundle: Bundle = {
		return Bundle(for: FluentUIResources.self)
	}()
}
