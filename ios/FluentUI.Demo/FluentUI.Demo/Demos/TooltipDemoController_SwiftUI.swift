//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import SwiftUI
import UIKit

class TooltipDemoControllerSwiftUI: DemoHostingController {
    init() {
        super.init(rootView: AnyView(TooltipDemoView()), title: "Tooltip (SwiftUI)")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    @MainActor required dynamic init(rootView: AnyView) {
        preconditionFailure("init(rootView:) has not been implemented")
    }
}

struct TooltipDemoView: View {
     var body: some View {
        VStack {
            tooltipAnchor
            demoOptions
        }
    }

    @ViewBuilder
    private var tooltipAnchor: some View {
        Button(action: {
            showTooltip = true
        }, label: {
            Text("Tap for Tooltip")
        })
        .buttonStyle(FluentButtonStyle(style: .accent))
        .controlSize(.large)
        .fixedSize()
        .fluentTooltip(message: tooltipMessage,
                       title: (tooltipTitle != "") ? tooltipTitle : nil,
                       preferredArrowDirection: arrowDirection,
                       offset: offset,
                       dismissMode: dismissMode,
                       isPresented: $showTooltip)
        .padding(GlobalTokens.spacing(.size560))
    }

    @ViewBuilder
    private var demoOptions: some View {
        Form {
            Section("Content") {
                HStack(alignment: .firstTextBaseline) {
                    Text("Title")
                    Spacer()
                    TextField("Title", text: $tooltipTitle)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .multilineTextAlignment(.trailing)
                }
                .frame(maxWidth: .infinity)

                HStack(alignment: .firstTextBaseline) {
                    Text("Message")
                    Spacer()
                    TextField("Message", text: $tooltipMessage)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .multilineTextAlignment(.trailing)
                }
                .frame(maxWidth: .infinity)
            }

            Section("Layout") {
                Picker("Dismiss Mode", selection: $dismissMode) {
                    ForEach(Array(Tooltip.DismissMode.allCases.enumerated()), id: \.element) { _, dismissMode in
                        Text("\(dismissMode.description)").tag(dismissMode)
                    }
                }

                Picker("Arrow Direction", selection: $arrowDirection) {
                    ForEach(Array(Tooltip.ArrowDirection.allCases.enumerated()), id: \.element) { _, direction in
                        Text("\(direction.description)").tag(direction)
                    }
                }

                FluentUIDemoToggle(titleKey: "Use offset for origin", isOn: $useOffset)
            }
        }
    }

    private var offset: CGPoint {
        useOffset ? .init(x: 20, y: 20) : .zero
    }

    @State private var showTooltip: Bool = true

    @State private var tooltipTitle: String = ""
    @State private var tooltipMessage: String = "Tooltip message"
    @State private var arrowDirection: Tooltip.ArrowDirection = .down
    @State private var dismissMode: Tooltip.DismissMode = .tapAnywhere
    @State private var useOffset: Bool = false
}

private extension Tooltip.ArrowDirection {
    var description: String {
        switch self {
        case .up:
            return "Up"
        case .down:
            return "Down"
        case .left:
            return "Left"
        case .right:
            return "Right"
        }
    }
}

private extension Tooltip.DismissMode {
    var description: String {
        switch self {
        case .tapAnywhere:
            return "Tap anywhere"
        case .tapOnTooltip:
            return "Tap on Tooltip"
        case .tapOnTooltipOrAnchor:
            return "Tap on Tooltip or Anchor"
        }
    }
}
