//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension View {
    func fluentTooltip() -> some View {
        self.modifier(TooltipModifier())
    }
}

private struct TooltipModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                ToolbarAnchorViewRepresentable()
            }
    }
}

private class ToolbarAnchorView: UIView {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            Tooltip.shared.show(with: "This is a title-based tooltip.", for: self, preferredArrowDirection: .up)
        }
    }
}

private struct ToolbarAnchorViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Self.Context) -> ToolbarAnchorView {
        let view = ToolbarAnchorView(frame: .init(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .red
        return view
    }

    func updateUIView(_ uiView: ToolbarAnchorView, context: Context) {
    }

}
