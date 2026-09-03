Pod::Spec.new do |s|
  s.name             = 'LingSDK'
  s.version          = '1.0.0'
  s.summary          = 'LingSDK aggregation splash SDK (local xcframework)'
  s.homepage         = 'https://example.local/MentaVL48AggSDK'
  s.license          = { :type => 'Proprietary' }
  s.author           = { 'Menta' => 'dev@local' }
  s.platform         = :ios, '13.0'
  s.source           = { :path => '.' }
  s.vendored_frameworks = 'LingSDK.xcframework'
  #s.dependency 'MentaVL48SDK'
  s.requires_arc     = true
  s.static_framework = true
  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
end
