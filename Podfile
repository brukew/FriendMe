# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'FriendMe' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FriendMe
  pod 'Parse'
  pod 'Parse/UI'
  pod 'GMImagePicker', '~> 0.0'
  pod 'AFNetworking', '~> 3.0.0'
  pod 'BDBOAuth1Manager', '~> 2.0'
  pod 'FontAwesomeKit', '~> 2.2.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end