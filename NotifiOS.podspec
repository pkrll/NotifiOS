Pod::Spec.new do |s|
  s.name             = 'NotifiOS'
  s.version          = '0.1.0'
  s.summary          = 'Simple Notification View for iOS'
  s.description      = <<-DESC
                        NotifiOS provides the ability to create small notification popup views.
                       DESC
  s.homepage         = 'https://github.com/pkrll/NotifiOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ardalan Samimi' => 'ardalan@saturnfive.se' }
  s.source           = { :git => 'https://github.com/pkrll/NotifiOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pkrll'

  s.ios.deployment_target = '8.0'
  s.source_files = 'NotifiOS/Classes/**/*'
  s.frameworks = 'UIKit'
end
