Pod::Spec.new do |s|
  s.name             = 'NativeJSONMapper'
  s.version          = '1.0.0'
  s.summary          = 'Simple Swift 4 encoding & decoding'
 
  s.description      = <<-DESC
Simple Swift 4 encoding & decoding.
                       DESC
 
  s.homepage         = 'https://github.com/DimaMishchenko/NativeJSONMapper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dima Mishchenko' => 'narmdv5@gmail.com' }
  s.source           = { :git => 'https://github.com/DimaMishchenko/NativeJSONMapper.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'NativeJSONMapper/NativeJSONMapper/*'
 
end