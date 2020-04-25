//
//  ProfileTableViewCell.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/17/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    
    var profileMenu: ProfileMenu? {
        didSet {
            titleLabel.text = profileMenu?.title
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "DarkBlue")
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

// make UI
extension ProfileTableViewCell {
    func makeUI() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
    }
}
