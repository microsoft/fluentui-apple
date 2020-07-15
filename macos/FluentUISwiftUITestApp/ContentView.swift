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
						Text(testViewController.id)
					}
				}
			}
			.listStyle(SidebarListStyle())
		}
		.frame(minWidth: 800, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
