Pod::Spec.new do |s|
  s.name             = 'FluentUI'
  s.version          = '0.0.2'
  s.summary          = 'Fluent UI is a set of reusable UI controls and tools'
  s.homepage         = "https://www.microsoft.com/design/fluent/#/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Microsoft" => "fluentuinativeowners@microsoft.com"}
  s.source       = { :git => "https://github.com/microsoft/fluentui-apple.git", :tag => "#{s.version}" }
  s.swift_version = "5.0"
  
  s.ios.deployment_target = "11.0"
  s.ios.source_files   = "ios/FluentUI/**/*.{swift,h}"
  s.ios.resource_bundle = { 'FluentUIResources-ios' => "ios/FluentUI/**/*.{storyboard,xib,xcassets,strings,stringsdict}" }
  
  s.osx.deployment_target = "10.13"
  s.osx.source_files   = "macos/FluentUI/**/*.{swift,h}"
  s.osx.resource_bundle = { 'FluentUIResources-macos' => "macos/FluentUI/**/*.{storyboard,xib,xcassets,strings,stringsdict}" }
end
