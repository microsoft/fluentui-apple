//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class PopupMenuItemTokenSet: TableViewCellTokenSet {
    override init(customViewSize: @escaping () -> MSFTableViewCellCustomViewSize) {
        super.init(customViewSize: customViewSize)

        self.replaceAllOverrides(with: [
            .titleColor: .uiColor {
                self.fluentTheme.color(.foreground1)
            },
            .subtitleColor: .uiColor {
                self.fluentTheme.color(.foreground2)
            },
            .imageColor: .uiColor {
                self.fluentTheme.color(.foreground3)
            },
            .cellBackgroundColor: .uiColor {
                .clear
            }
        ])
    }
}
