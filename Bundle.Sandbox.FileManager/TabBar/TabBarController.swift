//
//  TabBarController.swift
//  Bundle.Sandbox.FileManager
//
//  Created by Тарас Андреев on 19.06.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppApperance()
    }
    
    private func configureAppApperance() {
        
        let documentsVC = DocumentsViewController()
        let settingsVC = SettingsViewController()
        
        let documentsNavigationVC = UINavigationController(rootViewController: documentsVC)
        documentsNavigationVC.tabBarItem.title = "Documents"
        documentsNavigationVC.tabBarItem.image = UIImage(systemName: "doc")
        
        let settingsNavigationVC = UINavigationController(rootViewController: settingsVC)
        settingsVC.tabBarItem.title = "Settings"
        settingsVC.tabBarItem.image = UIImage(systemName: "gearshape")
        
        viewControllers = [documentsNavigationVC, settingsNavigationVC]
    }
}
