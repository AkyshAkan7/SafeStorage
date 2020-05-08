//
//  Product.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/29/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import Foundation

struct Product {
    var id: String
    var name: String
    var address: String
    var category: String
    var comment: String?
    var time: String
    var retentionPeriod: String
    var status: String
}

enum Status: String {
    case processing = "В процессе"
    case done = "На хранении"
}
