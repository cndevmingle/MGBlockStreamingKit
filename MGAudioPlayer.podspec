#
#  Be sure to run `pod spec lint MGAudioPlayer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "MGAudioPlayer"
  s.version      = "0.0.2"
  s.summary      = "基于StreamingKit完成的音频播放"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  基于StreamingKit完成的音频播放库。
                   DESC

  s.homepage     = "https://github.com/cndevmingle/MGBlockStreamingKit"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Mingle" => "cndevmingle@gmail.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/cndevmingle/MGBlockStreamingKit.git", :tag => s.version.to_s }

  s.source_files  = "MGAudioPlayer/**/*.{h,m}"
 
  s.frameworks = "Foundation", "AudioToolbox"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
