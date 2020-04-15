//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AppKit

/// A class for accessing the bundle and resource bundle associated with the FluentUI Framework
public class FluentUIResources: NSObject {
	/// The bundle of the FluentUI framework
	static var bundle: Bundle { return Bundle(for: self) }
	
	/// The resource bundle contained within the FluentUI framework
	@objc public static let resourceBundle: Bundle = {
		guard let url = bundle.resourceURL?.appendingPathComponent("FluentUIResources-macos.bundle", isDirectory: true), let bundle = Bundle(url: url) else {
			preconditionFailure("FluentUI resource bundle is not found")
		}
		
		return bundle
	}()
}
