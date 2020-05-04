//
//  CategoryManager.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/27/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import Foundation

class CategoryManager: NSObject {
    static let shared = CategoryManager()
    
    let models: [Category] = [
        Category(title: "Одежда"), Category(title: "Шины"), Category(title: "Мебель"), Category(title: "Велосипед"), Category(title: "Личные вещи"), Category(title: "Другое")
    ]
}
