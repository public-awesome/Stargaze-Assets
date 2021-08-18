install! 'cocoapods',
         :generate_multiple_pod_projects => true,
         :incremental_installation => true,
         :preserve_pod_file_structure => true

install! 'cocoapods', :disable_input_output_paths => true

use_frameworks!

target 'Template macOS' do
  platform :osx, '10.15'
  pod 'Forge', :path => '../Forge'
  pod 'Satin', :path => '../Satin'
  pod 'Youi', :path => '../Youi'
end


target 'Template iOS' do
  platform :ios, '14.0'
  pod 'Forge', :path => '../Forge'
  pod 'Satin', :path => '../Satin'
  pod 'Youi', :path => '../Youi'
end

target 'Template tvOS' do
  platform :tvos, '13.0'
  pod 'Forge', :path => '../Forge'
  pod 'Satin', :path => '../Satin'
end
