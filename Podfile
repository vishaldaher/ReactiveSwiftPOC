# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!

def shared_pods
    pod 'ReactiveSwift'
    pod 'ReactiveCocoa'
end

target 'ReactiveSwiftPOC' do
    shared_pods
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|        
       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0' // you can change this version as per your requirments.
    end
  end
end 
end

target 'ReactiveSwiftPOCTests' do
    shared_pods
end

target 'ReactiveSwiftPOCUITests' do
    shared_pods
end

