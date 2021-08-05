
Pod::Spec.new do |spec|
  spec.name         = "HDVideoKit"
  spec.version      = "0.0.1"
  spec.summary      = "使用 Cocoapods 制作的 HDVideoKit"
  spec.description  = <<-DESC
    使用Cocoapods制作的HDVideoKit,为解放行APP提供特定服务。
                   DESC

  spec.homepage     = "https://github.com/13253564521/HDVideoKit.git"

  spec.license      = { :type => "MIT", :file => "README.md" }
  spec.author       = { "liugaosheng" => "liu695880140@163.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/13253564521/HDVideoKit.git", :tag => spec.version }
  
  spec.source_files  = "HDVIdeoKit/Classes/**/*.{h,m}", "HDVIdeoKit/Classes/**/**/*.{h,m}", "HDVIdeoKit/Classes/**/**/**/*.{h,m}"
  spec.resources = ['HDVIdeoKit/Classes/HDVideoKitResources.bundle', 'HDVIdeoKit/Classes/PLShortVideoKit.bundle','HDVIdeoKit/Classes/**/*.{xib}', 'HDVIdeoKit/Classes/**/**/*.{xib}', 'HDVIdeoKit/Classes/**/**/**/*.{xib}']
  spec.frameworks = "Foundation", "CoreGraphics", "UIKit", "MediaPlayer", "CoreAudio", "AudioToolbox", "Accelerate", "QuartzCore", "OpenGLES", "AVFoundation", "CoreVideo", "AVKit", "CoreMedia", "VideoToolbox", "CoreTelephony","CFNetwork", "Security"
  spec.static_framework = true

  spec.dependency "TZImagePickerController"
  spec.dependency "SDWebImage"
  spec.dependency "PGDatePicker"
  spec.dependency "SocketRocket"
  spec.dependency "SVProgressHUD", "~> 2.0.3"
  spec.dependency "Masonry", "~> 1.0.2"
  spec.dependency "MJRefresh", "~> 3.2.0"
  spec.dependency "YYWebImage", "~> 1.0.5"
  spec.dependency "MJExtension", "~> 3.0.13"
  spec.dependency "IQKeyboardManager", "~> 6.5.0"
  spec.dependency 'PLMediaStreamingKit', '~> 3.0.5'
  spec.dependency 'PLPlayerKit', '~> 3.4.6'
  spec.dependency 'PLShortVideoKit', '~> 3.2.5'
  spec.dependency 'WechatOpenSDK','1.8.6.2'
  
end