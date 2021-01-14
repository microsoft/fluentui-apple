Pod::Spec.new do |s|
  s.name             = 'MicrosoftFluentUI'
  s.version          = '0.2.0'
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
    core_ios.source_files = ["ios/FluentUI/Controls/ButtonVnext.swift",
                             "ios/FluentUI/Core/Colors.swift",
                             "ios/FluentUI/Core/FluentUIFramework.swift",
                             "ios/FluentUI/Core/Fonts.swift",
                             "ios/FluentUI/Core/iOS13_4_compatibility.swift",
                             "ios/FluentUI/Core/ThemingVnext.swift",
                             "ios/FluentUI/Core/UIViewAdapter.swift",
                             "ios/FluentUI/DrawerVnext/**/*.{swift,h}",
                             "ios/FluentUI/Extensions/Calendar+Extensions.swift",
                             "ios/FluentUI/Extensions/CharacterSet+Extension.swift",
                             "ios/FluentUI/Extensions/String+Extension.swift",
                             "ios/FluentUI/Extensions/UIColor+Extensions.swift",
                             "ios/FluentUI/Extensions/UIFont+Extension.swift",
                             "ios/FluentUI/Extensions/UIImage+Extensions.swift",
                             "ios/FluentUI/Extensions/UIScreen+Extension.swift",
                             "ios/FluentUI/Generated/**/*.{swift,h}",
                             "ios/FluentUI/People Picker/AvatarViewVnext.swift",
                             "ios/FluentUI/People Picker/Avatar.swift",
                             "ios/FluentUI/People Picker/AvatarView.swift",
                             "ios/FluentUI/People Picker/InitialsView.swift",
                             "ios/FluentUI/People Picker/Presence.swift",
                             "ios/FluentUI/Table View/ListVnext.swift"]
  end

end
