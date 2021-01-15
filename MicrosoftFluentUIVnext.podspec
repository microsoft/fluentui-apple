Pod::Spec.new do |s|
  s.name             = 'MicrosoftFluentUIVnext'
  s.version          = '0.0.1'
  s.summary          = 'Fluent UI is a set of reusable UI controls and tools'
  s.homepage         = "https://www.microsoft.com/design/fluent/#/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Microsoft" => "fluentuinativeowners@microsoft.com"}
  s.source       = { :git => "https://github.com/microsoft/fluentui-apple.git", :branch => 'vnext-prototype', :tag => "#{s.version}" }
  s.swift_version = "5.3.1"
  s.module_name = 'FluentUI'


# iOS

  s.ios.deployment_target = "13.0"

  s.subspec 'Core_ios' do |core_ios|
    core_ios.platform = :ios
    core_ios.resource_bundle = { 'FluentUIResources-ios' => ["apple/Resources/**/*.{json,xcassets}",
                                                             "ios/FluentUI/**/*.{storyboard,xib,xcassets,strings,stringsdict}"] }
    core_ios.source_files = ["ios/FluentUI/Core/Colors.swift",
                             "ios/FluentUI/Core/FluentUIFramework.swift",
                             "ios/FluentUI/Core/Fonts.swift",
                             "ios/FluentUI/Core/iOS13_4_compatibility.swift",
                             "ios/FluentUI/Core/UIViewAdapter.swift",
                             "ios/FluentUI/Extensions/Calendar+Extensions.swift",
                             "ios/FluentUI/Extensions/CharacterSet+Extension.swift",
                             "ios/FluentUI/Extensions/String+Extension.swift",
                             "ios/FluentUI/Extensions/UIColor+Extensions.swift",
                             "ios/FluentUI/Extensions/UIFont+Extension.swift",
                             "ios/FluentUI/Extensions/UIImage+Extensions.swift",
                             "ios/FluentUI/Extensions/UIScreen+Extension.swift",
                             "ios/FluentUI/Design Token System/**/*.{swift,h}"]
  end

  s.subspec 'Avatar_ios' do |avatar_ios|
    avatar_ios.platform = :ios
    avatar_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    avatar_ios.source_files = ["ios/FluentUI/AvatarVnext/**/*.{swift,h}",
                               "ios/FluentUI/People Picker/Avatar.swift",
                               "ios/FluentUI/People Picker/AvatarView.swift",
                               "ios/FluentUI/People Picker/InitialsView.swift",
                               "ios/FluentUI/People Picker/Presence.swift"]
  end

  s.subspec 'Button_ios' do |button_ios|
    button_ios.platform = :ios
    button_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    button_ios.source_files = ["ios/FluentUI/ButtonVnext/**/*.{swift,h}"]
  end

  s.subspec 'Drawer_ios' do |drawer_ios|
    drawer_ios.platform = :ios
    drawer_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    drawer_ios.source_files = ["ios/FluentUI/DrawerVnext/**/*.{swift,h}"]
  end

  s.subspec 'List_ios' do |list_ios|
    list_ios.platform = :ios
    list_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    list_ios.source_files = ["ios/FluentUI/ListVnext/**/*.{swift,h}"]
  end

end
