//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// Register your control demos here
let demos: [(title: String, controllerClass: UIViewController.Type)] = [
    ("ActivityIndicatorView", MSActivityIndicatorViewDemoController.self),
    ("AvatarView", MSAvatarViewDemoController.self),
    ("BadgeField", BadgeFieldDemoController.self),
    ("BadgeView", BadgeViewDemoController.self),
    ("Button", MSButtonDemoController.self),
    ("MSColor", MSColorDemoController.self),
    ("DateTimePicker", DateTimePickerDemoController.self),
    ("DrawerController", MSDrawerDemoController.self),
    ("HUD", MSHUDDemoController.self),
    ("Label", MSLabelDemoController.self),
    ("NavigationController", MSNavigationControllerDemoController.self),
    ("NotificationView", MSNotificationViewDemoController.self),
    ("PeoplePicker", MSPeoplePickerDemoController.self),
    ("PersonaListView", MSPersonaListViewDemoController.self),
    ("PillButtonBar", MSPillButtonBarDemoController.self),
    ("PopupMenuController", MSPopupMenuDemoController.self),
    ("SegmentedControl", MSSegmentedControlDemoController.self),
    ("MSShimmerLinesView", MSShimmerLinesViewDemoController.self),
    ("MSTabBarView", MSTabBarViewDemoController.self),
    ("MSTableViewCell", MSTableViewCellDemoController.self),
    ("MSTableViewCellShimmer", MSTableViewCellShimmerDemoController.self),
    ("MSTableViewHeaderFooterView", MSTableViewHeaderFooterViewDemoController.self),
    ("MSTooltip", MSTooltipDemoController.self),
    ("Other cells", OtherCellsDemoController.self),
    ("DEBUG: Objective-C Demos", ObjectiveCDemoController.self)
]
