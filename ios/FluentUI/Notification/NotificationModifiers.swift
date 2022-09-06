//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

public extension View {
    /// Presents a Notification on top of the modified View.
    /// - Parameters:
    ///   - notification: The `FluentNotification` instance to present.
    /// - Returns: The modified view with the capability of presenting a Notification.
    func presentNotification(isPresented: Binding<Bool>,
                             isBlocking: Bool = true,
                             @ViewBuilder notification: @escaping () -> FluentNotification) -> some View {
        self.presentingView(isPresented: isPresented,
                            isBlocking: isBlocking) {
            notification()
        }
    }

    /// Adds a border to the given edges of the modified View.
    /// - Parameters:
    ///   - width: The width of the border.
    ///   - edges: The edges to add a border to.
    ///   - color: The color of the border.
    /// - Returns: The modified view with a border outline.
    func border(width: CGFloat,
                edges: [Edge],
                color: Color) -> some View {
        overlay(EdgeBorder(width: width,
                           edges: edges)
            .foregroundColor(color))
    }
}

public extension FluentNotification {
    /// An optional linear gradient to use as the background of the notification.
    ///
    /// If this property is nil, then this notification will use the background color defined by its design tokens.
    func backgroundGradient(_ gradientInfo: LinearGradientInfo?) -> FluentNotification {
        state.backgroundGradient = gradientInfo
        return self
    }
}

/// Custom shape that is the edge(s) of a view
private struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading:
                    return rect.minX
                case .trailing:
                    return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing:
                    return rect.minY
                case .bottom:
                    return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom:
                    return rect.width
                case .leading, .trailing:
                    return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom:
                    return self.width
                case .leading, .trailing:
                    return rect.height
                }
            }

            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }

        return path
    }
}
