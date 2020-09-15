//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class IndeterminateProgressBarDemoController: DemoController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Set left and right margin to 0
		container.layoutMargins = UIEdgeInsets(top: Constants.margin, left: 0, bottom: Constants.margin, right: 0)
		
		//Indeterminate Progress Bar
		let progressBar = IndeterminateProgressBarView()
		container.addArrangedSubview(progressBar)
	}
}
