Pod::Spec.new do |s|
  s.name         = 'KNewbieGuide'
  s.version      = '0.2'
  s.summary      = '快速编写新手引导页工具'
  s.homepage     = 'https://github.com/kuah/KNewbieGuide'
  s.author       = "Kuah => 284766710@qq.com"
  s.source       = {:git => 'https://github.com/kuah/KNewbieGuide.git', :tag => "#{s.version}"}
  s.source_files = "source/**/*.{h,m}"
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.license = 'MIT'
  s.dependency 'SCMapCatch', '~> 0.1.1'
end
