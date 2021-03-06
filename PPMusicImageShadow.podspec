Pod::Spec.new do |s|
s.name             = 'PPMusicImageShadow'
s.version          = '1.1'
s.summary          = 'iOS 10 Music Appshadow blur imitation'

s.description      = <<-DESC
This UIView subclass will imitate iOS 10 Music App Poster Blur Shadow. Please see the example.
DESC

s.homepage         = 'https://github.com/PierrePerrin/PPMusicImageShadow'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Pierre' => 'Perrin' }
s.source           = { :git => 'https://github.com/PierrePerrin/PPMusicImageShadow.git', :tag => s.version.to_s }
s.ios.deployment_target = '9.0'
s.source_files = 'PPMusicImageShadow/PPMusicImageShadow/*.swift'

end
