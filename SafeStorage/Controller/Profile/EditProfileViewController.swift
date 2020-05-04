//
//  EditProfileViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/19/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD
import FirebaseAuth
import FirebaseFirestore

class EditProfileViewController: UIViewController {
    
    private let documentReference = Firestore.firestore().collection("users")
    
    var phoneTextField: FloatLabelTextField = {
        var textField = FloatLabelTextField()
        textField.placeholder = "Номер телефона"
        textField.isUserInteractionEnabled = false
        textField.textColor = UIColor.systemGray
        return textField
    }()
    
    var fullNameTextField: FloatLabelTextField = {
        var textField = FloatLabelTextField()
        textField.placeholder = "ФИО"
        return textField
    }()
    
    var emailTextField: FloatLabelTextField = {
        var textField = FloatLabelTextField()
        textField.placeholder = "Почта"
        return textField
    }()
    
    var saveButton: LoadingButton = {
        let button = LoadingButton()
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "DarkBlue")
        button.layer.cornerRadius = 12
        return button
    }()
    
    var infoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Номер телефона изменить нельзя. Он привязан к аккаунту"
        label.textColor = UIColor.systemGray
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Мои данные"
        makeUI()
        loadData()
    }
    
    func loadData() {
        phoneTextField.text = CurrentUser.shared.user.phone
        fullNameTextField.text = CurrentUser.shared.getFullName()
        emailTextField.text = CurrentUser.shared.user.email
    }
    
    @objc func saveButtonTapped() {
        [fullNameTextField, emailTextField].forEach {
            $0.resignFirstResponder()
        }
        
        saveButton.setTitle("Сохранение", for: .normal)
        saveButton.showLoading()
        guard let uid = Auth.auth().currentUser?.uid else {
            saveButton.hideLoading()
            showErrorAlert()
            return
        }
        
        if let fullname = fullNameTextField.text, !fullname.isEmpty {
            let fullNameArr = fullname.components(separatedBy: " ")
            let firstName = fullNameArr[0]
            let surName = fullNameArr.count > 1 ? fullNameArr[1] : nil
            let middleName = fullNameArr.count > 2 ? fullNameArr[2] : nil
            
            let email = emailTextField.text
            
            documentReference.document("\(uid)").updateData([
                "firstName": firstName,
                "surName": surName,
                "middleName": middleName,
                "email": !email!.isEmpty ? email : nil
            ]) { [weak self] (error) in
                guard let self = self else { return }
                self.saveButton.hideLoading()
                
                if let error = error {
                    print(error.localizedDescription)
                    self.showErrorAlert()
                    return
                }
                
                self.showSuccessAlert()
                
            }
        }
    }
    
    func showSuccessAlert() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .customView
        hud.backgroundView.color = .lightGray
        hud.backgroundView.alpha = 0.2
        hud.label.text = "Данные сохранены"
        hud.customView = UIImageView(image: ImageAssets.success)
        hud.hide(animated: true, afterDelay: 1.2)
    }
    
    func showErrorAlert() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .customView
        hud.backgroundView.color = .lightGray
        hud.backgroundView.alpha = 0.2
        hud.label.text = "Ошибка"
        hud.customView = UIImageView(image: ImageAssets.error)
        hud.hide(animated: true, afterDelay: 1.2)
    }
}

// Make UI
extension EditProfileViewController {
    func makeUI() {
        view.addSubview(fullNameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(emailTextField)
        view.addSubview(saveButton)
        view.addSubview(infoImageView)
        view.addSubview(infoLabel)
        
        phoneTextField.snp.makeConstraints {
            if #available(iOS 11, *) {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            } else {
                $0.top.top.equalTo(topLayoutGuide.snp.top).offset(40)
            }
            
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(50)
        }
        
        infoImageView.snp.makeConstraints() {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(10)
            $0.left.equalTo(20)
            $0.height.width.equalTo(14)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(10)
            $0.left.equalTo(infoImageView.snp.right).offset(3)
            $0.right.equalTo(-50)
        }
        
        fullNameTextField.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(60)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(fullNameTextField.snp.bottom).offset(40)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(160)
        }
    }
}
