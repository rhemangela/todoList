platform :ios, '12.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end

target 'todoList' do
use_frameworks!
  # Pods for todoList
pod 'RealmSwift'
pod 'IQKeyboardManagerSwift'
pod 'IGColorPicker'

end
