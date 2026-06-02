//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// An iterable enumeration of all available demos.
enum Demo: CaseIterable, Hashable {
    // Components
    case button
    case messageBar
    case shimmer

    // Tokens
    case aliasColorTokens

    var title: String { demoConfiguration.title }

    /// Returns the `View` instance for the given demo.
    var view: any View { demoConfiguration.view }

    /// Only some demos are supported on visionOS.
    var supportsVisionOS: Bool { demoConfiguration.supportsVisionOS }

    private struct DemoConfiguration {
        let title: String
        let view: any View
        let supportsVisionOS: Bool
    }

    private var demoConfiguration: DemoConfiguration {
        switch self {
        case .button:
            return DemoConfiguration(title: "Button", view: ButtonDemoView(), supportsVisionOS: true)
        case .messageBar:
            return DemoConfiguration(title: "Message Bar", view: MessageBarDemoView(), supportsVisionOS: true)
        case .shimmer:
            return DemoConfiguration(title: "Shimmer", view: ShimmerDemoView(), supportsVisionOS: false)
        case .aliasColorTokens:
            return DemoConfiguration(title: "Alias Color Tokens", view: AliasColorTokensDemoView(), supportsVisionOS: true)
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
        .messageBar,
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
