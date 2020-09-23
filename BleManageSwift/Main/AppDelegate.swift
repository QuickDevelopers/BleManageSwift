//
//  AppDelegate.swift
//  BleManageSwift
//
//  Created by RND on 2020/9/23.
//  Copyright © 2020 RND. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //返回按钮的颜色为白色
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .white
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let home = HomeViewController()
        //let home = BleViewController()
        let navCtrl = UINavigationController(rootViewController: home)
        window?.rootViewController = navCtrl
        
        window?.makeKeyAndVisible()
        removeLaunchScreenCacheIfNeeded()
        Thread.sleep(forTimeInterval: 3.0)
        
        return true
    }
    
    func removeLaunchScreenCacheIfNeeded() {
        let filePath = "\(NSHomeDirectory())/Library/SplashBoard"

        if FileManager.default.fileExists(atPath: filePath) {
            let error: Error? = nil
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
            }

            if error != nil {
                print("清除LaunchScreen缓存失败")
            } else {
                print("清除LaunchScreen缓存成功")
            }
        }
    }
    

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

