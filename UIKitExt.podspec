Pod::Spec.new do |s|
  s.name             = 'UIKitExt'
  s.version          = '1.0.0'
  s.summary          = 'UIKit Extensions'
  s.homepage         = 'https://github.com/wordlessj/UIKitExt'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Javier Zhang'
  s.source           = { :git => 'https://github.com/wordlessj/UIKitExt.git', :tag => s.version.to_s }
  s.swift_version    = '4.2'
  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/**/*.swift'
end
