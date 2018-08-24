//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import OfficeUIFabric
import UIKit

class MSButtonDemoController: DemoController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = MSButton()
        button.setTitle("Button", for: .normal)
        button.showsBorder = false
        container.addArrangedSubview(button)

        container.addArrangedSubview(UIView())  // spacer
    }
}
