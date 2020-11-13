install! 'cocoapods',
         :generate_multiple_pod_projects => true,
         :incremental_installation => true,
         :preserve_pod_file_structure => true

use_frameworks!

target 'Template macOS' do
  platform :osx, '10.15'
  pod 'Forge', :path => '../Forge'
  pod 'Satin', :path => '../Satin'
  pod 'Youi', :path => '../Youi'
  pod 'SwiftFormat/CLI'
end


target 'Template iOS' do
  platform :ios, '13.0'
  pod 'Forge', :path => '../Forge'
  pod 'Satin', :path => '../Satin'
  pod 'SwiftFormat/CLI'
end

target 'Template tvOS' do
  platform :tvos, '13.0'
  pod 'Forge', :path => '../Forge'
  pod 'Satin', :path => '../Satin'
  pod 'SwiftFormat/CLI'
end
