//
//  VerificationCodeTextField.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/12/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit
import SnapKit

class VerificationCodeTextField: UITextField {
    
    var didEnterLastDigit: ((String) -> Void)?
    
    var defaultCharacter = ""
    
    private var isConfigured = false
    
    var digitalLabels = [UILabel]()
    
    var verticalStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    var errorLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 375, height: 30))
        label.text = "Неправильный код"
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure(with slotCount: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(verticalStackView)
        [errorLabel, labelsStackView].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        verticalStackView.addArrangedSubview(errorLabel)
        verticalStackView.addArrangedSubview(labelsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        verticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func showError() {
        errorLabel.textColor = .systemRed
        digitalLabels.forEach {
            $0.backgroundColor = UIColor.systemRed.withAlphaComponent(0.4)
            $0.text = "_"
        }
        text?.removeAll()
    }
    
    func hideError() {
        errorLabel.textColor = .white
        digitalLabels.forEach {
            $0.backgroundColor = UIColor.systemGray5
        }
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        delegate = self
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 35)
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            label.backgroundColor = .systemGray5
            label.layer.cornerRadius = 5
            label.layer.masksToBounds = true
            
            stackView.addArrangedSubview(label)
            
            digitalLabels.append(label)
        }
        
        return stackView
    }
    
    @objc
    private func textDidChange() {
        
        guard let text = self.text, text.count <= digitalLabels.count else { return }
        
        for i in 0..<digitalLabels.count {
            let currentLabel = digitalLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text = defaultCharacter
            }
        }
        
        if text.count == digitalLabels.count {
            didEnterLastDigit?(text)
        }
    }
    
}

extension VerificationCodeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        hideError()
        return characterCount < digitalLabels.count || string == ""
    }
}
