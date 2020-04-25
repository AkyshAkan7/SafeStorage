//
//  ProfileTableViewCellManager.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/17/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import Foundation

class ProfileMenuManager: NSObject {
    
    static let shared = ProfileMenuManager()
    var models: [ProfileMenu] = [
        ProfileMenu(title: "Способы оплаты"),
        ProfileMenu(title: "Документция"),
        ProfileMenu(title: "Часто задаваемые вопросы"),
        ProfileMenu(title: "Контакты"),
        ProfileMenu(title: "Настройки")
    ]
}
