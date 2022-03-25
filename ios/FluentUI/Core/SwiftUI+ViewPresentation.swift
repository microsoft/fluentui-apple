//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Modifier that presents a SwiftUI View as an additional layer on top of the content View.
struct PresentationModifier<PresentedView: View>: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content

            // Backdrop for the presented view which overlays the
            // content where it's being presented from.
            Rectangle()
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .center)
            .foregroundColor(isPresented ? backgroundColor : Color.clear)
            .allowsHitTesting(isPresented && isBlocking)

            presentedView
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
    }

    var hasDimmedBackground: Bool
    var dimmedBackgroundColor: Color
    var dimmedBackgroundColroOpacity: Double
    var isBlocking: Bool
    @Binding var isPresented: Bool
    @ViewBuilder var presentedView: PresentedView

    var backgroundColor: Color {
        if hasDimmedBackground {
            return dimmedBackgroundColor.opacity(dimmedBackgroundColroOpacity)
        } else if isBlocking {
            // A clear color won't allow the background
            // view to block the underlying view
            return Color.black.opacity(Double.ulpOfOne)
        }

        return Color.clear
    }
}

extension View {

    /// Presents a View as a layer on top of this View.
    /// - Parameters:
    ///   - isPresented: Binding boolean value that determines whehter the `presentedView` is presented on top of this view..
    ///   - hasDimmedBackground: Defines whether the `presentedView` has a dimmed backdrop. The default value is false which renders a transparent backdrop.
    ///   - isBlocking: Defines whether the user can interact with this view while the `presentedView` is being presented on top of it.
    ///   - presentedView: The SwiftUI View that will be presented on top of this view.
    /// - Returns: Returns the modified view with its overlay according to the passed parameters.
    @ViewBuilder
    func presentingView<PresentedView: View>(isPresented: Binding<Bool>,
                                             dimmedBackgroundColor: Color = Color.black,
                                             dimmedBackgroundColorOpacity: Double = 0.1,
                                             hasDimmedBackground: Bool = false,
                                             isBlocking: Bool = false,
                                             @ViewBuilder presentedView: @escaping () -> PresentedView) -> some View {
        modifier(PresentationModifier(hasDimmedBackground: hasDimmedBackground,
                                      dimmedBackgroundColor: dimmedBackgroundColor,
                                      dimmedBackgroundColroOpacity: dimmedBackgroundColorOpacity,
                                      isBlocking: isBlocking,
                                      isPresented: isPresented,
                                      presentedView: presentedView))
    }
}
