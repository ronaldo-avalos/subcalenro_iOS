# Uncomment the next line to define a global platform for your project
platform :ios, '15.6'

target 'subcalenro' do
  use_frameworks!

  # Pods para subcalenro
  pod 'FSCalendar', '~> 2.8'
  pod 'DGCharts', '~> 5.0'
  pod 'ToastViewSwift', '~> 2.1'
  pod 'Eureka', '~> 5.0'
  pod 'Kingfisher'
  pod 'Shimmer'
  pod 'RevenueCat'
  pod 'RevenueCatUI'

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
            end
        end
    end
end
