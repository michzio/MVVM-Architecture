# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MVVM' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MVVM
  pod 'Alamofire', '~> 5.0.0-rc.2'
  pod 'SwiftyJSON', '~> 4.0'
  pod "PromiseKit", "~> 6.8"
  
  # ReactiveX
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  
  pod 'RxCoreData'

  # Realm
  pod 'RealmSwift'
  pod 'RxRealm'

  target 'MVVMTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
  end

  target 'MVVMUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
