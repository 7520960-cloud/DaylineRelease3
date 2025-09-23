platform :ios, '13.0'
use_frameworks!
use_modular_headers!

target 'DaylineApp' do
  # Firebase Authentication
  pod 'Firebase/Auth'

  # Если в будущем понадобится Firestore или Analytics, можно раскомментировать:
  # pod 'Firebase/Firestore'
  # pod 'Firebase/Analytics'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Отключаем предупреждения, которые мешают сборке
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
