//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import OfficeUIFabric
import UIKit

class MSButtonController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        let button = MSButton()
        button.setTitle("Button", for: .normal)
        button.frame = CGRect(x: 20, y: 100, width: 100, height: 30)
        view.addSubview(button)
    }
}
