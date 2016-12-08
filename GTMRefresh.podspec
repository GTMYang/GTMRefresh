

Pod::Spec.new do |s|

  s.name         = "GTMRefresh"
  s.version      = "0.0.1"
  s.summary      = "swift3 实现的Loadding动画库"

  s.homepage     = "https://github.com/GTMYang/GTMRefresh"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "GTMYang" => "17757128523@163.com" }


  s.source       = { :git => "https://github.com/GTMYang/GTMRefresh.git", :tag => s.version }
  s.source_files = "GTMRefresh/*.{h,swift}"

  s.ios.deployment_target = "8.0"
  s.frameworks = "UIKit"

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }

end
