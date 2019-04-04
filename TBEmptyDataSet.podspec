Pod::Spec.new do |s|

  s.name         = "TBEmptyDataSet"
  s.version      = "3.0"
  s.summary      = "An extension of UITableView/UICollectionView's super class, it will display a placeholder when the data is empty."

  s.homepage     = "https://github.com/teambition/TBEmptyDataSet"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = "Xin Hong"

  s.source       = { :git => "https://github.com/teambition/TBEmptyDataSet.git", :tag => s.version.to_s }
  s.source_files = "TBEmptyDataSet/*.swift"

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.frameworks   = "Foundation", "UIKit"

end
