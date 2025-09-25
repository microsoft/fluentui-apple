# Constants
common_root = 'Sources/FluentUI_common'
ios_root = 'Sources/FluentUI_iOS'
macos_root = 'Sources/FluentUI_macOS'

components_dir = 'Components'
core_dir = 'Core'
resources_dir = 'Resources'

Pod::Spec.new do |s|
  s.name             = 'MicrosoftFluentUI'
  s.version          = '0.34.0'
  s.summary          = 'Fluent UI is a set of reusable UI controls and tools'
  s.homepage         = "https://www.microsoft.com/design/fluent/#/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Microsoft" => "fluentuinativeowners@microsoft.com"}
  s.source           = { :git => "https://github.com/microsoft/fluentui-apple.git", :tag => "#{s.version}" }
  s.swift_version    = "5.9"
  s.module_name      = 'FluentUI'

  s.ios.deployment_target = "17.0"
  s.osx.deployment_target = "14.0"


# Common

  s.subspec 'Core_common' do |core_common|
    core_common.source_files = ["#{common_root}/#{core_dir}/**/*.{swift,h}"]
  end


# iOS

  s.subspec 'Avatar_ios' do |avatar_ios|
    avatar_ios.platform = :ios
    avatar_ios.dependency "#{s.name}/Core_ios"
    avatar_ios.preserve_paths = ["#{ios_root}/#{components_dir}/Avatar/Avatar.resources.xcfilelist"]
    avatar_ios.source_files = ["#{ios_root}/#{components_dir}/Avatar/**/*.{swift,h}"]
  end

  s.subspec 'AvatarGroup_ios' do |avatargroup_ios|
    avatargroup_ios.platform = :ios
    avatargroup_ios.dependency "#{s.name}/Avatar_ios"
    avatargroup_ios.source_files = ["#{ios_root}/#{components_dir}/AvatarGroup/**/*.{swift,h}"]
  end

  s.subspec 'ActivityIndicator_ios' do |activityindicator_ios|
    activityindicator_ios.platform = :ios
    activityindicator_ios.dependency "#{s.name}/Core_ios"
    activityindicator_ios.source_files = ["#{ios_root}/#{components_dir}/ActivityIndicator/**/*.{swift,h}"]
  end

  s.subspec 'BadgeField_ios' do |badgefield_ios|
    badgefield_ios.platform = :ios
    badgefield_ios.dependency "#{s.name}/Label_ios"
    badgefield_ios.source_files = ["#{ios_root}/#{components_dir}/BadgeField/**/*.{swift,h}"]
  end

  s.subspec 'BarButtonItems_ios' do |barbuttonitems_ios|
    barbuttonitems_ios.platform = :ios
    barbuttonitems_ios.dependency "#{s.name}/Core_ios"
    barbuttonitems_ios.preserve_paths = ["#{ios_root}/#{components_dir}/BarButtonItems/BarButtonItems.resources.xcfilelist"]
    barbuttonitems_ios.source_files = ["#{ios_root}/#{components_dir}/BarButtonItems/**/*.{swift,h}"]
  end

  s.subspec 'BottomCommanding_ios' do |bottomcommanding_ios|
    bottomcommanding_ios.platform = :ios
    bottomcommanding_ios.dependency "#{s.name}/BottomSheet_ios"
    bottomcommanding_ios.dependency "#{s.name}/OtherCells_ios"
    bottomcommanding_ios.dependency "#{s.name}/Separator_ios"
    bottomcommanding_ios.dependency "#{s.name}/TabBar_ios"
    bottomcommanding_ios.dependency "#{s.name}/TableView_ios"
    bottomcommanding_ios.preserve_paths = ["#{ios_root}/#{components_dir}/BottomCommanding/BottomCommanding.resources.xcfilelist"]
    bottomcommanding_ios.source_files = ["#{ios_root}/#{components_dir}/BottomCommanding/**/*.{swift,h}"]
  end

  s.subspec 'BottomSheet_ios' do |bottomsheet_ios|
    bottomsheet_ios.platform = :ios
    bottomsheet_ios.dependency "#{s.name}/Obscurable_ios"
    bottomsheet_ios.dependency "#{s.name}/ResizingHandleView_ios"
    bottomsheet_ios.source_files = ["#{ios_root}/#{components_dir}/BottomSheet/**/*.{swift,h}"]
  end

  s.subspec 'Button_ios' do |button_ios|
    button_ios.platform = :ios
    button_ios.dependency "#{s.name}/Core_ios"
    button_ios.source_files = ["#{ios_root}/#{components_dir}/Button/**/*.{swift,h}"]
  end

  s.subspec 'Calendar_ios' do |calendar_ios|
    calendar_ios.platform = :ios
    calendar_ios.dependency "#{s.name}/BarButtonItems_ios"
    calendar_ios.dependency "#{s.name}/DotView_ios"
    calendar_ios.dependency "#{s.name}/Label_ios"
    calendar_ios.dependency "#{s.name}/Presenters_ios"
    calendar_ios.dependency "#{s.name}/SegmentedControl_ios"
    calendar_ios.dependency "#{s.name}/Separator_ios"
    calendar_ios.dependency "#{s.name}/TwoLineTitleView_ios"
    calendar_ios.source_files = ["#{ios_root}/#{components_dir}/Calendar/**/*.{swift,h}",
                                 "#{ios_root}/#{components_dir}/DateTimePickers/**/*.{swift,h}"]
  end

  s.subspec 'Card_ios' do |card_ios|
    card_ios.platform = :ios
    card_ios.dependency "#{s.name}/Label_ios"
    card_ios.source_files = ["#{ios_root}/#{components_dir}/Card/**/*.{swift,h}"]
  end

  s.subspec 'CardNudge_ios' do |cardnudge_ios|
    cardnudge_ios.platform = :ios
    cardnudge_ios.dependency "#{s.name}/Core_ios"
    cardnudge_ios.source_files = ["#{ios_root}/#{components_dir}/CardNudge/**/*.{swift,h}"]
  end

  s.subspec 'CommandBar_ios' do |commandbar_ios|
    commandbar_ios.platform = :ios
    commandbar_ios.dependency "#{s.name}/Core_ios"
    commandbar_ios.dependency "#{s.name}/Label_ios"
    commandbar_ios.source_files = ["#{ios_root}/#{components_dir}/CommandBar/**/*.{swift,h}"]
  end

  s.subspec 'Core_ios' do |core_ios|
    core_ios.platform = :ios
    core_ios.dependency "#{s.name}/Core_common"
    core_ios.resource_bundle = { 'FluentUIResources-ios' => ["#{ios_root}/#{resources_dir}/**/*.{storyboard,xib,xcassets,strings,stringsdict}"] }
    core_ios.script_phase = { :name => 'Optimize resource bundle',
                              :script => 'REMOVE_UNUSED_RESOURCES_SCRIPT_PATH=${PODS_TARGET_SRCROOT}/scripts/removeUnusedResourcesFromAssets.swift

# Executes only once per "pod install" (if the script file exists)
if [ -f ${REMOVE_UNUSED_RESOURCES_SCRIPT_PATH} ]; then
    echo "=== Removing unused resources from FluentUI-ios.xcassets ==="

    XCODEBUILDPARAMS="-quiet "

    if [ "${CONFIGURATION}" = "Debug" ]; then
        CONDITIONALCOMPILATIONFLAGS="-D VERBOSE_OUTPUT"
        XCODEBUILDPARAMS=""
    fi

    xcrun --sdk macosx swift ${CONDITIONALCOMPILATIONFLAGS} ${REMOVE_UNUSED_RESOURCES_SCRIPT_PATH} ${LOCROOT}/MicrosoftFluentUI/Sources/FluentUI_iOS/Resources/FluentUI-ios.xcassets ${LOCROOT}/MicrosoftFluentUI/Sources/FluentUI_iOS

    echo "=== Rebuilding resource bundle target ==="
    xcodebuild ${XCODEBUILDPARAMS} DISABLE_MANUAL_TARGET_ORDER_BUILD_WARNING=1 -project ${PROJECT_FILE_PATH} -target "MicrosoftFluentUI-FluentUIResources-ios" -sdk ${PLATFORM_NAME} -configuration ${CONFIGURATION} ARCHS="${ARCHS}" CONFIGURATION_BUILD_DIR="${CONFIGURATION_BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" BUILT_PRODUCTS_DIR="${BUILT_PRODUCTS_DIR}" ${ACTION}

    # Deletes the script to ensure it will not be needlessly executed more than once after each "pod install"
    rm ${REMOVE_UNUSED_RESOURCES_SCRIPT_PATH}

fi', :execution_position => :before_compile }
    core_ios.preserve_paths = ["#{ios_root}/#{core_dir}/Core.resources.xcfilelist",
                               "scripts/removeUnusedResourcesFromAssets.swift"]
    core_ios.source_files = ["#{ios_root}/#{core_dir}/**/*.{swift,h}"]
  end

  s.subspec 'DotView_ios' do |dotview_ios|
    dotview_ios.platform = :ios
    dotview_ios.dependency "#{s.name}/Core_ios"
    dotview_ios.source_files = ["#{ios_root}/#{components_dir}/DotView/**/*.{swift,h}"]
  end

  s.subspec 'Drawer_ios' do |drawer_ios|
    drawer_ios.platform = :ios
    drawer_ios.dependency "#{s.name}/Obscurable_ios"
    drawer_ios.dependency "#{s.name}/ResizingHandleView_ios"
    drawer_ios.dependency "#{s.name}/Separator_ios"
    drawer_ios.dependency "#{s.name}/TouchForwardingView_ios"
    drawer_ios.source_files = ["#{ios_root}/#{components_dir}/Drawer/**/*.{swift,h}"]
  end

  s.subspec 'EasyTapButton_ios' do |easytapbutton_ios|
    easytapbutton_ios.platform = :ios
    easytapbutton_ios.dependency "#{s.name}/Core_ios"
    easytapbutton_ios.source_files = ["#{ios_root}/#{components_dir}/EasyTapButton/**/*.{swift,h}"]
  end

  s.subspec 'HUD_ios' do |hud_ios|
    hud_ios.platform = :ios
    hud_ios.dependency "#{s.name}/ActivityIndicator_ios"
    hud_ios.dependency "#{s.name}/Label_ios"
    hud_ios.dependency "#{s.name}/TouchForwardingView_ios"
    hud_ios.preserve_paths = ["#{ios_root}/#{components_dir}/HUD/HUD.resources.xcfilelist"]
    hud_ios.source_files = ["#{ios_root}/#{components_dir}/HUD/**/*.{swift,h}"]
  end

  s.subspec 'IndeterminateProgressBar_ios' do |indeterminateprogressbar_ios|
    indeterminateprogressbar_ios.platform = :ios
    indeterminateprogressbar_ios.dependency "#{s.name}/Core_ios"
    indeterminateprogressbar_ios.source_files = ["#{ios_root}/#{components_dir}/IndeterminateProgressBar/**/*.{swift,h}"]
  end

  s.subspec 'Label_ios' do |label_ios|
    label_ios.platform = :ios
    label_ios.dependency "#{s.name}/Core_ios"
    label_ios.source_files = ["#{ios_root}/#{components_dir}/Label/**/*.{swift,h}"]
  end

  s.subspec 'ListItem_ios' do |listitem_ios|
    listitem_ios.platform = :ios
    listitem_ios.dependency "#{s.name}/OtherCells_ios"
    listitem_ios.dependency "#{s.name}/Separator_ios"
    listitem_ios.dependency "#{s.name}/TableViewListShared_ios"
    listitem_ios.source_files = ["#{ios_root}/#{components_dir}/List/**/*.swift"]
  end

  s.subspec 'MultilineCommandBar_ios' do |multilinecommandbar_ios|
    multilinecommandbar_ios.platform = :ios
    multilinecommandbar_ios.dependency "#{s.name}/BottomSheet_ios"
    multilinecommandbar_ios.dependency "#{s.name}/CommandBar_ios"
    multilinecommandbar_ios.dependency "#{s.name}/Core_ios"
    multilinecommandbar_ios.source_files = ["#{ios_root}/#{components_dir}/MultilineCommandBar/**/*.{swift,h}"]
  end

  s.subspec 'Navigation_ios' do |navigation_ios|
    navigation_ios.platform = :ios
    navigation_ios.dependency "#{s.name}/ActivityIndicator_ios"
    navigation_ios.dependency "#{s.name}/Avatar_ios"
    navigation_ios.dependency "#{s.name}/Separator_ios"
    navigation_ios.dependency "#{s.name}/TwoLineTitleView_ios"
    navigation_ios.preserve_paths = ["#{ios_root}/#{components_dir}/Navigation/Navigation.resources.xcfilelist"]
    navigation_ios.source_files = ["#{ios_root}/#{components_dir}/Navigation/**/*.{swift,h}"]
  end

  s.subspec 'Notification_ios' do |notification_ios|
    notification_ios.platform = :ios
    notification_ios.dependency "#{s.name}/Obscurable_ios"
    notification_ios.dependency "#{s.name}/Label_ios"
    notification_ios.preserve_paths = ["#{ios_root}/#{components_dir}/Notification/Notification.resources.xcfilelist"]
    notification_ios.source_files = ["#{ios_root}/#{components_dir}/Notification/**/*.{swift,h}"]
  end

  s.subspec 'Obscurable_ios' do |obscurable_ios|
    obscurable_ios.platform = :ios
    obscurable_ios.dependency "#{s.name}/Core_ios"
    obscurable_ios.source_files = ["#{ios_root}/#{components_dir}/Obscurable/**/*.{swift,h}"]
  end

  s.subspec 'OtherCells_ios' do |othercells_ios|
    othercells_ios.platform = :ios
    othercells_ios.dependency "#{s.name}/ActivityIndicator_ios"
    othercells_ios.dependency "#{s.name}/TableView_ios"
    othercells_ios.preserve_paths = ["#{ios_root}/#{components_dir}/OtherCells/OtherCells.resources.xcfilelist"]
    othercells_ios.source_files = ["#{ios_root}/#{components_dir}/OtherCells/**/*.{swift,h}"]
  end

  s.subspec 'PeoplePicker_ios' do |peoplepicker_ios|
    peoplepicker_ios.platform = :ios
    peoplepicker_ios.dependency "#{s.name}/Avatar_ios"
    peoplepicker_ios.dependency "#{s.name}/BadgeField_ios"
    peoplepicker_ios.dependency "#{s.name}/Separator_ios"
    peoplepicker_ios.dependency "#{s.name}/OtherCells_ios"
    peoplepicker_ios.source_files = ["#{ios_root}/#{components_dir}/PeoplePicker/**/*.{swift,h}"]
  end

  s.subspec 'PersonaButton_ios' do |personaButton_ios|
    personaButton_ios.platform = :ios
    personaButton_ios.dependency "#{s.name}/Avatar_ios"
    personaButton_ios.source_files = ["#{ios_root}/#{components_dir}/PersonaButton/**/*.{swift,h}"]
  end

  s.subspec 'PersonaButtonCarousel_ios' do |personaButtonCarousel_ios|
    personaButtonCarousel_ios.platform = :ios
    personaButtonCarousel_ios.dependency "#{s.name}/PersonaButton_ios"
    personaButtonCarousel_ios.source_files = ["#{ios_root}/#{components_dir}/PersonaButtonCarousel/**/*.{swift,h}"]
  end

  s.subspec 'PillButtonBar_ios' do |pillbuttonbar_ios|
    pillbuttonbar_ios.platform = :ios
    pillbuttonbar_ios.dependency "#{s.name}/Core_ios"
    pillbuttonbar_ios.source_files = ["#{ios_root}/#{components_dir}/PillButtonBar/**/*.{swift,h}"]
  end

  s.subspec 'PopupMenu_ios' do |popupmenu_ios|
    popupmenu_ios.platform = :ios
    popupmenu_ios.dependency "#{s.name}/Drawer_ios"
    popupmenu_ios.dependency "#{s.name}/Label_ios"
    popupmenu_ios.dependency "#{s.name}/Separator_ios"
    popupmenu_ios.dependency "#{s.name}/TableView_ios"
    popupmenu_ios.source_files = ["#{ios_root}/#{components_dir}/PopupMenu/**/*.{swift,h}"]
  end

  s.subspec 'Presenters_ios' do |presenters_ios|
    presenters_ios.platform = :ios
    presenters_ios.dependency "#{s.name}/Obscurable_ios"
    presenters_ios.source_files = ["#{ios_root}/#{components_dir}/Presenters/**/*.{swift,h}"]
  end

  s.subspec 'ResizingHandleView_ios' do |resizinghandleview_ios|
    resizinghandleview_ios.platform = :ios
    resizinghandleview_ios.dependency "#{s.name}/Core_ios"
    resizinghandleview_ios.source_files = ["#{ios_root}/#{components_dir}/ResizingHandleView/**/*.{swift,h}"]
  end

  s.subspec 'SegmentedControl_ios' do |segmentedcontrol_ios|
    segmentedcontrol_ios.platform = :ios
    segmentedcontrol_ios.dependency "#{s.name}/Separator_ios"
    segmentedcontrol_ios.source_files = ["#{ios_root}/#{components_dir}/SegmentedControl/**/*.{swift,h}"]
  end

  s.subspec 'Separator_ios' do |separator_ios|
    separator_ios.platform = :ios
    separator_ios.dependency "#{s.name}/Core_ios"
    separator_ios.source_files = ["#{ios_root}/#{components_dir}/Separator/**/*.{swift,h}"]
  end

  s.subspec 'Shimmer_ios' do |shimmer_ios|
    shimmer_ios.platform = :ios
    shimmer_ios.dependency "#{s.name}/Core_ios"
    shimmer_ios.source_files = ["#{ios_root}/#{components_dir}/Shimmer/**/*.{swift,h}"]
  end

  s.subspec 'TabBar_ios' do |tabbar_ios|
    tabbar_ios.platform = :ios
    tabbar_ios.dependency "#{s.name}/Avatar_ios"
    tabbar_ios.dependency "#{s.name}/Label_ios"
    tabbar_ios.dependency "#{s.name}/Separator_ios"
    tabbar_ios.source_files = ["#{ios_root}/#{components_dir}/TabBar/**/*.{swift,h}"]
  end

  s.subspec 'TableView_ios' do |tableview_ios|
    tableview_ios.platform = :ios
    tableview_ios.dependency "#{s.name}/Label_ios"
    tableview_ios.dependency "#{s.name}/Separator_ios"
    tableview_ios.dependency "#{s.name}/TableViewListShared_ios"
    tableview_ios.preserve_paths = ["#{ios_root}/#{components_dir}/TableView/TableView.resources.xcfilelist"]
    tableview_ios.source_files = ["#{ios_root}/#{components_dir}/TableView/**/*.{swift,h}"]
  end

  s.subspec 'TableViewListShared_ios' do |tableviewlistshared_ios|
    tableviewlistshared_ios.platform = :ios
    tableviewlistshared_ios.dependency "#{s.name}/Core_ios"
    tableviewlistshared_ios.preserve_paths = ["#{ios_root}/#{components_dir}/TableViewListShared/TableViewListShared.resources.xcfilelist"]
    tableviewlistshared_ios.source_files = ["#{ios_root}/#{components_dir}/TableViewListShared/**/*.{swift,h}"]
  end

  s.subspec 'TextField_ios' do |textfield_ios|
    textfield_ios.platform = :ios
    textfield_ios.dependency "#{s.name}/Button_ios"
    textfield_ios.dependency "#{s.name}/Label_ios"
    textfield_ios.dependency "#{s.name}/Separator_ios"
    textfield_ios.preserve_paths = ["#{ios_root}/#{components_dir}/TextField/TextField.resources.xcfilelist"]
    textfield_ios.source_files = ["#{ios_root}/#{components_dir}/TextField/**/*.{swift,h}"]
  end

  s.subspec 'Tooltip_ios' do |tooltip_ios|
    tooltip_ios.platform = :ios
    tooltip_ios.dependency "#{s.name}/Label_ios"
    tooltip_ios.dependency "#{s.name}/TouchForwardingView_ios"
    tooltip_ios.preserve_paths = ["#{ios_root}/#{components_dir}/Tooltip/Tooltip.resources.xcfilelist"]
    tooltip_ios.source_files = ["#{ios_root}/#{components_dir}/Tooltip/**/*.{swift,h}"]
  end

  s.subspec 'TouchForwardingView_ios' do |touchforwardingview_ios|
    touchforwardingview_ios.platform = :ios
    touchforwardingview_ios.dependency "#{s.name}/Core_ios"
    touchforwardingview_ios.source_files = ["#{ios_root}/#{components_dir}/TouchForwardingView/**/*.{swift,h}"]
  end

  s.subspec 'TwoLineTitleView_ios' do |twoLinetitleview_ios|
    twoLinetitleview_ios.platform = :ios
    twoLinetitleview_ios.dependency "#{s.name}/EasyTapButton_ios"
    twoLinetitleview_ios.dependency "#{s.name}/Label_ios"
    twoLinetitleview_ios.preserve_paths = ["#{ios_root}/#{components_dir}/TwoLineTitleView/TwoLineTitleView.resources.xcfilelist"]
    twoLinetitleview_ios.source_files = ["#{ios_root}/#{components_dir}/TwoLineTitleView/**/*.{swift,h}"]
  end


# Mac

  s.subspec 'AvatarView_mac' do |avatarview_mac|
    avatarview_mac.platform = :osx
    avatarview_mac.dependency "#{s.name}/Core_mac"
    avatarview_mac.source_files = ["#{macos_root}/#{components_dir}/AvatarView/**/*.{swift,h}"]
  end

  s.subspec 'BadgeView_mac' do |badgeview_mac|
    badgeview_mac.platform = :osx
    badgeview_mac.dependency "#{s.name}/Core_mac"
    badgeview_mac.source_files = ["#{macos_root}/#{components_dir}/Badge/**/*.{swift,h}"]
  end

  s.subspec 'Button_mac' do |button_mac|
    button_mac.platform = :osx
    button_mac.dependency "#{s.name}/Core_mac"
    button_mac.source_files = ["#{macos_root}/#{components_dir}/Button/**/*.{swift,h}"]
  end

  s.subspec 'Core_mac' do |core_mac|
    core_mac.platform = :osx
    core_mac.dependency "#{s.name}/Core_common"
    core_mac.resource_bundle = { 'FluentUIResources-macos' => ["#{macos_root}/#{resources_dir}/**/*.{storyboard,xib,xcassets,strings,stringsdict}"] }
    core_mac.source_files = ["#{macos_root}/#{core_dir}/**/*.{swift,h}"]
  end

  s.subspec 'DatePicker_mac' do |datepicker_mac|
    datepicker_mac.platform = :osx
    datepicker_mac.dependency "#{s.name}/Core_mac"
    datepicker_mac.source_files = ["#{macos_root}/#{components_dir}/DatePicker/**/*.{swift,h}"]
  end

  s.subspec 'Link_mac' do |link_mac|
    link_mac.platform = :osx
    link_mac.dependency "#{s.name}/Core_mac"
    link_mac.source_files = ["#{macos_root}/#{components_dir}/Link/**/*.{swift,h}"]
  end

  s.subspec 'MultilinePillPicker_mac' do |multilinepillpicker_mac|
    multilinepillpicker_mac.platform = :osx
    multilinepillpicker_mac.dependency "#{s.name}/Core_mac"
    multilinepillpicker_mac.source_files = ["#{macos_root}/#{components_dir}/MultilinePillPicker/**/*.{swift,h}"]
  end

  s.subspec 'Separator_mac' do |separator_mac|
    separator_mac.platform = :osx
    separator_mac.dependency "#{s.name}/Core_mac"
    separator_mac.source_files = ["#{macos_root}/#{components_dir}/Separator/**/*.{swift,h}"]
  end

end
