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
        let firstViewController = UINavigationController(rootViewController: ProfilePageViewController())
        firstViewController.title = "Профиль"
        
        viewControllers = [firstViewController]
    }


}

