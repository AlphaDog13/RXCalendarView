Pod::Spec.new do |s|

  s.name         = "RXCalendarView"
  s.version      = "0.0.1"
  s.summary      = "An Calendar"

  s.homepage     = "https://github.com/AlphaDog13/RXCalendarView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "AlphaDog13"

  s.source       = { :git => "https://github.com/AlphaDog13/RXCalendarView.git", :tag => s.version.to_s }
  s.source_files = "RXCalendarView/*.swift"

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.frameworks   = "Foundation", "UIKit"

end
