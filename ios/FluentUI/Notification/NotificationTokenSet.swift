//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Pre-defined styles of the notification
@objc public enum MSFNotificationStyle: Int, CaseIterable {
    /// Floating notification with brand colored text and background.
    case primaryToast

    /// Floating notification with neutral colored text and background.
    case neutralToast

    /// Bar notification with brand colored text and background.
    case primaryBar

    /// Bar notification with brand colored text and neutral colored background.
    case primaryOutlineBar

    /// Bar notification with neutral colored text and brackground.
    case neutralBar

    /// Floating notification with red text and background.
    case dangerToast

    ///Floating notification with yellow text and background.
    case warningToast

    var isToast: Bool {
        switch self {
        case .primaryToast,
             .neutralToast,
             .dangerToast,
             .warningToast:
            return true
        case .primaryBar,
             .primaryOutlineBar,
             .neutralBar:
            return false
        }
    }

    var animationDurationForShow: TimeInterval { return isToast ? Constants.animationDurationForShowToast : Constants.animationDurationForShowBar }
    var animationDurationForHide: TimeInterval { return Constants.animationDurationForHide }
    var animationDampingRatio: CGFloat { return isToast ? Constants.animationDampingRatioForToast : 1 }

    var needsFullWidth: Bool { return !isToast }
    var needsSeparator: Bool { return  self == .primaryOutlineBar }
    var supportsTitle: Bool { return isToast }
    var supportsImage: Bool { return isToast }
    var shouldAlwaysShowActionButton: Bool { return isToast }

    private struct Constants {
        static let animationDurationForShowToast: TimeInterval = 0.6
        static let animationDurationForShowBar: TimeInterval = 0.3
        static let animationDurationForHide: TimeInterval = 0.25
        static let animationDampingRatioForToast: CGFloat = 0.5
    }
}

/// Design token set for the `Notification` control.
public class NotificationTokenSet: ControlTokenSet<NotificationTokenSet.Tokens> {
    public enum Tokens: TokenSetKey {
        /// The background color of the notification
        case backgroundColor

        /// The color of the notification's foreground elements like text and icons
        case foregroundColor

        /// The color of the notification's icon image
        case imageColor

        /// The value for the corner radius of the frame of the notification
        case cornerRadius

        /// The value for the presentation offset of the notification
        case presentationOffset

        /// The value for the bottom padding between the notification and its anchor view
        case bottomPresentationPadding

        /// The value for the horizontal spacing between the elements within a notification
        case horizontalSpacing

        /// The value for the minimum height of a multi-line notification
        case minimumHeight

        /// The color of the outline around the frame of a notification
        case outlineColor

        /// The width of the outline around the frame of a notification
        case outlineWidth

        /// The `ShadowInfo` for this notification
        case shadow

        /// The font for bold text within a notification
        case boldTextFont

        /// The font for regular text within a notification
        case regularTextFont
    }

    init(style: @escaping () -> MSFNotificationStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor {
                    switch style() {
                    case .primaryToast,
                            .primaryBar:
                        return theme.color(.brandBackgroundTint)
                    case .neutralToast:
                        return theme.color(.background4)
                    case .primaryOutlineBar:
                        return theme.color(.background1)
                    case .neutralBar:
                        return theme.color(.background5)
                    case .dangerToast:
                        return theme.color(.dangerBackground1)
                    case .warningToast:
                        return theme.color(.warningBackground1)
                    }
                }

            case .foregroundColor:
                return .uiColor {
                    switch style() {
                    case .primaryToast,
                            .primaryBar:
                        return theme.color(.brandForegroundTint)
                    case .neutralToast,
                            .neutralBar:
                        return theme.color(.foreground2)
                    case .primaryOutlineBar:
                        return theme.color(.brandForeground1)
                    case .dangerToast:
                        return theme.color(.dangerForeground1)
                    case .warningToast:
                        return theme.color(.warningForeground1)
                    }
                }

            case .imageColor:
                return .uiColor {
                    switch style() {
                    case .primaryToast,
                            .primaryBar:
                        return theme.color(.brandForegroundTint)
                    case .neutralToast,
                            .neutralBar:
                        return theme.color(.foreground2)
                    case .primaryOutlineBar:
                        return theme.color(.brandForeground1)
                    case .dangerToast:
                        return theme.color(.dangerForeground1)
                    case .warningToast:
                        return theme.color(.warningForeground1)
                    }
                }

            case .cornerRadius:
                return .float {
                    switch style().isToast {
                    case true:
                        return GlobalTokens.corner(.radius120)
                    case false:
                        return GlobalTokens.corner(.radiusNone)
                    }
                }

            case .presentationOffset:
                return .float {
                    switch style().isToast {
                    case true:
                        return GlobalTokens.spacing(.size160)
                    case false:
                        return GlobalTokens.spacing(.sizeNone)
                    }
                }

            case .bottomPresentationPadding:
                return .float { GlobalTokens.spacing(.size160) }

            case .horizontalSpacing:
                return .float { GlobalTokens.spacing(.size160) }

            case .minimumHeight:
                return .float { 52.0 }

            case .outlineColor:
                return .uiColor {
                    switch style() {
                    case .primaryToast, .neutralToast, .primaryBar, .neutralBar, .dangerToast, .warningToast:
                        return .clear
                    case .primaryOutlineBar:
                        return theme.color(.stroke2)
                    }
                }

            case .outlineWidth:
                return .float { GlobalTokens.stroke(.width05) }

            case .shadow:
                return .shadowInfo {
                    if style().isToast {
                        return theme.shadow(.shadow16)
                    } else {
                        return theme.shadow(.clear)
                    }
                }

            case .boldTextFont:
                return .uiFont { theme.typography(.body2Strong) }

            case .regularTextFont:
                return .uiFont { theme.typography(.body2) }
            }
        }
    }

    /// Defines the style of the notification.
    var style: () -> MSFNotificationStyle
}

// MARK: Constants
extension NotificationTokenSet {
    /// The value for the horizontal padding between the elements within a notification and its frame
    static let horizontalPadding: CGFloat = GlobalTokens.spacing(.size160)

    /// The value for the vertical padding between the elements within a multi-line notification and its frame
    static let verticalPadding: CGFloat = GlobalTokens.spacing(.size120)
}
