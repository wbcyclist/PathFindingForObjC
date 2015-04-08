Pod::Spec.new do |s|
  s.name     = 'PathFindingForObjC'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.homepage = 'https://github.com/wbcyclist/PathFindingForObjC'
  s.author   = { 'Jasio Woo' => 'wbcyclist@gmail.com' }
  s.summary  = 'A Comprehensive PathFinding Library for Objective-C'
  s.screenshots = [ "https://raw.githubusercontent.com/wbcyclist/PathFindingForObjC/master/demo/PathFinding_ScreenShot.png" ]
  s.source   = { :git => 'https://github.com/wbcyclist/PathFindingForObjC.git', :tag => s.version }
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.ios.frameworks = 'UIKit'
  s.osx.frameworks = 'AppKit'

  s.source_files = 'PathFindingForObjC/**/*.{h,m}'

end
