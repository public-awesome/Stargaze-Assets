install! 'cocoapods',
         :generate_multiple_pod_projects => true,
         :incremental_installation => true,
         :preserve_pod_file_structure => true

use_frameworks!

target 'Template macOS' do
  platform :osx, '10.14'
  pod 'Forge', :git => 'git@github.com:Hi-Rez/Forge.git'
  pod 'Satin', :git => 'git@github.com:Hi-Rez/Satin.git'
  pod 'Youi', :git => 'git@github.com:Hi-Rez/Youi.git'
end


target 'Template iOS' do
  platform :ios, '12.4'
  pod 'Forge', :git => 'git@github.com:Hi-Rez/Forge.git'
  pod 'Satin', :git => 'git@github.com:Hi-Rez/Satin.git'
  pod 'Youi', :git => 'git@github.com:Hi-Rez/Youi.git'
end


target 'Template tvOS' do
  platform :tvos, '12.4'
  pod 'Forge', :git => 'git@github.com:Hi-Rez/Forge.git'
  pod 'Satin', :git => 'git@github.com:Hi-Rez/Satin.git'
end
