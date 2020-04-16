//
//  ProfilePageViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/7/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit
import FirebaseAuth
import SnapKit

class ProfilePageViewController: UIViewController {
    
    private var listener: AuthStateDidChangeListenerHandle!
    private let firebaseAuth = Auth.auth()
    
    let profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor  = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ProfileDefaultIcon")
//        imageView.layer.borderWidth = 2
//        imageView.layer.borderColor = UIColor(named: "DarkBlue")?.withAlphaComponent(0.7).cgColor
        return imageView
    }()
    
    let profileNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Полное имя"
        label.textColor = UIColor(named: "DarkBlue")
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let profilePhoneLabel: UILabel = {
        var label = UILabel()
        label.text = "+707 485 69 86"
        label.textColor = UIColor(named: "DarkBlue")
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textAlignment = .left
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Изменить профиль", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        button.setTitleColor(UIColor(named: "Orange"), for: .normal)
        button.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//            let firebaseAuth = Auth.auth()
//        do {
//          try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//          print ("Error signing out: %@", signOutError)
//        }
          
        setupNavigationBar()
        makeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firebaseDidChangeListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        firebaseAuth.removeStateDidChangeListener(listener)
    }
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = 40 //self.profileImageView.frame.height * 0.5
        profileImageView.layer.masksToBounds  = true
    }
    
    func firebaseDidChangeListener() {
        listener = firebaseAuth.addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            
            guard let user = user else {
                let navigationVC = UINavigationController(rootViewController: LoginViewController())
                navigationVC.modalPresentationStyle = .fullScreen
                self.present(navigationVC, animated: true, completion: nil)
                return
            }
        }
    }
    
    func createContainerView(for views: [UIView]) -> UIView {
        let container: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 12
            return view
        }()
        views.forEach {
            container.addSubview($0)
        }
        return container
    }
    
    @objc func editProfileButtonTapped() {
        
    }

}

// Make UI
extension ProfilePageViewController {
    func setupNavigationBar() {
        navigationItem.title = "Мой профиль"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "DarkBlue") as Any,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 22)!]
    }
    
    func makeUI() {
        view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints {
            if #available(iOS 11, *) {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.top.equalTo(topLayoutGuide.snp.top)
            }
            $0.left.right.bottom.equalToSuperview()
        }
        
        let containerView = createContainerView(for: [profileNameLabel, profilePhoneLabel, profileImageView, editProfileButton])
        backgroundView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(130)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.right.equalTo(-20)
            $0.width.height.equalTo(80)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.left.equalTo(20)
        }
        
        profilePhoneLabel.snp.makeConstraints {
            $0.top.equalTo(profileNameLabel.snp.bottom).offset(5)
            $0.left.equalTo(20)
        }
        
        editProfileButton.snp.makeConstraints {
            $0.top.equalTo(profilePhoneLabel.snp.bottom).offset(10)
            $0.left.equalTo(20)
        }
        
        
    }
}
