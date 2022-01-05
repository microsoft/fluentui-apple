Pod::Spec.new do |s|
  s.name             = 'MicrosoftFluentUIVnext'
  s.version          = '0.0.5'
  s.summary          = 'Fluent UI is a set of reusable UI controls and tools'
  s.homepage         = "https://www.microsoft.com/design/fluent/#/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Microsoft" => "fluentuinativeowners@microsoft.com"}
  s.source       = { :git => "https://github.com/microsoft/fluentui-apple.git", :branch => 'vnext-prototype', :tag => "#{s.version}_Vnext" }
  s.swift_version = "5.3.1"
  s.module_name = 'FluentUI'


# iOS

  s.ios.deployment_target = "14.0"
  
  s.subspec 'ActivityIndicator_ios' do |activityindicator_ios|
    activityindicator_ios.platform = :ios
    activityindicator_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    activityindicator_ios.source_files = ["ios/FluentUI/ActivityIndicator/**/*.{swift,h}"]
  end

  s.subspec 'Avatar_ios' do |avatar_ios|
    avatar_ios.platform = :ios
    avatar_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    avatar_ios.preserve_paths = ["ios/FluentUI/Avatar/Avatar.resources.xcfilelist"]
    avatar_ios.source_files = ["ios/FluentUI/Avatar/**/*.{swift,h}"]
  end

  s.subspec 'AvatarGroup_ios' do |avatarGroup_ios|
    avatarGroup_ios.platform = :ios
    avatarGroup_ios.dependency 'MicrosoftFluentUIVnext/Avatar_ios'
        avatarGroup_ios.source_files = ["ios/FluentUI/AvatarGroup/**/*.{swift,h}"]
  end

  s.subspec 'Button_ios' do |button_ios|
    button_ios.platform = :ios
    button_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    button_ios.source_files = ["ios/FluentUI/Vnext/Button/**/*.{swift,h}"]
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
xcodebuild ${XCODEBUILDPARAMS} -project ${PROJECT_FILE_PATH} -target "MicrosoftFluentUIVnext-FluentUIResources-ios" -sdk ${PLATFORM_NAME} -configuration ${CONFIGURATION} ARCHS="${ARCHS}" CONFIGURATION_BUILD_DIR="${CONFIGURATION_BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" BUILT_PRODUCTS_DIR="${BUILT_PRODUCTS_DIR}" ${ACTION}',
                              :execution_position => :before_compile }
    core_ios.preserve_paths = ["ios/FluentUI/Core/Core.resources.xcfilelist",
                               "scripts/removeUnusedResourcesFromAssets.swift"]
    core_ios.source_files = ["ios/FluentUI/Core/**/*.{swift,h}",
                             "ios/FluentUI/Extensions/*.{swift,h}"]
  end

  s.subspec 'Divider_ios' do |divider_ios|
    divider_ios.platform = :ios
    divider_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    divider_ios.source_files = ["ios/FluentUI/Vnext/Divider/**/*.{swift,h}"]
  end

  s.subspec 'Drawer_ios' do |drawer_ios|
    drawer_ios.platform = :ios
    drawer_ios.dependency 'MicrosoftFluentUIVnext/Obscurable_ios'
    drawer_ios.dependency 'MicrosoftFluentUIVnext/ResizingHandleView_ios'
    drawer_ios.dependency 'MicrosoftFluentUIVnext/Separator_ios'
    drawer_ios.dependency 'MicrosoftFluentUIVnext/TouchForwardingView_ios'
    drawer_ios.source_files = ["ios/FluentUI/Drawer/**/*.{swift,h}"]
  end

  s.subspec 'List_ios' do |list_ios|
    list_ios.platform = :ios
    list_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    list_ios.source_files = ["ios/FluentUI/Vnext/List/**/*.{swift,h}"]
  end

  s.subspec 'PersonaView_ios' do |personaView_ios|
    personaView_ios.platform = :ios
    personaView_ios.dependency 'MicrosoftFluentUIVnext/Avatar_ios'
    personaView_ios.dependency 'MicrosoftFluentUIVnext/List_ios'
    personaView_ios.source_files = ["ios/FluentUI/Vnext/Persona/**/*.{swift,h}"]
  end

  s.subspec 'PersonaButton_ios' do |personaButton_ios|
    personaButton_ios.platform = :ios
    personaButton_ios.dependency 'MicrosoftFluentUIVnext/Avatar_ios'
    personaButton_ios.source_files = ["ios/FluentUI/PersonaButton/**/*.{swift,h}"]
  end

  s.subspec 'PersonaButtonCarousel_ios' do |personaButtonCarousel_ios|
    personaButtonCarousel_ios.platform = :ios
    personaButtonCarousel_ios.dependency 'MicrosoftFluentUIVnext/PersonaButton_ios'
    personaButtonCarousel_ios.source_files = ["ios/FluentUI/PersonaButtonCarousel/**/*.{swift,h}"]
  end

  s.subspec 'Obscurable_ios' do |obscurable_ios|
    obscurable_ios.platform = :ios
    obscurable_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    obscurable_ios.source_files = ["ios/FluentUI/Obscurable/**/*.{swift,h}"]
  end

  s.subspec 'ResizingHandleView_ios' do |resizinghandleview_ios|
    resizinghandleview_ios.platform = :ios
    resizinghandleview_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    resizinghandleview_ios.source_files = ["ios/FluentUI/ResizingHandleView/**/*.{swift,h}"]
  end

  s.subspec 'Separator_ios' do |separator_ios|
    separator_ios.platform = :ios
    separator_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    separator_ios.source_files = ["ios/FluentUI/Separator/**/*.{swift,h}"]
  end

  s.subspec 'TouchForwardingView_ios' do |touchforwardingview_ios|
    touchforwardingview_ios.platform = :ios
    touchforwardingview_ios.dependency 'MicrosoftFluentUIVnext/Core_ios'
    touchforwardingview_ios.source_files = ["ios/FluentUI/TouchForwardingView/**/*.{swift,h}"]
  end

end
