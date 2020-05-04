//
//  CategoryListView.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/27/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class CategoryListLauncher: NSObject {
    
    enum Constants {
        static let cellId = "categoryCell"
        static let cellHeight: CGFloat = 70
    }
    
    var categoryDelegate: CategoryDelegate?
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        cv.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellId)
        return cv
    }()
    
    func show() {
        if let window = UIWindow.key {
            window.addSubview(backgroundView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(CategoryManager.shared.models.count) * Constants.cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            backgroundView.frame = window.frame
            backgroundView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.backgroundView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }, completion: nil)
            
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopupView)))
        }
    }
    
    @objc func dismissPopupView() {
        UIView.animate(withDuration: 0.5) {
            self.backgroundView.alpha = 0
            
            if let window = UIWindow.key {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    
    override init() {
        super.init()
    }
}

// Collection view delegate
extension CategoryListLauncher: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryManager.shared.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath) as! CategoryCollectionViewCell
        let currentCategory = CategoryManager.shared.models[indexPath.row]
        cell.category = currentCategory
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 0
            
            if let window = UIWindow.key {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { (completed: Bool) in
            self.categoryDelegate?.setCategory(at: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            cell.contentView.backgroundColor = .lightGray
            cell.titleLabel.textColor = .white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
            cell.contentView.backgroundColor = nil
            cell.titleLabel.textColor = .black
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
