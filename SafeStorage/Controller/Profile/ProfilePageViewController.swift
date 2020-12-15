//
//  ProfilePageViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/7/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SnapKit

class ProfilePageViewController: UIViewController {
    
    enum Constants {
        static let cellId = "profileCell"
    }
    
    private let firebaseAuth = Auth.auth()
    private let documentReference = Firestore.firestore().collection("users")
    private var listener: AuthStateDidChangeListenerHandle!
    
    let profileImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor  = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = ImageAssets.profile
        return imageView
    }()
    
    let profileNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Имя"
        label.textColor = UIColor(named: "DarkBlue")
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 22)
        label.textAlignment = .left
        return label
    }()
    
    let profilePhoneLabel: UILabel = {
        var label = UILabel()
        label.text = "Номер"
        label.textColor = UIColor(named: "DarkBlue")
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
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
    
    lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let quitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(UIColor(named: "DarkBlue"), for: .normal)
        button.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firebaseDidChangeListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        firebaseAuth.removeStateDidChangeListener(listener)
    }
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height * 0.5
        profileImageView.layer.masksToBounds  = true
    }
    
    func createContainerView(for views: [UIView]) -> UIView {
        let container: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            //            view.layer.cornerRadius = 15
            
            view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            view.layer.shadowOpacity = 0.5
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = 10
            
            return view
        }()
        views.forEach {
            container.addSubview($0)
        }
        return container
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
            self.documentReference.document("\(user.uid)").getDocument { [weak self] (document, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                    return
                }
                
                if let document = document, document.exists {
                    let firstName = document["firstName"] as? String
                    let middleName = document["middleName"] as? String
                    let surName = document["surName"] as? String
                    let phone = document["phone"] as? String
                    let avatarUrl = document["avatarUrl"] as? String
                    let email = document["email"] as? String
                    let user = User(firstName: firstName, middleName: middleName, surName: surName, phone: phone, avatarUrl: avatarUrl, email: email, uid: user.uid)
                    CurrentUser.shared.user = user
                }
                
                if let fullName = CurrentUser.shared.getFullName() {
                    self.profileNameLabel.text = fullName
                } else {
                    self.profileNameLabel.text = "Имя не указано"
                }
                self.profilePhoneLabel.text = CurrentUser.shared.user.phone
            }
        }
    }
    
    @objc func editProfileButtonTapped() {
        navigationController?.pushViewController(EditProfileViewController(), animated: true)
    }
    
    @objc func quitButtonTapped() {
        do {
            try firebaseAuth.signOut()
            CurrentUser.shared.user = User()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

// Table view delegate
extension ProfilePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileMenuManager.shared.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! ProfileTableViewCell
        let currentItem = ProfileMenuManager.shared.models[indexPath.row]
        cell.profileMenu = currentItem
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
        backgroundView.addSubview(quitButton)
        
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
        
        let containerForProfileView = createContainerView(for: [profileNameLabel, profilePhoneLabel, profileImageView, editProfileButton])
        backgroundView.addSubview(containerForProfileView)
        
        let containerForTableView = createContainerView(for: [profileTableView])
        backgroundView.addSubview(containerForTableView)
        
        containerForProfileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(135)
        }
        
        containerForTableView.snp.makeConstraints {
            $0.top.equalTo(containerForProfileView.snp.bottom).offset(15)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(350)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(25)
            $0.right.equalTo(-20)
            $0.width.height.equalTo(80)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.top.equalTo(25)
            $0.left.equalTo(20)
        }
        
        profilePhoneLabel.snp.makeConstraints {
            $0.top.equalTo(profileNameLabel.snp.bottom).offset(5)
            $0.left.equalTo(20)
        }
        
        editProfileButton.snp.makeConstraints {
            $0.top.equalTo(profilePhoneLabel.snp.bottom).offset(12)
            $0.left.equalTo(20)
        }
        
        profileTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        quitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(containerForTableView.snp.bottom).offset(20)
        }
    }
}
