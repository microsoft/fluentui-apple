//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class PopupMenuSectionHeaderView: MSTableViewHeaderFooterView {
    static func isHeaderVisible(for section: PopupMenuSection) -> Bool {
        return section.title != nil
    }

    static func preferredWidth(for section: PopupMenuSection) -> CGFloat {
        if isHeaderVisible(for: section) {
            return preferredWidth(style: .header, title: section.title ?? "")
        }
        return 0
    }

    static func preferredHeight(for section: PopupMenuSection) -> CGFloat {
        if isHeaderVisible(for: section) {
            return height(style: .header, title: section.title ?? "")
        }
        return 0
    }

    func setup(section: PopupMenuSection) {
        setup(style: .header, title: section.title ?? "")
    }
}
