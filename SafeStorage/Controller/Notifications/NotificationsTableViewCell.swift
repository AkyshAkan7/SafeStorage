//
//  NotificationsTableViewCell.swift
//  SafeStorage
//
//  Created by Akan Akysh on 5/7/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    var notification: Notification? {
        didSet {
            notificationTextLabel.text = notification?.text
        }
    }
    
    let notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAssets.box
        imageView.contentMode = .center
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let textBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    let notificationTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.numberOfLines = 0

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NotificationsTableViewCell {
    func makeUI() {
        contentView.backgroundColor = UIColor.systemGray6
        
        [notificationImageView, textBackgroundView].forEach {
            contentView.addSubview($0)
        }
        
        textBackgroundView.addSubview(notificationTextLabel)
        
        notificationImageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
            $0.width.height.equalTo(40)
        }
        
        textBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalTo(notificationImageView.snp.right).offset(5)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        notificationTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
}

