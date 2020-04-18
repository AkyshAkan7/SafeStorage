//
//  LoginViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/7/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit
import SnapKit
import AKMaskField
import Firebase

class LoginViewController: UIViewController {
    
    enum Constants {
        static let viewTitle = "Вход"
        static let phoneNumberTitle = "Номер Телефона"
        static let continueButtonTitle = "Продолжить"
    }
    
    lazy var numberTextField: FloatLabelTextField = {
        var textField = FloatLabelTextField()
        textField.placeholder = Constants.phoneNumberTitle
        textField.maskDelegate = self
        textField.maskExpression = "+7  ({ddd}) {ddd} {dd} {dd}"
        textField.maskTemplate = "-"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    var continueButton: UIButton = {
        var btn = UIButton()
        btn.setTitle(Constants.continueButtonTitle, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = Constants.viewTitle
        
        numberTextField.becomeFirstResponder()
        makeUI()
    }
    
    @objc func continueButtonTapped() {
        numberTextField.resignFirstResponder()
        
        if let isPhoneNumber = numberTextField.text?.isPhoneNumber, isPhoneNumber == false {
            return
        }
        
        guard let phoneNumber = numberTextField.text?.formatPhone(with: "+7 (%@) %@ %@ %@") else {
            return
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            
            let vc = VerificationCodeViewController(verificationID: verificationID ?? "",
                                                    phoneNumber: phoneNumber)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func barButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LoginViewController: AKMaskFieldDelegate {
    func maskFieldDidEndEditing(_ maskField: AKMaskField) {
        if maskField == numberTextField, maskField.maskStatus != .complete {
            numberTextField.showError()
        } else {
            numberTextField.hideError()
        }
    }
}


// Make UI
extension LoginViewController {
    func makeUI() {
        let barButton = UIBarButtonItem(title: "Пропустить", style: .plain, target: nil, action: #selector(barButtonTapped))
        navigationItem.rightBarButtonItem = barButton
        
        view.addSubview(numberTextField)
        view.addSubview(continueButton)
        
        numberTextField.snp.makeConstraints {
            if #available(iOS 11, *) {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            } else {
                $0.top.top.equalTo(topLayoutGuide.snp.top).offset(50)
            }
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(50)
        }
        
        continueButton.snp.makeConstraints {
            $0.top.equalTo(numberTextField.snp.bottom).offset(40)
            $0.height.equalTo(50)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
        }
        
    }
}
