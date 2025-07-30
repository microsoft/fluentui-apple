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
    init() {
        super.init { token, theme in
            switch token {
            case .backgroundColor:
                return .uiColor { UIColor(light: theme.color(.background2).light,
                                          dark: theme.color(.background2).dark)
                }
            case .cornerRadius:
                if #available(iOS 19, *) {
                    return .float { GlobalTokens.corner(.radius400) }
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
}

// MARK: Constants
extension BottomSheetTokenSet {
    static let blurEffectShadowColor: CGColor = UIColor.black.cgColor
    static let blurEffectShadowOpacity: Float = 0.25
    static let blurEffectShadowOffset: CGSize = CGSize(width: 0, height: -2)
    static let blurEffectShadowRadius: CGFloat = 8
}

// MARK: - BottomSheetControllerStyle

@objc(MSFBottomSheetControllerStyle)
public enum BottomSheetControllerStyle: Int {
    /// The default style, this applies a solid background color to the BottomSheet view
    case primary

    /// uses a UIVisualEffect BlurEffect Background for the BottomSheet view
    case glass
}
