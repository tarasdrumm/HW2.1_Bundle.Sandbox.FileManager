//
//  AppDelegate.swift
//  Bundle.Sandbox.FileManager
//
//  Created by Тарас Андреев on 13.06.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAppApperance()
        
        return true
    }

    private func configureAppApperance() {
        UINavigationBar.appearance().tintColor = .darkGray
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = UINavigationController(rootViewController: DocumentsViewController())
        window?.makeKeyAndVisible()
    }
}

