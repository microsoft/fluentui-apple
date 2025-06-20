//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI

public struct TestAliasColorTokensViewController: View {
    @Environment(\.fluentTheme) var fluentTheme: FluentTheme

    public init() {}

    public var body: some View {
        List {
            ForEach(AliasColorTokensDemoSection.allCases, id: \.self) { demoSection in
                colorSection(demoSection)
            }
        }
        .listStyle(.inset)
    }

    @ViewBuilder
    func colorSection(_ demoSection: AliasColorTokensDemoSection) -> some View {
        Section(demoSection.title) {
            ForEach(demoSection.rows, id: \.self) { colorRow in
                Text(colorRow.text)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(fluentTheme.swiftUIColor(colorRow))
                    .foregroundStyle(colorRow.textColor(fluentTheme))
            }
        }
    }
}

enum AliasColorTokensDemoSection: CaseIterable {
    case neutralBackgrounds
    case brandBackgrounds
    case neutralForegrounds
    case brandForegrounds
    case brandGradients
    case neutralStrokes
    case brandStrokes
    case sharedErrorAndStatus
    case sharedPresence

    var title: String {
        switch self {
        case .neutralBackgrounds:
            return "Neutral Backgrounds"
        case .brandBackgrounds:
            return "Brand Backgrounds"
        case .neutralForegrounds:
            return "Neutral Foregrounds"
        case .brandForegrounds:
            return "Brand Foregrounds"
        case .brandGradients:
            return "Brand Gradients"
        case .neutralStrokes:
            return "Neutral Strokes"
        case .brandStrokes:
            return "Brand Strokes"
        case .sharedErrorAndStatus:
            return "Shared Error and Status"
        case .sharedPresence:
            return "Shared Presence"
        }
    }

    var rows: [FluentTheme.ColorToken] {
        switch self {
        case .neutralBackgrounds:
            return [.background1,
                    .background1Pressed,
                    .background1Selected,
                    .background2,
                    .background2Pressed,
                    .background2Selected,
                    .background3,
                    .background3Pressed,
                    .background3Selected,
                    .background4,
                    .background4Hover,
                    .background4Pressed,
                    .background4Selected,
                    .background5,
                    .background5Pressed,
                    .background5Selected,
                    .background6,
                    .backgroundInverted,
                    .backgroundDisabled,
                    .backgroundCanvas,
                    .stencil1,
                    .stencil2,
                    .backgroundDarkStatic,
                    .backgroundLightStatic,
                    .backgroundLightStaticDisabled]
        case .brandBackgrounds:
            return [.brandBackgroundTint,
                    .brandBackground1,
                    .brandBackground1Pressed,
                    .brandBackground1Selected,
                    .brandBackground2,
                    .brandBackground2Pressed,
                    .brandBackground2Selected,
                    .brandBackground3,
                    .brandBackgroundDisabled]
        case .neutralForegrounds:
            return [.foreground1,
                    .foreground2,
                    .foreground3,
                    .foreground4,
                    .foregroundDisabled1,
                    .foregroundDisabled2,
                    .foregroundOnColor,
                    .foregroundLightStatic,
                    .foregroundDarkStatic]
        case .brandForegrounds:
            return [.brandForegroundTint,
                    .brandForeground1,
                    .brandForeground1Pressed,
                    .brandForeground1Selected,
                    .brandForegroundDisabled1,
                    .brandForegroundDisabled2]
        case .brandGradients:
            return [.brandGradient1,
                    .brandGradient2,
                    .brandGradient3]
        case .neutralStrokes:
            return [.stroke1,
                    .stroke1Pressed,
                    .stroke2,
                    .strokeAccessible,
                    .strokeFocus1,
                    .strokeFocus2,
                    .strokeDisabled]
        case .brandStrokes:
            return [.brandStroke1,
                    .brandStroke1Pressed,
                    .brandStroke1Selected]
        case .sharedErrorAndStatus:
            return [.dangerBackground1,
                    .dangerBackground2,
                    .dangerForeground1,
                    .dangerForeground2,
                    .dangerStroke1,
                    .dangerStroke2,
                    .successBackground1,
                    .successBackground2,
                    .successForeground1,
                    .successForeground2,
                    .successStroke1,
                    .warningBackground1,
                    .warningBackground2,
                    .warningForeground1,
                    .warningForeground2,
                    .warningStroke1,
                    .severeBackground1,
                    .severeBackground2,
                    .severeForeground1,
                    .severeForeground2,
                    .severeStroke1]
        case .sharedPresence:
            return [.presenceAway,
                    .presenceDnd,
                    .presenceAvailable,
                    .presenceOof]
        }
    }
}

extension FluentTheme.ColorToken {
    var text: String {
        switch self {
        case .foreground1:
            return "Foreground 1"
        case .foreground2:
            return "Foreground 2"
        case .foreground3:
            return "Foreground 3"
        case .foreground4:
            return "Foreground 4"
        case .foregroundDisabled1:
            return "Foreground Disabled 1"
        case .foregroundDisabled2:
            return "Foreground Disabled 2"
        case .foregroundOnColor:
            return "Foreground On Color"
        case .glassForeground1:
            return "Glass Foreground 1"
        case .glassForegroundDisabled1:
            return "Glass Foreground Disabled 1"
        case .brandForeground1:
            return "Brand Foreground 1"
        case .brandForeground1Pressed:
            return "Brand Foreground 1 Pressed"
        case .brandForeground1Selected:
            return "Brand Foreground 1 Selected"
        case .brandForegroundDisabled1:
            return "Brand Foreground Disabled 1"
        case .brandForegroundDisabled2:
            return "Brand Foreground Disabled 2"
        case .background1:
            return "Background 1"
        case .background1Pressed:
            return "Background 1 Pressed"
        case .background1Selected:
            return "Background 1 Selected"
        case .background2:
            return "Background 2"
        case .background2Pressed:
            return "Background 2 Pressed"
        case .background2Selected:
            return "Background 2 Selected"
        case .background3:
            return "Background 3"
        case .background3Pressed:
            return "Background 3 Pressed"
        case .background3Selected:
            return "Background 3 Selected"
        case .background4:
            return "Background 4"
        case .background4Hover:
            return "Background 4 Hover"
        case .background4Pressed:
            return "Background 4 Pressed"
        case .background4Selected:
            return "Background 4 Selected"
        case .background5:
            return "Background 5"
        case .background5Pressed:
            return "Background 5 Pressed"
        case .background5Selected:
            return "Background 5 Selected"
        case .background6:
            return "Background 6"
        case .backgroundInverted:
            return "Background Inverted"
        case .backgroundDisabled:
            return "Background Disabled"
        case .brandBackground1:
            return "Brand Background 1"
        case .brandBackground1Pressed:
            return "Brand Background 1 Pressed"
        case .brandBackground1Selected:
            return "Brand Background 1 Selected"
        case .brandBackground2:
            return "Brand Background 2"
        case .brandBackground2Pressed:
            return "Brand Background 2 Pressed"
        case .brandBackground2Selected:
            return "Brand Background 2 Selected"
        case .brandBackground3:
            return "Brand Background 3"
        case .brandBackgroundDisabled:
            return "Brand Background Disabled"
        case .brandBackgroundTint:
            return "Brand Background Tint"
        case .brandForegroundTint:
            return "Brand Foreground Tint"
        case .brandGradient1:
            return "Brand Gradient 1"
        case .brandGradient2:
            return "Brand Gradient 2"
        case .brandGradient3:
            return "Brand Gradient 3"
        case .stencil1:
            return "Stencil 1"
        case .stencil2:
            return "Stencil 2"
        case .backgroundCanvas:
            return "Background Canvas"
        case .stroke1:
            return "Stroke 1"
        case .stroke1Pressed:
            return "Stroke 1 Pressed"
        case .stroke2:
            return "Stroke 2"
        case .strokeAccessible:
            return "Stroke Accessible"
        case .strokeFocus1:
            return "Stroke Focus 1"
        case .strokeFocus2:
            return "Stroke Focus 2"
        case .strokeDisabled:
            return "Stroke Disabled"
        case .brandStroke1:
            return "Brand Stroke 1"
        case .brandStroke1Pressed:
            return "Brand Stroke 1 Pressed"
        case .brandStroke1Selected:
            return "Brand Stroke 1 Selected"
        case .foregroundDarkStatic:
            return "Foreground Dark Static"
        case .foregroundLightStatic:
            return "Foreground Light Static"
        case .backgroundDarkStatic:
            return "Background Dark Static"
        case .backgroundLightStatic:
            return "BackgroundLightStatic"
        case .backgroundLightStaticDisabled:
            return "BackgroundLightStaticDisabled"
        case .dangerBackground1:
            return "DangerBackground1"
        case .dangerBackground2:
            return "DangerBackground2"
        case .dangerForeground1:
            return "DangerForeground1"
        case .dangerForeground2:
            return "DangerForeground2"
        case .dangerStroke1:
            return "DangerStroke1"
        case .dangerStroke2:
            return "DangerStroke2"
        case .successBackground1:
            return "SuccessBackground1"
        case .successBackground2:
            return "SuccessBackground2"
        case .successForeground1:
            return "SuccessForeground1"
        case .successForeground2:
            return "SuccessForeground2"
        case .successStroke1:
            return "SuccessStroke1"
        case .warningBackground1:
            return "WarningBackground1"
        case .warningBackground2:
            return "WarningBackground2"
        case .warningForeground1:
            return "WarningForeground1"
        case .warningForeground2:
            return "WarningForeground2"
        case .warningStroke1:
            return "WarningStroke1"
        case .severeBackground1:
            return "SevereBackground1"
        case .severeBackground2:
            return "SevereBackground2"
        case .severeForeground1:
            return "SevereForeground1"
        case .severeForeground2:
            return "SevereForeground2"
        case .severeStroke1:
            return "SevereStroke1"
        case .presenceAway:
            return "PresenceAway"
        case .presenceDnd:
            return "PresenceDnd"
        case .presenceAvailable:
            return "PresenceAvailable"
        case .presenceOof:
            return "PresenceOof"
        }
    }

    func textColor(_ fluentTheme: FluentTheme) -> Color {
        switch self {
        case .background1,
             .background1Pressed,
             .background1Selected,
             .background2,
             .background2Pressed,
             .background2Selected,
             .background3,
             .background3Pressed,
             .background3Selected,
             .background4,
             .background4Hover,
             .background4Pressed,
             .background4Selected,
             .background5,
             .background5Pressed,
             .background5Selected,
             .background6,
             .backgroundDisabled,
             .brandBackgroundDisabled,
             .backgroundCanvas,
             .stencil1,
             .stencil2,
             .foregroundDisabled2,
             .foregroundOnColor,
             .brandForegroundDisabled2,
             .stroke1,
             .stroke1Pressed,
             .stroke2,
             .strokeFocus1,
             .strokeDisabled,
             .brandBackgroundTint,
             .foregroundDisabled1,
             .glassForegroundDisabled1,
             .dangerBackground1,
             .successBackground1,
             .warningBackground1,
             .severeBackground1:
            return fluentTheme.swiftUIColor(.foreground1)
        case .foreground1,
             .foreground2,
             .foreground3,
             .foreground4,
             .glassForeground1,
             .strokeFocus2,
             .strokeAccessible,
             .brandBackground1Pressed,
             .brandForeground1Pressed,
             .brandStroke1Pressed,
             .brandStroke1,
             .brandForegroundTint,
             .brandStroke1Selected,
             .brandGradient1,
             .dangerBackground2,
             .dangerForeground1,
             .dangerForeground2,
             .dangerStroke1,
             .dangerStroke2,
             .successBackground2,
             .successForeground1,
             .successForeground2,
             .successStroke1,
             .warningForeground1,
             .warningForeground2,
             .warningStroke1,
             .severeBackground2,
             .severeForeground1,
             .severeForeground2,
             .severeStroke1:
            return fluentTheme.swiftUIColor(.foregroundOnColor)
        case .foregroundLightStatic,
             .backgroundLightStatic,
             .backgroundLightStaticDisabled,
             .warningBackground2,
             .brandGradient2,
             .brandGradient3:
            return fluentTheme.swiftUIColor(.foregroundDarkStatic)
        case .brandForeground1,
             .brandForeground1Selected,
             .brandForegroundDisabled1,
             .backgroundInverted,
             .brandBackground1,
             .brandBackground1Selected,
             .brandBackground2,
             .brandBackground2Pressed,
             .brandBackground2Selected,
             .brandBackground3,
             .backgroundDarkStatic,
             .foregroundDarkStatic,
             .presenceAway,
             .presenceDnd,
             .presenceAvailable,
             .presenceOof:
            return fluentTheme.swiftUIColor(.foregroundLightStatic)
        }
    }
}
