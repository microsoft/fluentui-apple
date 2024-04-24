//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension View {
    func fluentTooltip(message: String,
                       title: String? = nil,
                       hostViewController: UIViewController? = nil,
                       preferredArrowDirection: Tooltip.ArrowDirection = .down,
                       offset: CGPoint = CGPoint(x: 0, y: 0),
                       dismissMode: Tooltip.DismissMode = .tapAnywhere,
                       onTap: (() -> Void)? = nil) -> some View {
        // Package up all the values to pass through.
        self.modifier(
            TooltipModifier(
                values: ToolbarAnchorViewValues(
                    message: message,
                    title: title,
                    hostViewController: hostViewController,
                    preferredArrowDirection: preferredArrowDirection,
                    offset: offset,
                    dismissMode: dismissMode,
                    onTap: onTap)
            )
        )
    }
}

// MARK: - Private support for public modifiers

private struct ToolbarAnchorViewValues {
    let message: String
    let title: String?
    let hostViewController: UIViewController?
    let preferredArrowDirection: Tooltip.ArrowDirection
    let offset: CGPoint
    let dismissMode: Tooltip.DismissMode
    let onTap: (() -> Void)?
}

private struct TooltipModifier: ViewModifier {
    let values: ToolbarAnchorViewValues
    func body(content: Content) -> some View {
        content
            .background {
                ToolbarAnchorViewRepresentable(values: values)
            }
    }
}

private class ToolbarAnchorView: UIView {
    init(values: ToolbarAnchorViewValues) {
        self.values = values
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            Tooltip.shared.show(with: values.message,
                                title: values.title,
                                for: self,
                                in: values.hostViewController,
                                preferredArrowDirection: values.preferredArrowDirection,
                                offset: values.offset,
                                dismissOn: values.dismissMode,
                                onTap: values.onTap)
        }
    }

    private let values: ToolbarAnchorViewValues
}

private struct ToolbarAnchorViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Self.Context) -> ToolbarAnchorView {
        let view = ToolbarAnchorView(values: values)
        view.backgroundColor = .red
        return view
    }

    func updateUIView(_ uiView: ToolbarAnchorView, context: Context) {
        // no-op
    }

    let values: ToolbarAnchorViewValues
}
