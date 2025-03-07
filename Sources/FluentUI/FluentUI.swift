//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

@_exported import FluentUI_common
#if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
@_exported import FluentUI_ios
#elseif os(macOS)
@_exported import FluentUI_macos
#endif
