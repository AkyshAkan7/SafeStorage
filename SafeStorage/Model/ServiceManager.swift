//
//  ServiceManager.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/23/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import Foundation

class ServiceManager: NSObject {
    static let shared = ServiceManager()
    
    let models: [Service] = [
        Service(title: "Сдать вещь", description: "Сдать вещи в safestorage", image: ImageAssets.coloredBox!),
        Service(title: "Вернуть вещь", description: "Вернуть вещи с safestorage", image: ImageAssets.coloredEmptyBox!),
        Service(title: "Переезд", description: "Заказать переезд", image: ImageAssets.truck!)
    ]
}
