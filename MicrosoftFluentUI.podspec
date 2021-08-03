Pod::Spec.new do |s|
  s.name             = 'MicrosoftFluentUI'
  s.version          = '0.2.10'
  s.summary          = 'Fluent UI is a set of reusable UI controls and tools'
  s.homepage         = "https://www.microsoft.com/design/fluent/#/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Microsoft" => "fluentuinativeowners@microsoft.com"}
  s.source       = { :git => "https://github.com/microsoft/fluentui-apple.git", :tag => "#{s.version}" }
  s.swift_version = "5.0"
  s.module_name = 'FluentUI'


# iOS

  s.ios.deployment_target = "13.0"

  s.subspec 'Avatar_ios' do |avatar_ios|
    avatar_ios.platform = :ios
    avatar_ios.dependency 'MicrosoftFluentUI/Core_ios'
    avatar_ios.preserve_paths = ["ios/FluentUI/Avatar/Avatar.resources.xcfilelist"]
    avatar_ios.source_files = ["ios/FluentUI/Avatar/**/*.{swift,h}"]
  end

  s.subspec 'AvatarGroup_ios' do |avatargroup_ios|
    avatargroup_ios.platform = :ios
    avatargroup_ios.dependency 'MicrosoftFluentUI/Avatar_ios'
    avatargroup_ios.source_files = ["ios/FluentUI/AvatarGroup/**/*.{swift,h}"]
  end

  s.subspec 'ActivityViewAnimating_ios' do |activityviewanimating_ios|
    activityviewanimating_ios.platform = :ios
    activityviewanimating_ios.dependency 'MicrosoftFluentUI/Core_ios'
    activityviewanimating_ios.source_files = ["ios/FluentUI/ActivityViewAnimating/**/*.{swift,h}"]
  end

  s.subspec 'ActivityIndicator_ios' do |activityindicator_ios|
    activityindicator_ios.platform = :ios
    activityindicator_ios.dependency 'MicrosoftFluentUI/ActivityViewAnimating_ios'
    activityindicator_ios.source_files = ["ios/FluentUI/ActivityIndicator/**/*.{swift,h}"]
  end

  s.subspec 'BadgeField_ios' do |badgefield_ios|
    badgefield_ios.platform = :ios
    badgefield_ios.dependency 'MicrosoftFluentUI/Label_ios'
    badgefield_ios.source_files = ["ios/FluentUI/Badge Field/**/*.{swift,h}"]
  end

  s.subspec 'BarButtonItems_ios' do |barbuttonitems_ios|
    barbuttonitems_ios.platform = :ios
    barbuttonitems_ios.dependency 'MicrosoftFluentUI/Core_ios'
    barbuttonitems_ios.preserve_paths = ["ios/FluentUI/BarButtonItems/BarButtonItems.resources.xcfilelist"]
    barbuttonitems_ios.source_files = ["ios/FluentUI/BarButtonItems/**/*.{swift,h}"]
  end

  s.subspec 'BottomCommanding_ios' do |bottomcommanding_ios|
    bottomcommanding_ios.platform = :ios
    bottomcommanding_ios.dependency 'MicrosoftFluentUI/BottomSheet_ios'
    bottomcommanding_ios.dependency 'MicrosoftFluentUI/OtherCells_ios'
    bottomcommanding_ios.dependency 'MicrosoftFluentUI/Separator_ios'
    bottomcommanding_ios.dependency 'MicrosoftFluentUI/TabBar_ios'
    bottomcommanding_ios.dependency 'MicrosoftFluentUI/TableView_ios'
    bottomcommanding_ios.preserve_paths = ["ios/FluentUI/Bottom Commanding/BottomCommanding.resources.xcfilelist"]
    bottomcommanding_ios.source_files = ["ios/FluentUI/Bottom Commanding/**/*.{swift,h}"]
  end

  s.subspec 'BottomSheet_ios' do |bottomsheet_ios|
    bottomsheet_ios.platform = :ios
    bottomsheet_ios.dependency 'MicrosoftFluentUI/Obscurable_ios'
    bottomsheet_ios.dependency 'MicrosoftFluentUI/ResizingHandleView_ios'
    bottomsheet_ios.source_files = ["ios/FluentUI/Bottom Sheet/**/*.{swift,h}"]
  end

  s.subspec 'Button_ios' do |button_ios|
    button_ios.platform = :ios
    button_ios.dependency 'MicrosoftFluentUI/Core_ios'
    button_ios.source_files = ["ios/FluentUI/Button/**/*.{swift,h}"]
  end

  s.subspec 'Calendar_ios' do |calendar_ios|
    calendar_ios.platform = :ios
    calendar_ios.dependency 'MicrosoftFluentUI/BarButtonItems_ios'
    calendar_ios.dependency 'MicrosoftFluentUI/DotView_ios'
    calendar_ios.dependency 'MicrosoftFluentUI/Label_ios'
    calendar_ios.dependency 'MicrosoftFluentUI/Presenters_ios'
    calendar_ios.dependency 'MicrosoftFluentUI/SegmentedControl_ios'
    calendar_ios.dependency 'MicrosoftFluentUI/Separator_ios'
    calendar_ios.dependency 'MicrosoftFluentUI/TwoLineTitleView_ios'
    calendar_ios.source_files = ["ios/FluentUI/Calendar/**/*.{swift,h}",
                                 "ios/FluentUI/Date Time Pickers/**/*.{swift,h}"]
  end

  s.subspec 'Card_ios' do |card_ios|
    card_ios.platform = :ios
    card_ios.dependency 'MicrosoftFluentUI/Label_ios'
    card_ios.source_files = ["ios/FluentUI/Card/**/*.{swift,h}"]
  end

  s.subspec 'CommandBar_ios' do |commandbar_ios|
    commandbar_ios.platform = :ios
    commandbar_ios.dependency 'MicrosoftFluentUI/Core_ios'
    commandbar_ios.source_files = ["ios/FluentUI/Command Bar/**/*.{swift,h}"]
  end

  s.subspec 'Core_ios' do |core_ios|
    core_ios.platform = :ios
    core_ios.resource_bundle = { 'FluentUIResources-ios' => ["apple/Resources/**/*.{json,xcassets}",
                                                             "ios/FluentUI/**/*.{storyboard,xib,xcassets,strings,stringsdict}"] }
    core_ios.script_phase = { :name => 'Optimize resource bundle',
                              :script => 'echo "=== Removing unused resources from FluentUI-ios.xcassets ==="

XCODEBUILDPARAMS="-quiet"

if [ "${CONFIGURATION}" = "Debug" ]; then
    CONDITIONALCOMPILATIONFLAGS="-D VERBOSE_OUTPUT"
    XCODEBUILDPARAMS=""
fi

xcrun --sdk macosx swift ${CONDITIONALCOMPILATIONFLAGS} ${PODS_TARGET_SRCROOT}/scripts/removeUnusedResourcesFromAssets.swift ${LOCROOT}/MicrosoftFluentUI/ios/FluentUI/Resources/FluentUI-ios.xcassets ${LOCROOT}/MicrosoftFluentUI/ios

echo "=== Rebuilding resource bundle target ==="
xcodebuild ${XCODEBUILDPARAMS} -project ${PROJECT_FILE_PATH} -target "MicrosoftFluentUI-FluentUIResources-ios" -sdk ${PLATFORM_NAME} -configuration ${CONFIGURATION} ARCHS="${ARCHS}" CONFIGURATION_BUILD_DIR="${CONFIGURATION_BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" BUILT_PRODUCTS_DIR="${BUILT_PRODUCTS_DIR}" ${ACTION}',
                              :execution_position => :before_compile }
    core_ios.preserve_paths = ["ios/FluentUI/Core/Core.resources.xcfilelist",
                               "scripts/removeUnusedResourcesFromAssets.swift"]
    core_ios.source_files = ["ios/FluentUI/Configuration/**/*.{swift,h}",
                             "ios/FluentUI/Core/**/*.{swift,h}",
                             "ios/FluentUI/Extensions/**/*.{swift,h}"]
  end

  s.subspec 'DotView_ios' do |dotview_ios|
    dotview_ios.platform = :ios
    dotview_ios.dependency 'MicrosoftFluentUI/Core_ios'
    dotview_ios.source_files = ["ios/FluentUI/DotView/**/*.{swift,h}"]
  end

  s.subspec 'Drawer_ios' do |drawer_ios|
    drawer_ios.platform = :ios
    drawer_ios.dependency 'MicrosoftFluentUI/Obscurable_ios'
    drawer_ios.dependency 'MicrosoftFluentUI/ResizingHandleView_ios'
    drawer_ios.dependency 'MicrosoftFluentUI/Separator_ios'
    drawer_ios.dependency 'MicrosoftFluentUI/TouchForwardingView_ios'
    drawer_ios.source_files = ["ios/FluentUI/Drawer/**/*.{swift,h}"]
  end

  s.subspec 'EasyTapButton_ios' do |easytapbutton_ios|
    easytapbutton_ios.platform = :ios
    easytapbutton_ios.dependency 'MicrosoftFluentUI/Core_ios'
    easytapbutton_ios.source_files = ["ios/FluentUI/EasyTapButton/**/*.{swift,h}"]
  end

  s.subspec 'HUD_ios' do |hud_ios|
    hud_ios.platform = :ios
    hud_ios.dependency 'MicrosoftFluentUI/ActivityIndicator_ios'
    hud_ios.dependency 'MicrosoftFluentUI/Label_ios'
    hud_ios.dependency 'MicrosoftFluentUI/TouchForwardingView_ios'
    hud_ios.preserve_paths = ["ios/FluentUI/HUD/HUD.resources.xcfilelist"]
    hud_ios.source_files = ["ios/FluentUI/HUD/**/*.{swift,h}"]
  end

  s.subspec 'IndeterminateProgressBar_ios' do |indeterminateprogressbar_ios|
    indeterminateprogressbar_ios.platform = :ios
    indeterminateprogressbar_ios.dependency 'MicrosoftFluentUI/ActivityViewAnimating_ios'
    indeterminateprogressbar_ios.source_files = ["ios/FluentUI/IndeterminateProgressBar/**/*.{swift,h}"]
  end

  s.subspec 'Label_ios' do |label_ios|
    label_ios.platform = :ios
    label_ios.dependency 'MicrosoftFluentUI/Core_ios'
    label_ios.source_files = ["ios/FluentUI/Label/**/*.{swift,h}"]
  end

  s.subspec 'Navigation_ios' do |navigation_ios|
    navigation_ios.platform = :ios
    navigation_ios.dependency 'MicrosoftFluentUI/ActivityIndicator_ios'
    navigation_ios.dependency 'MicrosoftFluentUI/Avatar_ios'
    navigation_ios.dependency 'MicrosoftFluentUI/Separator_ios'
    navigation_ios.dependency 'MicrosoftFluentUI/TwoLineTitleView_ios'
    navigation_ios.preserve_paths = ["ios/FluentUI/Navigation/Navigation.resources.xcfilelist"]
    navigation_ios.source_files = ["ios/FluentUI/Navigation/**/*.{swift,h}"]
  end

  s.subspec 'Notification_ios' do |notification_ios|
    notification_ios.platform = :ios
    notification_ios.dependency 'MicrosoftFluentUI/Obscurable_ios'
    notification_ios.dependency 'MicrosoftFluentUI/Label_ios'
    notification_ios.dependency 'MicrosoftFluentUI/Separator_ios'
    notification_ios.preserve_paths = ["ios/FluentUI/Notification/Notification.resources.xcfilelist"]
    notification_ios.source_files = ["ios/FluentUI/Notification/**/*.{swift,h}"]
  end

  s.subspec 'Obscurable_ios' do |obscurable_ios|
    obscurable_ios.platform = :ios
    obscurable_ios.dependency 'MicrosoftFluentUI/Core_ios'
    obscurable_ios.source_files = ["ios/FluentUI/Obscurable/**/*.{swift,h}"]
  end

  s.subspec 'OtherCells_ios' do |othercells_ios|
    othercells_ios.platform = :ios
    othercells_ios.dependency 'MicrosoftFluentUI/ActivityIndicator_ios'
    othercells_ios.dependency 'MicrosoftFluentUI/TableView_ios'
    othercells_ios.preserve_paths = ["ios/FluentUI/Other Cells/OtherCells.resources.xcfilelist"]
    othercells_ios.source_files = ["ios/FluentUI/Other Cells/**/*.{swift,h}"]
  end

  s.subspec 'PeoplePicker_ios' do |peoplepicker_ios|
    peoplepicker_ios.platform = :ios
    peoplepicker_ios.dependency 'MicrosoftFluentUI/Avatar_ios'
    peoplepicker_ios.dependency 'MicrosoftFluentUI/BadgeField_ios'
    peoplepicker_ios.dependency 'MicrosoftFluentUI/Separator_ios'
    peoplepicker_ios.dependency 'MicrosoftFluentUI/OtherCells_ios'
    peoplepicker_ios.source_files = ["ios/FluentUI/People Picker/**/*.{swift,h}"]
  end

  s.subspec 'PillButtonBar_ios' do |pillbuttonbar_ios|
    pillbuttonbar_ios.platform = :ios
    pillbuttonbar_ios.dependency 'MicrosoftFluentUI/Core_ios'
    pillbuttonbar_ios.source_files = ["ios/FluentUI/Pill Button Bar/**/*.{swift,h}"]
  end

  s.subspec 'PopupMenu_ios' do |popupmenu_ios|
    popupmenu_ios.platform = :ios
    popupmenu_ios.dependency 'MicrosoftFluentUI/Drawer_ios'
    popupmenu_ios.dependency 'MicrosoftFluentUI/Label_ios'
    popupmenu_ios.dependency 'MicrosoftFluentUI/Separator_ios'
    popupmenu_ios.dependency 'MicrosoftFluentUI/TableView_ios'
    popupmenu_ios.source_files = ["ios/FluentUI/Popup Menu/**/*.{swift,h}"]
  end

  s.subspec 'Presenters_ios' do |presenters_ios|
    presenters_ios.platform = :ios
    presenters_ios.dependency 'MicrosoftFluentUI/Obscurable_ios'
    presenters_ios.source_files = ["ios/FluentUI/Presenters/**/*.{swift,h}"]
  end

  s.subspec 'ResizingHandleView_ios' do |resizinghandleview_ios|
    resizinghandleview_ios.platform = :ios
    resizinghandleview_ios.dependency 'MicrosoftFluentUI/Core_ios'
    resizinghandleview_ios.source_files = ["ios/FluentUI/ResizingHandleView/**/*.{swift,h}"]
  end

  s.subspec 'ScrollView_ios' do |scrollview_ios|
    scrollview_ios.platform = :ios
    scrollview_ios.dependency 'MicrosoftFluentUI/Core_ios'
    scrollview_ios.source_files = ["ios/FluentUI/ScrollView/**/*.{swift,h}"]
  end

  s.subspec 'SegmentedControl_ios' do |segmentedcontrol_ios|
    segmentedcontrol_ios.platform = :ios
    segmentedcontrol_ios.dependency 'MicrosoftFluentUI/Separator_ios'
    segmentedcontrol_ios.source_files = ["ios/FluentUI/SegmentedControl/**/*.{swift,h}"]
  end

  s.subspec 'Separator_ios' do |separator_ios|
    separator_ios.platform = :ios
    separator_ios.dependency 'MicrosoftFluentUI/Core_ios'
    separator_ios.source_files = ["ios/FluentUI/Separator/**/*.{swift,h}"]
  end

  s.subspec 'Shimmer_ios' do |shimmer_ios|
    shimmer_ios.platform = :ios
    shimmer_ios.dependency 'MicrosoftFluentUI/Core_ios'
    shimmer_ios.dependency 'MicrosoftFluentUI/Utilities_ios'
    shimmer_ios.source_files = ["ios/FluentUI/Shimmer/**/*.{swift,h}"]
  end

  s.subspec 'TabBar_ios' do |tabbar_ios|
    tabbar_ios.platform = :ios
    tabbar_ios.dependency 'MicrosoftFluentUI/Avatar_ios'
    tabbar_ios.dependency 'MicrosoftFluentUI/Label_ios'
    tabbar_ios.dependency 'MicrosoftFluentUI/Separator_ios'
    tabbar_ios.source_files = ["ios/FluentUI/Tab Bar/**/*.{swift,h}"]
  end

  s.subspec 'TableView_ios' do |tableview_ios|
    tableview_ios.platform = :ios
    tableview_ios.dependency 'MicrosoftFluentUI/Label_ios'
    tableview_ios.dependency 'MicrosoftFluentUI/Separator_ios'
    tableview_ios.preserve_paths = ["ios/FluentUI/Table View/TableView.resources.xcfilelist"]
    tableview_ios.source_files = ["ios/FluentUI/Table View/**/*.{swift,h}"]
  end

  s.subspec 'Tooltip_ios' do |tooltip_ios|
    tooltip_ios.platform = :ios
    tooltip_ios.dependency 'MicrosoftFluentUI/Label_ios'
    tooltip_ios.dependency 'MicrosoftFluentUI/TouchForwardingView_ios'
    tooltip_ios.preserve_paths = ["ios/FluentUI/Tooltip/Tooltip.resources.xcfilelist"]
    tooltip_ios.source_files = ["ios/FluentUI/Tooltip/**/*.{swift,h}"]
  end

  s.subspec 'TouchForwardingView_ios' do |touchforwardingview_ios|
    touchforwardingview_ios.platform = :ios
    touchforwardingview_ios.dependency 'MicrosoftFluentUI/Core_ios'
    touchforwardingview_ios.source_files = ["ios/FluentUI/TouchForwardingView/**/*.{swift,h}"]
  end

  s.subspec 'TwoLineTitleView_ios' do |twoLinetitleview_ios|
    twoLinetitleview_ios.platform = :ios
    twoLinetitleview_ios.dependency 'MicrosoftFluentUI/EasyTapButton_ios'
    twoLinetitleview_ios.dependency 'MicrosoftFluentUI/Label_ios'
    twoLinetitleview_ios.preserve_paths = ["ios/FluentUI/TwoLineTitleView/TwoLineTitleView.resources.xcfilelist"]
    twoLinetitleview_ios.source_files = ["ios/FluentUI/TwoLineTitleView/**/*.{swift,h}"]
  end

  s.subspec 'Utilities_ios' do |utilities_ios|
    utilities_ios.platform = :ios
    utilities_ios.source_files = ["ios/FluentUI/Utilities/**/*.{swift,h}"]
  end


# Mac

  s.osx.deployment_target = "10.14"

  s.subspec 'Appearance_mac' do |appearance_mac|
    appearance_mac.platform = :osx
    appearance_mac.source_files = ["macos/FluentUI/Appearance/**/*.{swift,h}"]
  end

  s.subspec 'AvatarView_mac' do |avatarview_mac|
    avatarview_mac.platform = :osx
    avatarview_mac.dependency 'MicrosoftFluentUI/Core_mac'
    avatarview_mac.dependency 'MicrosoftFluentUI/DynamicColor_mac'
    avatarview_mac.source_files = ["macos/FluentUI/AvatarView/**/*.{swift,h}"]
  end

  s.subspec 'Button_mac' do |button_mac|
    button_mac.platform = :osx
    button_mac.dependency 'MicrosoftFluentUI/Core_mac'
    button_mac.source_files = ["macos/FluentUI/Button/**/*.{swift,h}"]
  end

  s.subspec 'Core_mac' do |core_mac|
    core_mac.platform = :osx
    core_mac.resource_bundle = { 'FluentUIResources-macos' => ["apple/Resources/**/*.{json,xcassets}",
                                                             "macos/FluentUI/**/*.{storyboard,xib,xcassets,strings,stringsdict}"] }
    core_mac.source_files = ["macos/FluentUI/Core/**/*.{swift,h}"]
  end

  s.subspec 'DatePicker_mac' do |datepicker_mac|
    datepicker_mac.platform = :osx
    datepicker_mac.dependency 'MicrosoftFluentUI/Core_mac'
    datepicker_mac.dependency 'MicrosoftFluentUI/Appearance_mac'
    datepicker_mac.source_files = ["macos/FluentUI/DatePicker/**/*.{swift,h}"]
  end

  s.subspec 'DynamicColor_mac' do |dynamiccolor_mac|
    dynamiccolor_mac.platform = :osx
    dynamiccolor_mac.dependency 'MicrosoftFluentUI/Appearance_mac'
    dynamiccolor_mac.source_files = ["macos/FluentUI/DynamicColor/**/*.{swift,h}"]
  end

  s.subspec 'Link_mac' do |link_mac|
    link_mac.platform = :osx
    link_mac.dependency 'MicrosoftFluentUI/Core_mac'
    link_mac.source_files = ["macos/FluentUI/Link/**/*.{swift,h}"]
  end

  s.subspec 'Separator_mac' do |separator_mac|
    separator_mac.platform = :osx
    separator_mac.dependency 'MicrosoftFluentUI/Core_mac'
    separator_mac.source_files = ["macos/FluentUI/Separator/**/*.{swift,h}"]
  end

end
