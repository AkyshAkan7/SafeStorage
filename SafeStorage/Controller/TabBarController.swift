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
        
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "DarkBlue")!], for: .selected)
        
        let firstViewController = createViewController(viewController: StorageViewController(), tabBarTitle: "Хранилище", image: ImageAssets.box!)
        let secondViewController = createViewController(viewController: ServicesViewController(), tabBarTitle: "Услуги", image: ImageAssets.menu!)
        let thirdViewController = createViewController(viewController: NotificationsViewController(), tabBarTitle: "Уведомления", image: ImageAssets.notification!)
        let fourthViewController = createViewController(viewController: ProfilePageViewController(), tabBarTitle: "Профиль", image: ImageAssets.person!)
        
        
        viewControllers = [firstViewController, secondViewController, thirdViewController, fourthViewController]
        selectedIndex = 3
    }
    
    func createViewController(viewController: UIViewController, tabBarTitle: String, image: UIImage) -> UIViewController {
        let viewController = UINavigationController(rootViewController: viewController)
        viewController.title = tabBarTitle
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = image.withRenderingMode(.alwaysOriginal)
        return viewController
    }


}

