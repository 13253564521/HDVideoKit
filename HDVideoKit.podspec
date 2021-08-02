
Pod::Spec.new do |spec|
  spec.name         = "HDVideoKit"
  spec.version      = "0.0.1"
  spec.summary      = "使用 Cocoapods 制作的 HDVideoKit"
  spec.description  = <<-DESC
    使用Cocoapods制作的HDVideoKit,为解放行APP提供特定服务。
                   DESC

  spec.homepage     = "https://github.com/13253564521/HDVideoKit.git"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "liugaosheng" => "liu695880140@163.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/13253564521/HDVideoKit.git", :tag => spec.version }
  spec.source_files  = "Classes", "HDVIdeoKit/Classes/**/*.{h,m,mm}", "HDVIdeoKit/Classes/**/**/*.{h,m,mm}", "HDVIdeoKit/Classes/**/**/**/*.{h,m,mm}"
  spec.resources = ['HDVIdeoKit/Classes/HDVideoKitResources.bundle/*', 'HDVIdeoKit/Classes/PLShortVideoframework/PLShortVideoKit.bundle/*','HDVIdeoKit/Classes/**/*.{xib}', 'HDVIdeoKit/Classes/**/**/*.{xib}', 'HDVIdeoKit/Classes/**/**/**/*.{xib}']
  spec.frameworks = "Foundation", "CoreGraphics", "UIKit", "MediaPlayer", "CoreAudio", "AudioToolbox", "Accelerate", "QuartzCore", "OpenGLES", "AVFoundation", "CoreVideo", "AVKit", "CoreMedia", "VideoToolbox", "CoreTelephony"

  spec.libraries = "iconv", "resolv", "z", "c++", "bz2"
  spec.vendored_frameworks = ['HDVIdeoKit/UseFramework/PLMediaStreamingKit.framework',
  'HDVIdeoKit/UseFramework/PLPlayerKit.framework','HDVIdeoKit/Classes/PLShortVideoframework/PLShortVideoKit.framework']
  spec.user_target_xcconfig =   {'OTHER_LDFLAGS' => ['-ObjC']}
  spec.requires_arc = true
  spec.dependency "TZImagePickerController"
  spec.dependency "SDWebImage"
  spec.dependency "PGDatePicker"
  spec.dependency "SocketRocket"
  spec.dependency "SVProgressHUD", "~> 2.0.3"
  spec.dependency "Masonry", "~> 1.0.2"
  spec.dependency "MJRefresh", "~> 3.2.0"
  spec.dependency "YYWebImage", "~> 1.0.5"
  spec.dependency "MJExtension", "~> 3.0.13"
  spec.dependency "WechatOpenSDK", "~> 1.8.6.2"
  spec.dependency "IQKeyboardManager", "~> 6.5.0"
  spec.dependency "Qiniu", "~> 7.4.4"
  
end
