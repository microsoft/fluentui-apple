//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct DemoHeading: View {
    let title: String

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
            Divider()
        }
    }
}

struct DemoHeading_Previews: PreviewProvider {
    static var previews: some View {
        DemoHeading(title: "Preview Heading")
    }
}
