//
//  StorageViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/18/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class StorageViewController: UIViewController {
    
    let status = ["Все", "В обработке", "На хранении"]
    
    var isProductsEmpty: Bool = false {
        didSet {
            [tableView, segmentedControl].forEach {
                $0.isHidden = isProductsEmpty
            }
            [emptyBoxImageView, emptyStorageLabel, orderButton].forEach {
                $0.isHidden = !isProductsEmpty
            }
        }
    }
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: status)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        control.isHidden = true
        return control
    }()
    
    let tableView: ProductTableView = {
        let tableView = ProductTableView()
        tableView.backgroundColor = UIColor.systemGray6.withAlphaComponent(1)
        tableView.separatorStyle = .none
        tableView.isHidden = true
        return tableView
    }()
    
    let emptyBoxImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageAssets.emptyBox
        return imageView
    }()
    
    let emptyStorageLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас нету вещей на хранении"
        label.textColor = UIColor(named: "DarkBlue")
        return label
    }()
    
    let orderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сдать вещь", for: .normal)
        button.backgroundColor = UIColor(named: "DarkBlue")
        button.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        makeUI()
        getDocuments()
    }
    
    func getDocuments() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document("\(uid)").collection("products").addSnapshotListener({ [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = querySnapshot else {
                self.isProductsEmpty = true
                return
            }
            
            var products = [Product]()
            
            for document in snapshot.documents {
                let data = document.data()
                let address = data["address"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                let comment = data["comment"] as? String ?? ""
                let time = data["time"] as? String ?? ""
                let retentionPeriod = data["retentionPeriod"] as? String ?? ""
                let status = data["status"] as? String ?? ""
                
                let product = Product(id: document.documentID, address: address, category: category,
                                      comment: comment, time: time, retentionPeriod: retentionPeriod, status: status)
                products.append(product)
            }
            
            ProductManager.shared.products = products
            ProductManager.shared.sortedProducts = products
            self.tableView.reloadData()
            self.isProductsEmpty = false
        })
            
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let products = ProductManager.shared.products
        switch sender.selectedSegmentIndex {
        // Все
        case 0:
            ProductManager.shared.sortedProducts = products
        // в обработке
        case 1:
            let processingProducts = products.filter { $0.status == Status.processing.rawValue }
            ProductManager.shared.sortedProducts = processingProducts
        //  на хранении
        case 2:
            let doneProducts = products.filter { $0.status == Status.done.rawValue }
            ProductManager.shared.sortedProducts = doneProducts
        default:
            break
        }
        tableView.reloadData()
    }
    
    @objc func orderButtonTapped() {
        navigationController?.pushViewController(MakeOrderViewController(), animated: true)
    }
    
}

// Make UI
extension StorageViewController {
    func setupNavigationBar() {
        navigationItem.title = "Хранилище"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "DarkBlue") as Any,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 22)!]
    }
    
    func makeUI() {
        view.addSubview(backgroundView)
        [segmentedControl, tableView, emptyBoxImageView, emptyStorageLabel, orderButton].forEach {
            backgroundView.addSubview($0)
        }
        
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
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(35)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        
        emptyBoxImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.height.equalTo(100)
        }
        
        emptyStorageLabel.snp.makeConstraints {
            $0.top.equalTo(emptyBoxImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        orderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        }
    }
}
