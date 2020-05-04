//
//  ProductManager.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/29/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import Foundation

class ProductManager {
    static let shared = ProductManager()
    
    var products: [Product] = []
    var sortedProducts: [Product] = []
}
