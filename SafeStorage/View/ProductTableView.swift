//
//  ProductTableView.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/29/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class ProductTableView: UITableView {
    
    enum Constants {
        static let cellId = "productCell"
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(ProductTableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProductTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ProductManager.shared.sortedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! ProductTableViewCell
        let currentProduct = ProductManager.shared.sortedProducts[indexPath.row]
        cell.product = currentProduct
        return cell
    }
    
    
}
