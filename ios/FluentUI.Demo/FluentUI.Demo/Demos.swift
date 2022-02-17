//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Definition of a DemoController
struct DemoDescriptor: Identifiable {
    let title: String
    let controllerClass: UIViewController.Type
    let id = UUID()

    init(_ title: String, _ controllerClass: UIViewController.Type, debugOnly: Bool = false) {
        self.title = title
        self.controllerClass = controllerClass
    }
}

struct Demos {
    static let vNext: [DemoDescriptor] = [
        DemoDescriptor("ActivityIndicator", ActivityIndicatorDemoController.self),
        DemoDescriptor("Avatar", AvatarDemoController.self),
        DemoDescriptor("AvatarGroup", AvatarGroupDemoController.self),
        DemoDescriptor("Button", ButtonDemoController.self),
        DemoDescriptor("CardNudge", CardNudgeDemoController.self),
        DemoDescriptor("ColorTokens", ColorTokensDemoController.self),
        DemoDescriptor("CommandBar", CommandBarDemoController.self),
        DemoDescriptor("Divider", DividerDemoController.self),
        DemoDescriptor("DrawerController", DrawerDemoController.self),
        DemoDescriptor("IndeterminateProgressBar", IndeterminateProgressBarDemoController.self),
        DemoDescriptor("LeftNav", LeftNavDemoController.self),
        DemoDescriptor("List", ListDemoController.self),
        DemoDescriptor("NotificationView", NotificationViewDemoController.self),
        DemoDescriptor("PersonaButtonCarousel", PersonaButtonCarouselDemoController.self),
        DemoDescriptor("PillButtonBar", PillButtonBarDemoController.self),
        DemoDescriptor("Theming (Vnext)", ThemingDemoController.self)
    ]

    static let controls: [DemoDescriptor] = [
        DemoDescriptor("BadgeField", BadgeFieldDemoController.self),
        DemoDescriptor("BadgeView", BadgeViewDemoController.self),
        DemoDescriptor("BottomCommandingController", BottomCommandingDemoController.self),
        DemoDescriptor("BottomSheetController", BottomSheetDemoController.self),
        DemoDescriptor("Button", ButtonLegacyDemoController.self),
        DemoDescriptor("Card", CardViewDemoController.self),
        DemoDescriptor("Color", ColorDemoController.self),
        DemoDescriptor("CommandBar", CommandBarDemoController.self),
        DemoDescriptor("DateTimePicker", DateTimePickerDemoController.self),
        DemoDescriptor("HUD", HUDDemoController.self),
        DemoDescriptor("Label", LabelDemoController.self),
        DemoDescriptor("NavigationController", NavigationControllerDemoController.self),
        DemoDescriptor("PeoplePicker", PeoplePickerDemoController.self),
        DemoDescriptor("PersonaListView", PersonaListViewDemoController.self),
        DemoDescriptor("PopupMenuController", PopupMenuDemoController.self),
        DemoDescriptor("SearchBar", SearchBarDemoController.self),
        DemoDescriptor("SegmentedControl", SegmentedControlDemoController.self),
        DemoDescriptor("ShimmerView", ShimmerViewDemoController.self),
        DemoDescriptor("SideTabBar", SideTabBarDemoController.self),
        DemoDescriptor("TabBarView", TabBarViewDemoController.self),
        DemoDescriptor("TableViewCell", TableViewCellDemoController.self),
        DemoDescriptor("TableViewCellFileAccessoryView", TableViewCellFileAccessoryViewDemoController.self),
        DemoDescriptor("TableViewCellShimmer", TableViewCellShimmerDemoController.self),
        DemoDescriptor("TableViewHeaderFooterView", TableViewHeaderFooterViewDemoController.self),
        DemoDescriptor("Tooltip", TooltipDemoController.self),
        DemoDescriptor("Other cells", OtherCellsDemoController.self)
    ]

    static let debug: [DemoDescriptor] = [
        DemoDescriptor("DEBUG: Objective-C Demos", ObjectiveCDemoController.self)
    ]
}
