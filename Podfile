source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '15.0'
use_modular_headers!  

project 'MobileIdWalletDemoApp.xcodeproj'
workspace 'Workspace.xcworkspace'

target 'MobileIdWalletDemoApp' do
  use_frameworks!
  project 'MobileIdWalletDemoApp.xcodeproj'
  pod "WalletLibrary"
  pod "lottie-ios"
  pod 'mobileid-wallet-sdk', '1.0.0-beta.1' 
  pod 'mobileid-wallet-ui-sdk', '1.0.0-beta.1' 
end

# Known issue with Cocoapods https://github.com/CocoaPods/CocoaPods/issues/9232
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
  end
end
