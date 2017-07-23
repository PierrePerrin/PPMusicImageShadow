Pod::Spec.new do |s|
s.name             = 'PPMusicImageShadow'
s.version          = '0.9.2.2'
s.summary          = 'iOS 10 Music Appshadow blur imitation'

s.description      = <<-DESC
This UIView subclass will imitate iOS 10 Music App Poster Blur Shadow. Please see the example.
DESC

s.homepage         = 'https://github.com/PierrePerrin/PPMusicImageShadow'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { '<YOUR NAME HERE>' => '<YOUR EMAIL HERE>' }
s.source           = { :git => 'https://github.com/PierrePerrin/PPMusicImageShadow.git', :tag => s.version.to_s }
s.ios.resources = [PPMusicImageShadow/PPMusicImageShadow/*.png]
s.ios.deployment_target = '9.0'
s.source_files = 'PPMusicImageShadow/PPMusicImageShadow/*.{swift}'

end
