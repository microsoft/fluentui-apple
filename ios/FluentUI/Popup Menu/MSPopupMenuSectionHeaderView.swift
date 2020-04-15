//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class MSPopupMenuSectionHeaderView: MSTableViewHeaderFooterView {
    static func isHeaderVisible(for section: MSPopupMenuSection) -> Bool {
        return section.title != nil
    }

    static func preferredWidth(for section: MSPopupMenuSection) -> CGFloat {
        if isHeaderVisible(for: section) {
            return preferredWidth(style: .header, title: section.title ?? "")
        }
        return 0
    }

    static func preferredHeight(for section: MSPopupMenuSection) -> CGFloat {
        if isHeaderVisible(for: section) {
            return height(style: .header, title: section.title ?? "")
        }
        return 0
    }

    func setup(section: MSPopupMenuSection) {
        setup(style: .header, title: section.title ?? "")
    }
}
