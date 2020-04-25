//
//  ServiceTableViewCell.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/23/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {

    var service: Service? {
        didSet {
            titleLabel.text = service?.title
            descriptionLabel.text = service?.description
            serviceImageView.image = service?.image
        }
    }
    
    let cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 19)
        label.textColor = UIColor(named: "DarkBlue")
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = UIColor(named: "DarkBlue")?.withAlphaComponent(0.9)
        label.numberOfLines = 0
        return label
    }()
    
    let serviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оформить", for: .normal)
        button.backgroundColor = UIColor(named: "DarkBlue")
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.systemGray6.withAlphaComponent(0.3)
        selectionStyle = .none
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// Make UI
extension ServiceTableViewCell {
    func makeUI() {
        addSubview(cellBackgroundView)
        [titleLabel, descriptionLabel, serviceImageView, confirmButton].forEach {
            cellBackgroundView.addSubview($0)
        }
        
        cellBackgroundView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(160)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(200)
        }
        
        serviceImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(90)
        }
        
        confirmButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(35)
            $0.width.equalTo(110)
        }
    }
}
