//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

class PopupMenuItemTokenSet: TableViewCellTokenSet {
    override init(customViewSize: @escaping () -> MSFTableViewCellCustomViewSize) {
        super.init(customViewSize: customViewSize)

        self.replaceAllOverrides(with: [
            .titleColor: .dynamicColor { /* textPrimary */
                DynamicColor(light: ColorValue(0x212121 /* gray900 */),
                             lightHighContrast: GlobalTokens.neutralColors(.black),
                             dark: ColorValue(0xE1E1E1 /* gray100 */),
                             darkHighContrast: GlobalTokens.neutralColors(.white))
            },
            .subtitleColor: .dynamicColor { /* textSecondary */
                DynamicColor(light: ColorValue(0x6E6E6E /* gray500 */),
                             lightHighContrast: ColorValue(0x303030 /* gray700 */),
                             dark: ColorValue(0x919191 /* gray400 */),
                             darkHighContrast: ColorValue(0xC8C8C8 /* gray200 */))
            },
            .imageColor: .dynamicColor { /* iconSecondary */
                DynamicColor(light: ColorValue(0x919191 /* gray400 */),
                             lightHighContrast: ColorValue(0x404040 /* gray600 */),
                             dark: ColorValue(0x6E6E6E /* gray500 */),
                             darkHighContrast: ColorValue(0xACACAC /* gray300 */),
                             darkElevated: ColorValue(0x919191 /* gray400 */))
            },
            .cellBackgroundColor: .dynamicColor { DynamicColor(light: .clear) }
        ])
    }
}
