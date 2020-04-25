//
//  NotificationsViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/18/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    let emptyNotificationLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас пока нет уведомлений"
        label.textColor = UIColor(named: "DarkBlue")
        return label
    }()
    
    let mailboxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAssets.mailbox
        return imageView
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupUI()
    }

}

extension NotificationsViewController {
    func setupNavigationBar() {
        navigationItem.title = "Уведомления"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "DarkBlue") as Any,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 22)!]
    }
    
    func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(emptyNotificationLabel)
        backgroundView.addSubview(mailboxImageView)
        
        backgroundView.snp.makeConstraints {
            if #available(iOS 11, *) {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.top.top.equalTo(topLayoutGuide.snp.top)
                $0.bottom.equalTo(bottomLayoutGuide.snp.bottom)
            }
            $0.left.right.equalToSuperview()
        }
        
        mailboxImageView.snp.makeConstraints {
            $0.height.width.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        emptyNotificationLabel.snp.makeConstraints {
            $0.top.equalTo(mailboxImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
