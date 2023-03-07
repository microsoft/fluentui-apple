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
    static let fluent2: [DemoDescriptor] = [
        DemoDescriptor("ActivityIndicator", ActivityIndicatorDemoController.self),
        DemoDescriptor("Avatar", AvatarDemoController.self),
        DemoDescriptor("AvatarGroup", AvatarGroupDemoController.self),
        DemoDescriptor("BottomSheetController", BottomSheetDemoController.self),
        DemoDescriptor("Button", ButtonDemoController.self),
        DemoDescriptor("CardNudge", CardNudgeDemoController.self),
        DemoDescriptor("CommandBar", CommandBarDemoController.self),
        DemoDescriptor("DrawerController", DrawerDemoController.self),
        DemoDescriptor("HUD", HUDDemoController.self),
        DemoDescriptor("IndeterminateProgressBar", IndeterminateProgressBarDemoController.self),
        DemoDescriptor("Label", LabelDemoController.self),
        DemoDescriptor("LeftNav", LeftNavDemoController.self),
        DemoDescriptor("List", ListDemoController.self),
        DemoDescriptor("NotificationView", NotificationViewDemoController.self),
        DemoDescriptor("Other cells", OtherCellsDemoController.self),
        DemoDescriptor("PersonaButtonCarousel", PersonaButtonCarouselDemoController.self),
        DemoDescriptor("PillButton", PillButtonDemoController.self),
        DemoDescriptor("PillButtonBar", PillButtonBarDemoController.self),
        DemoDescriptor("PopupMenuController", PopupMenuDemoController.self),
        DemoDescriptor("SegmentedControl", SegmentedControlDemoController.self),
        DemoDescriptor("ShimmerView", ShimmerViewDemoController.self),
        DemoDescriptor("SideTabBar", SideTabBarDemoController.self),
        DemoDescriptor("TabBarView", TabBarViewDemoController.self),
        DemoDescriptor("TableViewCell", TableViewCellDemoController.self),
        DemoDescriptor("Text Field", TextFieldDemoController.self),
        DemoDescriptor("Tooltip", TooltipDemoController.self)
    ]

    static let fluent2DesignTokens: [DemoDescriptor] = [
        DemoDescriptor("Global Color Tokens", GlobalColorTokensDemoController.self),
        DemoDescriptor("Alias Color Tokens", AliasColorTokensDemoController.self),
        DemoDescriptor("Shadow Tokens", ShadowTokensDemoController.self),
        DemoDescriptor("Typography Tokens", TypographyTokensDemoController.self)
    ]

    static let controls: [DemoDescriptor] = [
        DemoDescriptor("BadgeField", BadgeFieldDemoController.self),
        DemoDescriptor("BadgeView", BadgeViewDemoController.self),
        DemoDescriptor("BottomCommandingController", BottomCommandingDemoController.self),
        DemoDescriptor("Button (Legacy)", ButtonLegacyDemoController.self),
        DemoDescriptor("Card", CardViewDemoController.self),
        DemoDescriptor("DateTimePicker", DateTimePickerDemoController.self),
        DemoDescriptor("NavigationController", NavigationControllerDemoController.self),
        DemoDescriptor("PeoplePicker", PeoplePickerDemoController.self),
        DemoDescriptor("PersonaListView", PersonaListViewDemoController.self),
        DemoDescriptor("SearchBar", SearchBarDemoController.self),
        DemoDescriptor("TableViewCellFileAccessoryView", TableViewCellFileAccessoryViewDemoController.self),
        DemoDescriptor("TableViewCellShimmer", TableViewCellShimmerDemoController.self),
        DemoDescriptor("TableViewHeaderFooterView", TableViewHeaderFooterViewDemoController.self)
    ]

    static let debug: [DemoDescriptor] = [
        DemoDescriptor("DEBUG: Objective-C Demos", ObjectiveCDemoController.self)
    ]
}
