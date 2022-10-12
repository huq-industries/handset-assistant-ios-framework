#
# Be sure to run `pod lib lint HandsetAssistant.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HandsetAssistant'
  s.version          = '1.0.3'
  s.summary          = 'This is a helper library that ensures we collect fields for the Handset product consistently.'

# This description is used to generate tags and improve search results.
  s.description      = <<-DESC
This is a helper library for distribution via Cocoapods
Using this library will enable Huq App partners to collect and submit the fields required for being part of the Huq Handset partner program consistently and safely.
                       DESC

  s.homepage         = 'https://github.com/huq-industries/handset-assistant-ios-framework'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Copyright', :file => 'LICENSE' }
  s.author           = { 'turbomerl' => 'isambard@huq.io' }
  s.source           = { :git => 'https://github.com/huq-industries/handset-assistant-ios-framework.git', :tag => s.version.to_s }
  s.swift_version    = '5.0'
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'HandsetAssistant/*'
  s.exclude_files = 'HandsetAssistant/Info.plist'
  
end
