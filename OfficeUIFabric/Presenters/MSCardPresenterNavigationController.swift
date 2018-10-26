//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

class MSCardPresenterNavigationController: UINavigationController, MSCardPresentable {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
    }

    func idealSize() -> CGSize {
        guard let topVC = topViewController as? MSCardPresentable else {
            return .zero
        }

        var size = topVC.idealSize()
        size.height += navigationBar.height
        return size
    }
}
