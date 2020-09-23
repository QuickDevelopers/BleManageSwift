

Pod::Spec.new do |spec|

  spec.name         = "BleManageSwift"
  spec.version      = "1.0.3"
  spec.summary      = "Bluetooth help quick BleManageSwift"

 
  spec.description  = <<-DESC
  This is quickly Bluetooth help , it is help quick more device connect. so you use very smart!
                   DESC

  spec.homepage     = "https://github.com/QuickDevelopers/BleManageSwift"

  spec.license      = { :type => "MIT", :file => "LICENSE" }


  spec.author       = { "ArdWang" => "278161009@qq.com" }

  spec.platform     = :ios, "10.0"

  spec.ios.deployment_target = "10.0"


  spec.source    = { :git => "https://github.com/QuickDevelopers/BleManageSwift.git", :tag => "#{spec.version}" }

  spec.swift_version = '5.0'



  spec.source_files  = "BleManageSwift", "BleManageSwift/BleManage/*.{swift}"

  spec.frameworks = "Foundation","UIKit","CoreBluetooth"

 

end
