
Pod::Spec.new do |s|
  s.name             = 'XDNetwork'
  s.version          = '1.0.0'
  s.summary          = 'A short description of XDNetwork.'
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/shwrt2016/XDNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shwrt2016@gmail.com' => '176675388@qq.com' }
  s.source           = { :git => 'https://github.com/shwrt2016/XDNetwork.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'XDNetwork/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'AFNetworking'
  s.dependency 'MBProgressHUD'
  
end
