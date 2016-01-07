Pod::Spec.new do |s|
  s.name             = "NYNavigator"
  s.version          = "0.1.0"
  s.summary          = "A tool for opening UIViewControllers by url scheme."
  s.description      = <<-DESC
                       It is a tool for opening UIViewControllers by url scheme, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/lylwx/NYNavigator"

  s.license          = 'MIT'
  s.author           = { "William Liu" => "sudalyl@gmail.com" }
  s.source           = { :git => "https://github.com/lylwx/NYNavigator.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'NYNavigator/*'
  # s.resources = 'Assets'

  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit', 'Toast'

end
