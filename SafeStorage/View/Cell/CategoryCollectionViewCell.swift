//
//  CategoryCollectionViewCell.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/27/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var category: Category? {
        didSet {
            titleLabel.text = category?.title
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CategoryCollectionViewCell {
    func makeUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-25)
            $0.right.equalToSuperview().offset(-20)
        }
    }
}
