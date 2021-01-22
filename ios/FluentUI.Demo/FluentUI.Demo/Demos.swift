//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// Register your control demos here
let demos: [(title: String, controllerClass: UIViewController.Type)] = [
    ("Avatar (Vnext)", AvatarDemoController.self),
    ("Button (Vnext)", ButtonVnextDemoController.self),
    ("Drawer (Vnext)", DrawerVnextDemoController.self),
    ("List (Vnext)", ListVnextDemoController.self),
    ("ActivityIndicatorView", ActivityIndicatorViewDemoController.self),
    ("AvatarGroupView", AvatarGroupViewDemoController.self),
    ("AvatarView", AvatarViewLegacyDemoController.self),
    ("BadgeField", BadgeFieldDemoController.self),
    ("BadgeView", BadgeViewDemoController.self),
    ("Button", ButtonDemoController.self),
    ("Card", CardViewDemoController.self),
    ("Color", ColorDemoController.self),
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
    ("SegmentedControl", SegmentedControlDemoController.self),
    ("ShimmerView", ShimmerViewDemoController.self),
    ("SideTabBar", SideTabBarDemoController.self),
    ("TabBarView", TabBarViewDemoController.self),
    ("TableViewCell", TableViewCellDemoController.self),
    ("TableViewCellFileAccessoryView", TableViewCellFileAccessoryViewDemoController.self),
    ("TableViewCellShimmer", TableViewCellShimmerDemoController.self),
    ("TableViewHeaderFooterView", TableViewHeaderFooterViewDemoController.self),
    ("Theming (vNext)", ThemingVnextDemoController.self),
    ("Tooltip", TooltipDemoController.self),
    ("Other cells", OtherCellsDemoController.self),
    ("DEBUG: Objective-C Demos", ObjectiveCDemoController.self)
]
