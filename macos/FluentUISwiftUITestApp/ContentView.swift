//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUITestViewControllers
import SwiftUI

struct ContentView: View {
    var body: some View {
		NavigationView {
			List {
				ForEach(testViewControllers) { testViewController in
					NavigationLink(destination: TestViewControllerWrappingView(type: testViewController.type)) {
						Text(testViewController.title)
					}
				}
			}
			.listStyle(SidebarListStyle())
		}
		.frame(minWidth: minWidth, maxWidth: .infinity, minHeight: minHeight, maxHeight: .infinity)
    }

	private let minWidth: CGFloat = 800
	private let minHeight: CGFloat = 500
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
