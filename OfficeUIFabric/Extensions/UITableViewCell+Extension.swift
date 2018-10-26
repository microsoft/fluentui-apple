//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public extension UITableViewCell {
    func hideSeparator() {
        separatorInset = UIEdgeInsets(top: 0, left: max(UIScreen.main.bounds.width, UIScreen.main.bounds.height), bottom: 0, right: 0)
    }
}
