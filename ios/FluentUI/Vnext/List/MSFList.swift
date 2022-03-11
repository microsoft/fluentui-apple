//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

/// UIKit wrapper that exposes the SwiftUI List implementation
@objc open class MSFList: ControlHostingContainer {

    @objc public init() {
        let list = FluentList()
        state = list.state
        super.init(AnyView(list))
    }

    @objc public let state: MSFListState
}
