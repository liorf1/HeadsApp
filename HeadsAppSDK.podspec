#
# Be sure to run `pod lib lint HeadsAppSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "HeadsAppSDK"
  s.version          = "0.1.3"
  s.summary          = "HeadsApp lets Mobile App developers integrate a single SDK once, and use any Ad Provider, to control and optimize monetization"

  s.description      = <<-DESC
HeadsApp lets Mobile App developers integrate a single SDK once, and use any Ad Provider, to control and optimize monetization
- Work with any ad provider using a single code and change or add Ad Provides quickly and easily.
- Communicate and test several Ad Providers simultaneously.
- Keep your App light, even when working with multiple Ad Providers.
- Don’t waste time recoding and re-launching every time you change ad providers.
                       DESC

  s.homepage         = "https://headsapp-tech.com"
  s.license          = {
    "type"=> "Copyright",
    "text"=> "Copyright 2016 Headsapp. All rights reserved.\n\nBy downloading the HeadsApp SDK or sample apps, you are granted a limited, non-commercial license to use and review the SDK or sample apps. If you wish to integrate the SDK into any commercial application, you must fully register an account in www.headsapp-tech.com." 
  }
  s.author           = { "Headsapp" => "lior@headsapp-tech.com" }
  s.source           = { :git => "https://github.com/liorf1/HeadsApp.git", :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.ios.vendored_frameworks = 'HeadsAppSDK.framework'
  s.preserve_paths = 'HeadsAppSDK.framework'

  s.frameworks = 'UIKit', 'CoreTelephony', 'AdSupport', 'CoreGraphics', 'AVFoundation', 'CoreMedia', 'QuartzCore', 'CoreMotion', 'CoreLocation'
  s.library = 'z'
  s.dependency 'AFNetworking', '~> 2.6.3'
end
