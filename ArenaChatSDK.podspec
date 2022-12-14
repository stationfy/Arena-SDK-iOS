#
# Be sure to run `pod lib lint ArenaChatSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ArenaChatSDK'
  s.version          = '0.0.1'
  s.summary          = 'Arena provides a ready-to-use live group chat activity.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://arena.im'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'vicenteerick' => 'vicente.erick@gmail.com' }
  s.source           = { :git => 'https://github.com/stationfy/Arena-SDK-iOS.git', :tag => '0.0.1' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = '4.2'

  s.source_files = 'ArenaChatSDK/Classes/**/*'
  s.ios.vendored_frameworks = 'Configuration.xcframework'
  s.resource_bundles = {
    'ArenaChatSDK' => ['ArenaChatSDK/**/*.png', 'ArenaChatSDK/**/*.pdf', 'ArenaChatSDK/**/*.lproj/*.strings', '**/*.xcframework']
  }

  s.resources = 'ArenaChatSDK/**/*.{storyboard,xib,xcassets,json,png}'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Socket.IO-Client-Swift', '~> 16.0.1'
  s.dependency 'FirebaseFirestore'
  s.dependency 'Apollo'
  s.dependency 'KeychainSwift', '~> 20.0'
  s.dependency 'Kingfisher', '~> 7.0'
end
