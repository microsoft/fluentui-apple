//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

/// Note: SWIFT_PACKAGE is automatically defined whenever the code is being built by the Swift Package Manager.
#if SWIFT_PACKAGE
import FluentUIResources
#endif
import AppKit

/// A class for accessing the bundle and resource bundle associated with the FluentUI Framework
public class FluentUIResources: NSObject {
	/// The bundle of the FluentUI framework
	static var bundle: Bundle { return Bundle(for: self) }

	/// The resource bundle contained within the FluentUI framework
	@objc public static let resourceBundle: Bundle = {
		#if SWIFT_PACKAGE
		return Bundle.module
		#else
		guard let url = bundle.resourceURL?.appendingPathComponent("FluentUIResources-macos.bundle", isDirectory: true), let bundle = Bundle(url: url) else {
			preconditionFailure("FluentUI resource bundle is not found")
		}

		return bundle
		#endif
	}()

    /// The resource bundle that points to our common color definitions
	@objc public static let colorsBundle: Bundle = {
        #if SWIFT_PACKAGE
        return SharedResources.colorsBundle
        #else
        return resourceBundle
        #endif
    }()
}
