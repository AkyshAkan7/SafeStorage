//
//  StorageViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/18/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class StorageViewController: UIViewController {
    
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
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        makeUI()
    }
    
    @objc func orderButtonTapped() {
        navigationController?.pushViewController(MakeOrderViewController(), animated: true)
    }
    
}

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
        [emptyBoxImageView, emptyStorageLabel, orderButton].forEach {
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
