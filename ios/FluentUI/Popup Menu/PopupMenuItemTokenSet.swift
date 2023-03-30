//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class PopupMenuItemTokenSet: TableViewCellTokenSet {
    override init(customViewSize: @escaping () -> MSFTableViewCellCustomViewSize) {
        super.init(customViewSize: customViewSize)

        self.replaceAllOverrides(with: [
            .titleColor: .uiColor { /* textPrimary */
                UIColor(light: .init(hexValue: 0x212121 /* gray900 */),
                        lightHighContrast: UIColor.black,
                        dark: .init(hexValue: 0xE1E1E1 /* gray100 */),
                        darkHighContrast: UIColor.white)
            },
            .subtitleColor: .uiColor { /* textSecondary */
                UIColor(light: .init(hexValue: 0x6E6E6E /* gray500 */),
                        lightHighContrast: .init(hexValue: 0x303030 /* gray700 */),
                        dark: .init(hexValue: 0x919191 /* gray400 */),
                        darkHighContrast: .init(hexValue: 0xC8C8C8 /* gray200 */))
            },
            .imageColor: .uiColor { /* iconSecondary */
                UIColor(light: .init(hexValue: 0x919191 /* gray400 */),
                        lightHighContrast: .init(hexValue: 0x404040 /* gray600 */),
                        dark: .init(hexValue: 0x6E6E6E /* gray500 */),
                        darkHighContrast: .init(hexValue: 0xACACAC /* gray300 */),
                        darkElevated: .init(hexValue: 0x919191 /* gray400 */))
            },
            .cellBackgroundColor: .uiColor { UIColor(light: .clear) }
        ])
    }
}
