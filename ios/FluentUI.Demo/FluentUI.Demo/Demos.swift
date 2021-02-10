//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// Register your control demos here
let demos: [(title: String, controllerClass: UIViewController.Type)] = [
    ("ActivityIndicatorView", ActivityIndicatorViewDemoController.self),
    ("AvatarGroupView", AvatarGroupViewDemoController.self),
    ("AvatarView", AvatarViewDemoController.self),
    ("BadgeField", BadgeFieldDemoController.self),
    ("BadgeView", BadgeViewDemoController.self),
    ("Button", ButtonDemoController.self),
    ("Card", CardViewDemoController.self),
    ("Color", ColorDemoController.self),
    ("CommandBar", CommandBarDemoController.self),
    ("ContactCollectionView", ContactCollectionViewDemoController.self),
    ("DateTimePicker", DateTimePickerDemoController.self),
    ("DrawerController", DrawerDemoController.self),
    ("HUD", HUDDemoController.self),
    ("IndeterminateProgressBar", IndeterminateProgressBarDemoController.self),
    ("Label", LabelDemoController.self),
    ("NavigationController", NavigationControllerDemoController.self),
    ("NotificationView", NotificationViewDemoController.self),
    ("PeoplePicker", PeoplePickerDemoController.self),
    ("PersonaListView", PersonaListViewDemoController.self),
    ("PillButtonBar", PillButtonBarDemoController.self),
    ("PopupMenuController", PopupMenuDemoController.self),
    ("SearchBar", SearchBarDemoController.self),
    ("SegmentedControl", SegmentedControlDemoController.self),
    ("ShimmerView", ShimmerViewDemoController.self),
    ("SideTabBar", SideTabBarDemoController.self),
    ("TabBarView", TabBarViewDemoController.self),
    ("TableViewCell", TableViewCellDemoController.self),
    ("TableViewCellFileAccessoryView", TableViewCellFileAccessoryViewDemoController.self),
    ("TableViewCellShimmer", TableViewCellShimmerDemoController.self),
    ("TableViewHeaderFooterView", TableViewHeaderFooterViewDemoController.self),
    ("Tooltip", TooltipDemoController.self),
    ("Other cells", OtherCellsDemoController.self),
    ("DEBUG: Objective-C Demos", ObjectiveCDemoController.self)
]
