Pod::Spec.new do |s|
  s.name         = 'SGen'
  s.version      = '0.0.2'
  s.summary      = 'Get strong typed, autocompleted resources, color swatches and font styles in Swift projects from a simple, human readable Yaml stylesheet'

  s.description  = <<-DESC
                   Get strong typed, autocompleted resources, color swatches and font styles in Swift projects from a simple, human readable Yaml stylesheet
                   DESC

  s.homepage     = 'https://github.com/stardust-ui/react'
  s.screenshots  = 'https://stardust-ui.github.io/react/logo.png'

  s.license      = { :type => 'Microsoft', :text => <<-LICENSE
                     Copyright (c) 2019 Microsoft Corporation. All Rights Reserved.
                     LICENSE
                   }
  s.author       = { 
    'Daniele Pizziconi' => 'danielep@microsoft.com'
  }

  s.source = {
    http: "https://skype.visualstudio.com/SCC/_git/client_ios_sgen?path=/releases/download/#{s.version}/sgen-#{s.version}.zip"
  }
  s.preserve_paths = '*'
  s.exclude_files = '**/file.zip'
end
