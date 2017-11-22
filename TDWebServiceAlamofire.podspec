#
# Be sure to run `pod lib lint TDWebServiceAlamofire.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TDWebServiceAlamofire'
  s.version          = '4.5.1.2'
  s.summary          = 'An Alamofire API for TDWebService'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An Alamofire API for TDWebService. Use this directly if you need to use Alamofire
                       DESC

  s.homepage         = 'https://github.com/trident10/TDWebService-Alamofire'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'trident10' => 'abhimanyujindal10@gmail.com' }
  s.source           = { :git => 'https://github.com/trident10/TDWebService-Alamofire.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TDWebServiceAlamofire/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TDWebServiceAlamofire' => ['TDWebServiceAlamofire/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'TDWebService'
end
