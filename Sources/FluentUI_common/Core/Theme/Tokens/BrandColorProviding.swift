//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if os(iOS) || os(visionOS)
import UIKit
public typealias PlatformColor = UIColor
#elseif os(macOS)
import AppKit
public typealias PlatformColor = NSColor
#endif

// MARK: ColorProviding

/// Protocol through which consumers can provide brand colors to "theme" their experiences
/// If this protocol is not conformed to, communicationBlue variants will be used
@objc(MSFBrandColorProviding)
public protocol BrandColorProviding {
    // MARK: - Brand Colors Palette

    @objc var brand10: PlatformColor { get }
    @objc var brand20: PlatformColor { get }
    @objc var brand30: PlatformColor { get }
    @objc var brand40: PlatformColor { get }
    @objc var brand50: PlatformColor { get }
    @objc var brand60: PlatformColor { get }
    @objc var brand70: PlatformColor { get }
    @objc var brand80: PlatformColor { get }
    @objc var brand90: PlatformColor { get }
    @objc var brand100: PlatformColor { get }
    @objc var brand110: PlatformColor { get }
    @objc var brand120: PlatformColor { get }
    @objc var brand130: PlatformColor { get }
    @objc var brand140: PlatformColor { get }
    @objc var brand150: PlatformColor { get }
    @objc var brand160: PlatformColor { get }
}
