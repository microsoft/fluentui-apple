//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

public extension UITableViewCell {
    func hideSeparator() {
        separatorInset = UIEdgeInsets(top: 0, left: max(UIScreen.main.bounds.width, UIScreen.main.bounds.height), bottom: 0, right: 0)
    }
}
