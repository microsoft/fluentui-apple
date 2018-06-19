Pod::Spec.new do |s|
  s.name         = "Office UI Fabric"
  s.version      = "0.0.1"
  s.summary      = "Office UI Fabric is a set of reusable UI controls and tools"
  s.homepage     = "https://onedrive.visualstudio.com/Design/The%20Studio/_git/fabric-ios"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author       = { "Vlad Filyakov" => "vladf@microsoft.com" }

  s.platform     = :ios
  s.ios.deployment_target = "10.0"

  s.source       = { :git => "https://onedrive.visualstudio.com/Design/The%20Studio/_git/fabric-ios", :tag => "#{s.version}" }
  s.source_files = "OfficeUIFabric/**/*"
  s.resources    = 'OfficeUIFabric/**/*.{storyboard,xib,ttf,xcassets,strings,stringsdict,json}'
end
