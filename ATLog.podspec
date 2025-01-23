#
# Be sure to run `pod lib lint ATLog.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ATLog'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ATLog.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yebiaoli/ATLog'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yebiaoli' => 'yebiao.li@ihoment.com' }
  s.source           = { :git => 'https://github.com/yebiaoli/ATLog.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.watchos.deployment_target = '3.0'

  s.default_subspecs = ['Core']

  s.subspec 'Core' do |ss|
    ss.source_files = 'ATLog/Classes/Core/**/*'
  end

  s.subspec 'ForCocoaLumberjack' do |ss|
    ss.dependency 'ATLog/Core'
    ss.dependency 'CocoaLumberjack/Swift', '~> 3.7.2'
    ss.source_files ='ATLog/Classes/ForCocoaLumberjack/**/*'
  end

  s.subspec 'ForiPad' do |ss|
    ss.dependency 'ATLog/Core'
    ss.source_files = 'ATLog/Classes/ForiPad/**/*'
  end

  s.subspec 'ForiWatch' do |ss|
    ss.dependency 'ATLog/Core'
    ss.source_files = 'ATLog/Classes/ForiWatch/**/*'
  end
  
end
