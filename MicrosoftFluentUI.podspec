Pod::Spec.new do |s|
  s.name             = 'MicrosoftFluentUI'
  s.version          = '0.1.17'
  s.summary          = 'Fluent UI is a set of reusable UI controls and tools'
  s.homepage         = "https://www.microsoft.com/design/fluent/#/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Microsoft" => "fluentuinativeowners@microsoft.com"}
  s.source       = { :git => "https://github.com/microsoft/fluentui-apple.git", :tag => "#{s.version}" }
  s.swift_version = "5.0"
  s.module_name = 'FluentUI'


# iOS

  s.ios.deployment_target = "11.0"

  s.subspec 'Calendar_ios' do |calendar_ios|
    calendar_ios.platform = :ios
    calendar_ios.dependency 'MicrosoftFluentUI/Presenters_ios'
    calendar_ios.source_files = ["ios/FluentUI/Calendar/**/*.{swift,h}",
                                 "ios/FluentUI/Date Time Pickers/**/*.{swift,h}"]
  end

  s.subspec 'Card_ios' do |card_ios|
    card_ios.platform = :ios
    card_ios.dependency 'MicrosoftFluentUI/Controls_ios'
    card_ios.source_files = ["ios/FluentUI/Card/**/*.{swift,h}"]
  end

  s.subspec 'Controls_ios' do |controls_ios|
    controls_ios.platform = :ios
    controls_ios.dependency 'MicrosoftFluentUI/Core_ios'
    controls_ios.source_files = ["ios/FluentUI/Badge Field/**/*.{swift,h}",
                                 "ios/FluentUI/Controls/**/*.{swift,h}",
                                 "ios/FluentUI/Navigation/**/*.{swift,h}",
                                 "ios/FluentUI/People Picker/**/*.{swift,h}",
                                 "ios/FluentUI/Table View/**/*.{swift,h}"]
  end

  s.subspec 'Core_ios' do |core_ios|
    core_ios.platform = :ios
    core_ios.resource_bundle = { 'FluentUIResources-ios' => ["apple/Resources/**/*.{json,xcassets}",
                                                             "ios/FluentUI/**/*.{storyboard,xib,xcassets,strings,stringsdict}"] }
    core_ios.source_files = ["ios/FluentUI/Configuration/**/*.{swift,h}",
                             "ios/FluentUI/Core/**/*.{swift,h}",
                             "ios/FluentUI/Extensions/**/*.{swift,h}"]
  end

  s.subspec 'Drawer_ios' do |drawer_ios|
    drawer_ios.platform = :ios
    drawer_ios.dependency 'MicrosoftFluentUI/Controls_ios'
    drawer_ios.source_files = ["ios/FluentUI/Drawer/**/*.{swift,h}"]
  end

  s.subspec 'HUD_ios' do |hud_ios|
    hud_ios.platform = :ios
    hud_ios.dependency 'MicrosoftFluentUI/Controls_ios'
    hud_ios.source_files = ["ios/FluentUI/HUD/**/*.{swift,h}"]
  end

  s.subspec 'Notification_ios' do |notification_ios|
    notification_ios.platform = :ios
    notification_ios.dependency 'MicrosoftFluentUI/Controls_ios'
    notification_ios.source_files = ["ios/FluentUI/Notification/**/*.{swift,h}"]
  end

  s.subspec 'PillButtonBar_ios' do |pillbuttonbar_ios|
    pillbuttonbar_ios.platform = :ios
    pillbuttonbar_ios.dependency 'MicrosoftFluentUI/Core_ios'
    pillbuttonbar_ios.source_files = ["ios/FluentUI/Pill Button Bar/**/*.{swift,h}"]
  end

  s.subspec 'PopupMenu_ios' do |popupmenu_ios|
    popupmenu_ios.platform = :ios
    popupmenu_ios.dependency 'MicrosoftFluentUI/Drawer_ios'
    popupmenu_ios.source_files = ["ios/FluentUI/Popup Menu/**/*.{swift,h}"]
  end

  s.subspec 'Presenters_ios' do |presenters_ios|
    presenters_ios.platform = :ios
    presenters_ios.dependency 'MicrosoftFluentUI/Controls_ios'
    presenters_ios.source_files = ["ios/FluentUI/Presenters/**/*.{swift,h}"]
  end

  s.subspec 'Shimmer_ios' do |shimmer_ios|
    shimmer_ios.platform = :ios
    shimmer_ios.dependency 'MicrosoftFluentUI/Core_ios'
    shimmer_ios.dependency 'MicrosoftFluentUI/Utilities_ios'
    shimmer_ios.source_files = ["ios/FluentUI/Shimmer/**/*.{swift,h}"]
  end

  s.subspec 'TabBar_ios' do |tabbar_ios|
    tabbar_ios.platform = :ios
    tabbar_ios.dependency 'MicrosoftFluentUI/Controls_ios'
    tabbar_ios.source_files = ["ios/FluentUI/Tab Bar/**/*.{swift,h}"]
  end

  s.subspec 'Tooltip_ios' do |tooltip_ios|
    tooltip_ios.platform = :ios
    tooltip_ios.dependency 'MicrosoftFluentUI/Controls_ios'
    tooltip_ios.source_files = ["ios/FluentUI/Tooltip/**/*.{swift,h}"]
  end

  s.subspec 'Utilities_ios' do |utilities_ios|
    utilities_ios.platform = :ios
    utilities_ios.source_files = ["ios/FluentUI/Utilities/**/*.{swift,h}"]
  end


# Mac

  s.osx.deployment_target = "10.13"

  s.subspec 'AvatarView_mac' do |avatarview_mac|
    avatarview_mac.platform = :osx
    avatarview_mac.dependency 'MicrosoftFluentUI/Core_mac'
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
                                                             "macos/FluentUIResources-macos/**/*.{storyboard,xib,xcassets,strings,stringsdict}"] }
    core_mac.source_files = ["macos/FluentUI/Core/**/*.{swift,h}"]
  end

  s.subspec 'DatePicker_mac' do |datepicker_mac|
    datepicker_mac.platform = :osx
    datepicker_mac.dependency 'MicrosoftFluentUI/Core_mac'
    datepicker_mac.source_files = ["macos/FluentUI/DatePicker/**/*.{swift,h}"]
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
