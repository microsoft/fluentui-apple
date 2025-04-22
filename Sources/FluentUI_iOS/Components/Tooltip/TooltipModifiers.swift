//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import SwiftUI

public extension View {

    /// Displays a tooltip based on the current settings, pointing to the `View` being modified.
    /// If another tooltip view is already showing, it will be dismissed and the new tooltip will be shown.
    ///
    /// - Parameters:
    ///   - message: The text to be displayed on the new tooltip view.
    ///   - title: The optional bolded text to be displayed above the message on the new tooltip view.
    ///   - preferredArrowDirection: The preferrred direction for the tooltip's arrow. Only the arrow's axis is guaranteed; the direction may be changed based on available space between the anchorView and the screen's margins. Defaults to down.
    ///   - offset: An offset from the tooltip's default position.
    ///   - dismissMode: The mode of tooltip dismissal. Defaults to tapping anywhere.
    ///   - isPresented: A binding to a Boolean value that determines whether to present the tooltip. When the user dismisses the tooltip, this value is set to `false`.
    ///   - onTap: An optional closure used to do work after the user taps
    @ViewBuilder
    func fluentTooltip(message: String,
                       title: String? = nil,
                       preferredArrowDirection: Tooltip.ArrowDirection = .down,
                       offset: CGPoint = CGPoint(x: 0, y: 0),
                       dismissMode: Tooltip.DismissMode = .tapAnywhere,
                       isPresented: Binding<Bool>,
                       onTap: (() -> Void)? = nil) -> some View {
        // Package up all the values to pass through.
        let values = TooltipAnchorViewValues(
            message: message,
            title: title,
            preferredArrowDirection: preferredArrowDirection,
            offset: offset,
            dismissMode: dismissMode,
            onTap: onTap)

        self.modifier(
            TooltipModifier(
                values: values,
                isPresented: isPresented
            )
        )
    }
}

// MARK: - Private support for public modifiers

/// Convenience wrapper for the values used to show a `Tooltip`.
private struct TooltipAnchorViewValues {
    let message: String
    let title: String?
    let preferredArrowDirection: Tooltip.ArrowDirection
    let offset: CGPoint
    let dismissMode: Tooltip.DismissMode
    let onTap: (() -> Void)?
}

private struct TooltipModifier: ViewModifier {
    let values: TooltipAnchorViewValues
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content
            .background {
                TooltipAnchorViewRepresentable(values: values, isPresented: $isPresented)
            }
    }
}

/// `UIView` subclass that serves as an anchor to the `Tooltip`.
///
/// Our existing `Tooltip` logic is built entirely around `UIView` anchoring. To reuse this in SwiftUI, we create
/// a simple `UIView` that acts as this anchor.
private class TooltipAnchorView: UIView {
    var values: TooltipAnchorViewValues
    var isPresented: Binding<Bool>

    init(values: TooltipAnchorViewValues, isPresented: Binding<Bool>) {
        self.values = values
        self.isPresented = isPresented
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        // It's possible that we were asked to show the tooltip before we had loaded into a window.
        // Check again now, just to be safe.
        showTooltipIfPossible()
    }

    func showTooltipIfPossible() {
        if isPresented.wrappedValue && window != nil {
            Tooltip.shared.show(with: values.message,
                                title: values.title,
                                for: self,
                                preferredArrowDirection: values.preferredArrowDirection,
                                offset: values.offset,
                                dismissOn: values.dismissMode,
                                onTap: { [weak self, values] in
                values.onTap?()

                // Set the `isPresented` binding back to `false` once the tooltip dismisses.
                self?.isPresented.wrappedValue = false
            })
        }
    }
}

/// Subclass of `UIViewRepresentable` that creates the `TooltipAnchorView`.
private struct TooltipAnchorViewRepresentable: UIViewRepresentable {
    var values: TooltipAnchorViewValues
    @Binding var isPresented: Bool

    func makeUIView(context: Self.Context) -> TooltipAnchorView {
        let view = TooltipAnchorView(values: values, isPresented: $isPresented)
        return view
    }

    func updateUIView(_ uiView: TooltipAnchorView, context: Context) {
        uiView.values = values
        if isPresented {
            uiView.showTooltipIfPossible()
        } else {
            Tooltip.shared.hide()
        }
    }
}
