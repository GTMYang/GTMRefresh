

Pod::Spec.new do |s|

  s.name         = "GTMRefresh"
  s.version      = "1.3.4"
  s.summary      = "swift 实现的上拉刷新，下拉加载动效库"
  s.swift_version= "4.1.2"

  s.homepage     = "https://github.com/GTMYang/GTMRefresh"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "GTMYang" => "17757128523@163.com" }


  s.source       = { :git => "https://github.com/GTMYang/GTMRefresh.git", :tag => s.version }
  s.source_files = "GTMRefresh/*.{h,swift}"
  s.resources    = 'GTMRefresh/Resource/**/*'

  s.ios.deployment_target = "8.0"
  s.frameworks = "UIKit"

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
