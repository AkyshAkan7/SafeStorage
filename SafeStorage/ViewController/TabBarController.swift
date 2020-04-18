//
//  ViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/6/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTabBar()
    }
    
    func setupTabBar() {
        let firstViewController = StorageViewController()
        firstViewController.title = "Хранилище"
        firstViewController.tabBarItem.image = UIImage(named: "Box")
        firstViewController.tabBarItem.selectedImage = UIImage(named: "Box")?.withRenderingMode(.alwaysOriginal)
        
        let secondViewController = ServicesViewController()
        secondViewController.title = "Услуги"
        secondViewController.tabBarItem.image = UIImage(named: "Menu")
        secondViewController.tabBarItem.selectedImage = UIImage(named: "Menu")?.withRenderingMode(.alwaysOriginal)
        
        let thirdViewController = NotificationsViewController()
        thirdViewController.title = "Уведомления"
        thirdViewController.tabBarItem.image = UIImage(named: "Notification")
        thirdViewController.tabBarItem.selectedImage = UIImage(named: "Notification")?.withRenderingMode(.alwaysOriginal)
        
        let fourthViewController = UINavigationController(rootViewController: ProfilePageViewController())
        fourthViewController.title = "Профиль"
        fourthViewController.tabBarItem.image = UIImage(named: "Person")
        fourthViewController.tabBarItem.selectedImage = UIImage(named: "Person")?.withRenderingMode(.alwaysOriginal)
        
        let appearance = UITabBarItem.appearance(whenContainedInInstancesOf: [TabBarController.self])
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "DarkBlue")!], for: .selected)
        
        viewControllers = [firstViewController, secondViewController, thirdViewController, fourthViewController]
    }


}

