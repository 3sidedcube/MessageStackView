Pod::Spec.new do |s|
  s.name = 'MessageStackView'
  s.version = '3.0.0'
  s.license = 'MIT'
  s.summary = 'Simple wrapper of UIStackView for posting and removing messages'
  s.homepage = 'https://github.com/3sidedcube/MessageStackView'
  s.authors = { '3 Sided Cube' => 'https://3sidedcube.com' }
  s.source = { :git => 'https://github.com/3sidedcube/MessageStackView.git', :tag => s.version }
  s.documentation_url = s.homepage

  s.ios.deployment_target = '14.0'
  s.swift_versions = ['5.7']
  s.source_files = 'Sources/**/*.{swift,h,m}'
  s.ios.framework  = 'UIKit'
end
