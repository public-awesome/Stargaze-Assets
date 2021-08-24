install! 'cocoapods',
         :generate_multiple_pod_projects => true,
         :incremental_installation => true,
         :preserve_pod_file_structure => true

install! 'cocoapods', :disable_input_output_paths => true

use_frameworks!

target 'Stargaze macOS' do
  platform :osx, '10.15'
  pod 'Forge', :path => '../Forge'
  pod 'Satin', :path => '../Satin'
  pod 'Youi', :path => '../Youi'
end

target 'Stargaze iOS' do
  platform :ios, '14.0'
  pod 'Forge', :path => '../Forge'
  pod 'Satin', :path => '../Satin'
  pod 'Youi', :path => '../Youi'
end

target 'Stargaze tvOS' do
  platform :tvos, '13.0'
  pod 'Forge', :path => '../Forge'
  pod 'Satin', :path => '../Satin'
end
