#
# Be sure to run `pod lib lint ParallaxScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ParallaxScrollView'
  s.version          = '1.0.2'
  s.summary          = 'Scroll Item is parallax'
  s.description      = <<-DESC
This lib is like ClubHouse View.
Scroll Items width parallax
                       DESC

  s.homepage         = 'https://github.com/outofcoding/ParallaxScrollView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'outofcoding' => 'outofcoding@gmail.com' }
  s.source           = { :git => 'https://github.com/outofcoding/ParallaxScrollView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'ParallaxScrollView/Classes/**/*'
  s.swift_version = '5.0'
end
