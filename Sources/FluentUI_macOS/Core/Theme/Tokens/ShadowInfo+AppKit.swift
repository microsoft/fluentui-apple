//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI
import AppKit

public extension ShadowInfo {
    /// Creates an NSShadow from the `key` elements of this instance.
    @objc var keyShadow: NSShadow {
        let dropShadow = NSShadow()
        dropShadow.shadowColor = NSColor(keyColor)
        // NSShadow offsets are inverted from our global values
        dropShadow.shadowOffset = CGSizeMake(-xKey, -yKey)
        dropShadow.shadowBlurRadius = keyBlur
        return dropShadow
    }

    /// Creates an NSShadow from the `ambient` elements of this instance.
    @objc var ambientShadow: NSShadow {
        let dropShadow = NSShadow()
        dropShadow.shadowColor = NSColor(ambientColor)
        // NSShadow offsets are inverted from our global values
        dropShadow.shadowOffset = CGSizeMake(-xAmbient, -yAmbient)
        dropShadow.shadowBlurRadius = ambientBlur
        return dropShadow
    }
}
