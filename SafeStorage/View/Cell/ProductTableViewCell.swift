//
//  ProductTableViewCell.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/29/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    var product: Product? {
        didSet {
            nameLabel.text = product?.name ?? ""
            categoryLabel.attributedText = attributedText(firstString: "Категория: ", secondString: (product?.category ?? ""))
            retentionPeriodLabel.attributedText = attributedText(firstString: "Срок: ", secondString: "осталось " + (product?.retentionPeriod ?? ""))
            setStatus(status: product?.status ?? "")
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 19)
        label.textColor = UIColor(named: "DarkBlue")
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let retentionPeriodLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
        label.text = "Статус:  "
        return label
    }()
    
    let statusIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.frame.size.height = 12
        view.layer.cornerRadius = view.frame.size.height * 0.5
        return view
    }()
    
    let cellBackgorundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        view.layer.cornerRadius = 12
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7)
        selectionStyle = .none
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func attributedText(firstString: String, secondString: String) -> NSAttributedString {
        let firstAttribute = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 13)]
        let secondAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "HelveticaNeue", size: 13)!,
            .foregroundColor: UIColor(named: "DarkBlue")!]
        
        let firstAttributedString = NSMutableAttributedString(string: firstString, attributes: firstAttribute as [NSAttributedString.Key : Any])
        let secondAttributedString = NSAttributedString(string: secondString, attributes: secondAttribute)
        firstAttributedString.append(secondAttributedString)
        
        return firstAttributedString
    }
    
    // set color of statusIndicator
    func setStatus(status: String) {
        switch status {
        case Status.processing.rawValue:
            statusIndicator.backgroundColor = UIColor.systemYellow
        case Status.done.rawValue:
            statusIndicator.backgroundColor = UIColor.systemGreen
        default:
            break
        }
    }
    
}

extension ProductTableViewCell {
    func makeUI() {
        contentView.addSubview(cellBackgorundView)
        
        [nameLabel, categoryLabel, retentionPeriodLabel, statusIndicator, statusLabel].forEach {
            cellBackgorundView.addSubview($0)
        }
        
        cellBackgorundView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(15)
            $0.bottom.right.equalToSuperview().offset(-15)
            $0.height.equalTo(110)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(15)
        }
        
        retentionPeriodLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(25)
            $0.left.equalToSuperview().offset(15)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(retentionPeriodLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(15)
        }
        
        statusIndicator.snp.makeConstraints {
            $0.width.height.equalTo(12)
            $0.centerY.equalTo(categoryLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-20)
        }
        
        statusLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryLabel.snp.centerY)
            $0.right.equalTo(statusIndicator.snp.left)
        }
    }
}
