//
//  NotificationsViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/18/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    enum Constants {
        static let cellId = "NotificationCell"
    }
    
    var isNotificationsEmpty: Bool = true {
        didSet {
            [tableView].forEach {
                $0.isHidden = isNotificationsEmpty
            }
            [emptyNotificationLabel, mailboxImageView].forEach {
                $0.isHidden = !isNotificationsEmpty
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.systemGray6
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        return tableView
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNotificationBadge()
        
        UserDefault.loadNotifications()
        if !NotificationManager.shared.notifications.isEmpty {
            isNotificationsEmpty = false
            tableView.reloadData()
        } else {
            isNotificationsEmpty = true
        }
    }
    
    func setNotificationBadge() {
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = nil
            NotificationManager.shared.markAsRead()
        }
    }

}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationManager.shared.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! NotificationsTableViewCell
        let currentCell = NotificationManager.shared.notifications[indexPath.row]
        cell.notification = currentCell
        
        return cell
    }
    
    
}

// Make UI
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
        backgroundView.addSubview(tableView)
        
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
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
