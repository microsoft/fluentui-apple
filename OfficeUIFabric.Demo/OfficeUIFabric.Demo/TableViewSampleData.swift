//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import OfficeUIFabric

// MARK: TableViewSampleData

class TableViewSampleData {
    struct Section {
        let title: String
        var item: Item { return items[0] }
        let items: [Item]
        let numberOfLines: Int
        let hasAccessoryView: Bool
        let allowsMultipleSelection: Bool

        init(title: String, items: [Item], numberOfLines: Int = 1, hasAccessoryView: Bool = false, allowsMultipleSelection: Bool = true) {
            self.title = title
            self.items = items
            self.numberOfLines = numberOfLines
            self.hasAccessoryView = hasAccessoryView
            self.allowsMultipleSelection = allowsMultipleSelection
        }
    }

    struct Item {
        let text1: String
        let text2: String
        let text3: String
        let image: String

        init(text1: String = "", text2: String = "", text3: String = "", image: String = "") {
            self.text1 = text1
            self.text2 = text2
            self.text3 = text3
            self.image = image
        }
    }

    static func createCustomView(imageName: String) -> UIImageView? {
        if imageName == "" {
            return nil
        }

        let customView = UIImageView(image: UIImage(named: imageName))
        customView.contentMode = .scaleAspectFit
        return customView
    }
}
