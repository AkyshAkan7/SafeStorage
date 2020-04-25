//
//  ServicesViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/18/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController {
    
    enum Constants {
        static let serviceCell = "serviceCell"
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ServiceTableViewCell.self, forCellReuseIdentifier: Constants.serviceCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7)
        return tableView
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        makeUI()
    }
    
    @objc func confirmButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let vc = MakeOrderViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            print("1")
        case 2:
            print(2)
        default:
            print("Error while pushing view controller")
        }
    }
    
}

// Make UI
extension ServicesViewController {
    func setupNavigationBar() {
        navigationItem.title = "Услуги"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "DarkBlue") as Any,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 22)!]
    }
    
    func makeUI() {
        view.addSubview(backgroundView)
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
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
}

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServiceManager.shared.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.serviceCell, for: indexPath) as! ServiceTableViewCell
        let currentItem = ServiceManager.shared.models[indexPath.row]
        cell.service = currentItem
        cell.confirmButton.tag = indexPath.row
        cell.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return cell
    }
    
    
}
