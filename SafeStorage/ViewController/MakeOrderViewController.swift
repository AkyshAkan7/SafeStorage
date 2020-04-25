//
//  MakeOrderViewController.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/22/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit
import AKMaskField
import BSImagePicker
import Photos

class MakeOrderViewController: UIViewController {
    
    // TODO: add fields
    // category
    // photo
    // date and time
    // storage period
    
    private var photoAssets = [PHAsset]()
    private var photoArray = [UIImage]()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 150)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = contentViewSize
        scrollView.bounds = self.view.bounds
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = contentViewSize
        return view
    }()
    
    let addressTextField: FloatLabelTextField = {
        let textField = FloatLabelTextField()
        textField.placeholder = "Адрес"
        return textField
    }()
    
    let commentTextField: FloatLabelTextField = {
        let textField = FloatLabelTextField()
        textField.placeholder = "Комментарий"
        return textField
    }()
    
    lazy var dateTextField: FloatLabelTextField = {
        let textField = FloatLabelTextField()
        textField.placeholder = "Время"
        textField.inputView = datePicker
//        textField.inputAccessoryView = toolbar
        return textField
    }()
    
    let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneDatePickerPressed))
        
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        picker.maximumDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())
        picker.minuteInterval = 10
        picker.addTarget(self, action: #selector(datePickerHandler), for: .valueChanged)
        return picker
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оформить", for: .normal)
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "DarkBlue")
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupToolBar()
        makeUI()
    }
    
    func convertAssetsToImages() {
        if photoAssets.count == 0 {
            return
        }
        
        for i in 0..<photoAssets.count {
            PHImageManager.default().requestImage(for: photoAssets[i], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, info) in
                if let data = image?.jpegData(compressionQuality: 0.8) {
                    let pressedImage = UIImage(data: data)
                    self.photoArray.append(pressedImage!)
                }
                
            }
        }
    }
    
    @objc func datePickerHandler() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy h:mm"
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc func doneDatePickerPressed() {
        self.view.endEditing(true)
    }
    
    @objc func confirmButtonTapped() {
        let imagePicker = ImagePickerController()
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            for i in 0..<assets.count {
                self.photoAssets.append(assets[i])
            }
            self.convertAssetsToImages()
        })
    }
}

// Make UI
extension MakeOrderViewController {
    func setupNavigationBar() {
        navigationItem.title = "Заказ"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupToolBar() {
        addressTextField.inputAccessoryView = toolBar
        commentTextField.inputAccessoryView = toolBar
        dateTextField.inputAccessoryView = toolBar
    }
    
    func makeUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        [addressTextField, commentTextField, confirmButton, dateTextField].forEach {
            containerView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            if #available(iOS 11, *) {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.top.top.equalTo(topLayoutGuide.snp.top)
                $0.bottom.equalTo(bottomLayoutGuide.snp.bottom)
            }
            $0.left.right.equalToSuperview()
        }
        
        addressTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(55)
        }
        
        commentTextField.snp.makeConstraints {
            $0.top.equalTo(addressTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(55)
        }
        
        dateTextField.snp.makeConstraints {
            $0.top.equalTo(commentTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(55)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        }
    }
}
