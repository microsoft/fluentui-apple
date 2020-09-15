//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class IndeterminateProgressBarDemoController: DemoController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Indeterminate Progress Bar
		let progressBar = IndeterminateProgressBarView()
		container.addArrangedSubview(progressBar)
		
		//Set the constraints
		progressBar.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			progressBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
			progressBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:0),
			progressBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:0),
			progressBar.heightAnchor.constraint(equalToConstant: 4.0)
	])
	}
}
