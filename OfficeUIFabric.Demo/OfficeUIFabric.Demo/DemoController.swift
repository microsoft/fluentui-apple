//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import OfficeUIFabric
import UIKit

class DemoController: UIViewController {
    class func createVerticalContainer() -> UIStackView {
        let container = UIStackView(frame: .zero)
        container.axis = .vertical
        container.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        container.isLayoutMarginsRelativeArrangement = true
        container.spacing = 16
        return container
    }

    let container: UIStackView = createVerticalContainer()
    let scrollingContainer: UIScrollView = UIScrollView(frame: .zero)

    func createButton(title: String, action: Selector) -> MSButton {
        let button = MSButton()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MSColors.background

        view.addSubview(scrollingContainer)
        scrollingContainer.fitIntoSuperview()
        scrollingContainer.addSubview(container)
        container.fitIntoSuperview(usingConstraints: true, autoHeight: true)
    }
}
