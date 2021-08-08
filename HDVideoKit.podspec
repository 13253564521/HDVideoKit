
Pod::Spec.new do |spec|
  spec.name         = "HDVideoKit"
  spec.version      = "0.0.2"
  spec.summary      = "HDVideoKit,为解放行APP提供特定服务"
  spec.description  = <<-DESC
    使用Cocoapods制作的HDVideoKit,为解放行APP提供特定服务。
                   DESC

  spec.homepage     = "https://github.com/13253564521/HDVideoKit"

  spec.license      = { :type => "MIT", :file => "README.md" }
  spec.author       = { "liugaosheng" => "liu695880140@163.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/13253564521/HDVideoKit.git", :tag => spec.version }
  spec.source_files  = "HDVIdeoKit/Classes/**/*.{h,m}", "HDVIdeoKit/Classes/**/**/*.{h,m}", "HDVIdeoKit/Classes/**/**/**/*.{h,m}"
  spec.public_header_files = "HDVIdeoKit/Classes/Entrance/*.h", "HDVIdeoKit/Classes/Shoot/Controller/*.h", "HDVIdeoKit/Classes/LiveRelease/Controller/*.h", "HDVIdeoKit/Classes/Report/*.h", "HDVIdeoKit/Classes/LiveList/*.h", "HDVIdeoKit/Classes/faxian/Controller/*.h"
  spec.resources = ['HDVIdeoKit/Classes/HDVideoKitResources.bundle', 'HDVIdeoKit/Classes/PLShortVideoKit.bundle','HDVIdeoKit/Classes/**/*.{xib}', 'HDVIdeoKit/Classes/**/**/*.{xib}', 'HDVIdeoKit/Classes/**/**/**/*.{xib}']
  spec.frameworks = "Foundation", "CoreGraphics", "UIKit", "MediaPlayer", "CoreAudio", "AudioToolbox", "Accelerate", "QuartzCore", "OpenGLES", "AVFoundation", "CoreVideo", "AVKit", "CoreMedia", "VideoToolbox", "CoreTelephony","CFNetwork", "Security"
  spec.static_framework = true
  spec.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => '' }

  spec.dependency "TZImagePickerController"
  spec.dependency "SDWebImage"
  spec.dependency "PGDatePicker"
  spec.dependency "SocketRocket"
  spec.dependency "Masonry"
  spec.dependency "PLMediaStreamingKit"
  spec.dependency "PLPlayerKit"
  spec.dependency "PLShortVideoKit"
  spec.dependency "SVProgressHUD", "~> 2.2.5"
  spec.dependency "JFWechat", "~> 1.0.0"
  spec.dependency "MJRefresh", "~> 3.4"
  spec.dependency "YYWebImage", "~> 1.0.5"
  spec.dependency "MJExtension", "~> 3.0.13"
  spec.dependency "IQKeyboardManager", "~> 6.5.0"

  
end
