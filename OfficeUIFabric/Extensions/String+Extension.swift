//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public extension String {
    internal var localized: String {
        return NSLocalizedString(self, bundle: OfficeUIFabricFramework.bundle, comment: "")
    }
}
