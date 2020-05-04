//
//  VerificationCodeViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/12/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class VerificationCodeViewController: UIViewController {
    
    enum Constants {
        static let viewTitle = "Вход"
        static let labelTitle = "Введите подтверждающий код которой был отправлен на номер "
    }
    
    let db = Firestore.firestore()
    var verificationID: String
    var phoneNumber: String
    
    lazy var verificationLabel: UILabel = {
        var label = UILabel()
        label.text = Constants.labelTitle + phoneNumber
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var verificationTextField: VerificationCodeTextField = {
        var textField = VerificationCodeTextField()
        textField.defaultCharacter = "_"
        textField.configure()
        textField.didEnterLastDigit = { [weak self] code in
            guard let self = self else { return }
            self.authorize(verificationCode: code)
        }
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = Constants.viewTitle
        
        verificationTextField.becomeFirstResponder()
        
        makeUI()
    }
    
    init(verificationID: String, phoneNumber: String) {
        self.verificationID = verificationID
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Make UI
extension VerificationCodeViewController {
    func makeUI() {
        
        view.addSubview(verificationLabel)
        view.addSubview(verificationTextField)
        
        verificationLabel.snp.makeConstraints {
            if #available(iOS 11, *) {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            } else {
                $0.top.top.equalTo(topLayoutGuide.snp.top).offset(50)
            }
            $0.left.equalTo(40)
            $0.right.equalTo(-40)
        }
        
        verificationTextField.snp.makeConstraints {
            $0.top.equalTo(verificationLabel.snp.bottom).offset(20)
            $0.left.equalTo(40)
            $0.right.equalTo(-40)
            $0.height.equalTo(85)
        }
    }
}

// Firebase authorization
extension VerificationCodeViewController {
    func authorize(verificationCode: String) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.verificationTextField.showError()
                print(error.localizedDescription)
                return
            }
            
            self.verificationTextField.resignFirstResponder()
            
            guard let authResult = authResult else { return }
            
            let documentReference = self.db.collection("users").document("\(authResult.user.uid)")
            documentReference.getDocument { (document, error) in
                if let document = document, !document.exists {
                    documentReference.setData([
                        "firstName": nil,
                        "middleName": nil,
                        "surName": nil,
                        "phone": "\(authResult.user.phoneNumber ?? "")",
                        "avatarUrl": nil,
                        "email": nil
                    ])
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

