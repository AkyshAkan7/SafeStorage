//
//  PhotoCollectionViewCell.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/25/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.systemRed
        let minusImage = UIImage(systemName: "minus")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = .white
        button.setImage(minusImage, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.width.height.equalTo(16)
        }
    }
}
