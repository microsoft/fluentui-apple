//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if canImport(FluentUI_common)
import FluentUI_common
#endif
import UIKit

public enum BottomSheetToken: Int, TokenSetKey {
    /// Defines the background color of the `BottomSheetController`.
    case backgroundColor

    /// Defines the corner radius of the `BottomSheetController`.
    case cornerRadius

    /// Defines the color of the resizing handle of the `BottomSheetController`.
    case resizingHandleMarkColor

    /// Defines the shadows used by the `BottomSheetController`.
    case shadow
}

public class BottomSheetTokenSet: ControlTokenSet<BottomSheetToken> {
    init(style: @escaping () -> BottomSheetControllerStyle) {
        self.style = style
        super.init { [style] token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor {
                    switch style() {
                    case .primary:
                        return theme.color(.background2)
                    case .glass:
                        return .clear
                    }
                }
            case .cornerRadius:
                if #available(iOS 26, *) {
                    return .float { BottomSheetTokenSet.cornerRadius }
                } else {
                    return .float { GlobalTokens.corner(.radius120) }
                }
            case .resizingHandleMarkColor:
                return .uiColor { theme.color(.strokeAccessible) }
            case .shadow:
                return .shadowInfo { theme.shadow(.shadow28) }
            }
        }
    }

    var style: () -> BottomSheetControllerStyle
}

// MARK: Constants
extension BottomSheetTokenSet {
    static let blurEffectShadowColor: CGColor = UIColor.black.cgColor
    static let blurEffectShadowOpacity: Float = 0.25
    static let blurEffectShadowOffset: CGSize = CGSize(width: 0, height: -2)
    static let blurEffectShadowRadius: CGFloat = 8
    static let cornerRadius: CGFloat = 40
}

// MARK: - BottomSheetControllerStyle

@objc(MSFBottomSheetControllerStyle)
public enum BottomSheetControllerStyle: Int {
    /// The default style, this applies a solid background color to the BottomSheet view
    case primary

    /// uses a UIVisualEffect BlurEffect Background for the BottomSheet view
    case glass
}
