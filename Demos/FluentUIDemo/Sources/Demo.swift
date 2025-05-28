//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// An iterable enumeration of all available demos.
enum Demo: CaseIterable, Hashable {
    // Components
    case button
    case shimmer

    // Tokens
    case aliasColorTokens

    var title: String {
        switch self {
        case .button:
            return "Button"
        case .shimmer:
            return "Shimmer"
        case .aliasColorTokens:
            return "Alias Color Tokens"
        }
    }

    /// Returns the `View` instance for the given demo.
    var view: any View {
        switch self {
        case .button:
            return ButtonDemoView()
        case .shimmer:
            return ShimmerDemoView()
        case .aliasColorTokens:
            return AliasColorTokensDemoView()
        }
    }

    /// Only some demos are supported on visionOS.
    var supportsVisionOS: Bool {
        switch self {
        case .button,
             .aliasColorTokens:
            return true
        case .shimmer:
            return false
        }
    }
}

enum DemoListSection: CaseIterable, Hashable {
    case fluent2Controls
    case fluent2DesignTokens
    case controls
#if DEBUG
    case debug
#endif

    var title: String {
        switch self {
        case .fluent2Controls:
            return "Fluent 2 Controls"
        case .fluent2DesignTokens:
            return "Fluent 2 Design Tokens"
        case .controls:
            return "Controls"
#if DEBUG
        case .debug:
            return "DEBUG"
#endif
        }
    }

    var demos: [Demo] {
        switch self {
        case .fluent2Controls:
            return Demos.fluent2
        case .fluent2DesignTokens:
            return Demos.fluent2DesignTokens
        case .controls:
            return Demos.controls
#if DEBUG
        case .debug:
            return Demos.debug
#endif
        }
    }
}

private struct Demos {
    static let fluent2: [Demo] = [
        .button,
        .shimmer
    ]

    static let fluent2DesignTokens: [Demo] = [
        .aliasColorTokens
    ]

    static let controls: [Demo] = [
    ]

    static let debug: [Demo] = [
    ]
}
