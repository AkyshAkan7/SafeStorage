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
import FirebaseFirestore
import FirebaseStorage

protocol PhotoDelegate {
    func deletePhoto(at index: Int)
}

protocol CategoryDelegate {
    func setCategory(at index: Int)
}

protocol MonthDelegate {
    func setMonth(month: String)
}

class MakeOrderViewController: UIViewController {
    
    // TODO: add fields
    // storage period
    
    typealias FormData = (name: String, address: String, time: String, comment: String, category: String, retentionPeriod: String)
    
    private var photoAssets = [PHAsset]()
    private var photoArray = [UIImage]()
    private var selectedCategory: Category? {
        didSet {
            categoryButton.setTitle(selectedCategory?.title, for: .normal)
        }
    }
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    lazy var categoryListLauncher: CategoryListLauncher = {
        let launcher = CategoryListLauncher()
        launcher.categoryDelegate = self
        return launcher
    }()
    
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
    
    let orderNameTextField: FloatLabelTextField = {
        let textField = FloatLabelTextField()
        textField.placeholder = "Наименование товара"
        return textField
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
        textField.placeholder = "Дата и время"
        textField.inputView = datePicker
        return textField
    }()
    
    lazy var monthPickerView: MonthPickerView = {
        let picker = MonthPickerView()
        picker.monthPickerDelegate = self
        return picker
    }()
    
    lazy var retentionPeriodTextField: FloatLabelTextField = {
        let textField = FloatLabelTextField()
        textField.placeholder = "Срок хранения"
        textField.inputView = monthPickerView
        return textField
    }()
    
    let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        return label
    }()
    
    let categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выберите категорию", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.systemGray5
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(categoryButtonHoldDown), for: .touchDown)
        return button
    }()
    
    let photoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фото"
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        return label
    }()
    
    let addPhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "DarkBlue")
        let plusButton = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = .white
        button.setImage(plusButton, for: .normal)
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var photoCollectionView: PhotoCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let collectionView = PhotoCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray5
        collectionView.photoDelegate = self
        return collectionView
    }()
    
    let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneDatePickerTapped))
        
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
    
    let confirmButton: LoadingButton = {
        let button = LoadingButton()
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
    
    override func viewDidLayoutSubviews() {
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
    }
    
    func convertAssetsToImages() {
        if photoAssets.count == 0 {
            return
        }
        
        for i in 0..<photoAssets.count {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            PHImageManager.default().requestImage(for: photoAssets[i], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { (image, info) in
                
                if let data = image?.jpegData(compressionQuality: 0.8) {
                    let pressedImage = UIImage(data: data)
                    self.photoArray.append(pressedImage!)
                }
            }
        }
        self.photoAssets.removeAll()
        
    }
    
    func getFormData() -> FormData? {
        guard let name = orderNameTextField.text, name != "" else { return nil}
        guard let address = addressTextField.text, address != "" else { return nil }
        guard let time = dateTextField.text, time != "" else { return nil }
        let comment = commentTextField.text ?? ""
        guard let retentionPeriod = retentionPeriodTextField.text, retentionPeriod != "" else { return nil}
        guard let category = selectedCategory?.title else { return nil }
        
        let formData = FormData(name: name,address: address, time: time, comment: comment, category: category, retentionPeriod: retentionPeriod)
        return formData
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Заполните все поля", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Ваш заказ оформлен для рассмотрения", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style:  .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func setNotificationBadge() {
        NotificationManager.shared.addUnreadMessage()
        
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = String(NotificationManager.shared.unreadMessages)
        }
    }
    
    @objc func datePickerHandler() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy h:mm"
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc func categoryButtonTapped() {
        categoryListLauncher.show()
        categoryButton.backgroundColor = UIColor.systemGray5
        categoryButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func categoryButtonHoldDown() {
        categoryButton.backgroundColor = UIColor.systemGray
        categoryButton.setTitleColor(.white, for: .normal)
    }
    
    @objc func addImageButtonTapped() {
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
            self.photoCollectionView.setImages(images: self.photoArray)
        })
    }
    
    
    @objc func doneDatePickerTapped() {
        self.view.endEditing(true)
    }
    
    @objc func confirmButtonTapped() {
        confirmButton.showLoading()
        guard let uid = CurrentUser.shared.user.uid else {
            showErrorAlert()
            confirmButton.hideLoading()
            return
        }
        guard let formData = getFormData() else {
            showErrorAlert()
            confirmButton.hideLoading()
            return
        }
        Firestore.firestore().collection("users").document("\(uid)").collection("products").addDocument(data: [
            "name": formData.name,
            "address": formData.address,
            "category": formData.category,
            "comment": formData.comment,
            "time": formData.time,
            "retentionPeriod": formData.retentionPeriod,
            "status": Status.processing.rawValue
        ]) { error in
            
            self.confirmButton.hideLoading()
            
            if let error = error {
                print(error.localizedDescription)
                self.showErrorAlert()
            } else {
                NotificationManager.shared.addNotification(forItem: formData.name)
                self.setNotificationBadge()
                self.showSuccessAlert()
            }
        }
    }
}

// Make UI
extension MakeOrderViewController {
    func setupNavigationBar() {
        navigationItem.title = "Заказ"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupToolBar() {
        [orderNameTextField, addressTextField, commentTextField, dateTextField, retentionPeriodTextField].forEach {
            $0.inputAccessoryView = toolBar
        }
    }
    
    func makeUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        [orderNameTextField, addressTextField, commentTextField, confirmButton, dateTextField, retentionPeriodTextField, categoryTitleLabel, categoryButton, photoTitleLabel, addPhotoButton, photoCollectionView].forEach {
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
        
        orderNameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(55)
        }
        
        addressTextField.snp.makeConstraints {
            $0.top.equalTo(orderNameTextField.snp.bottom).offset(30)
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
        
        retentionPeriodTextField.snp.makeConstraints {
            $0.top.equalTo(dateTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(55)
        }
        
        categoryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(retentionPeriodTextField.snp.bottom).offset(30)
            $0.left.equalTo(20)
            $0.height.equalTo(28)
        }
        
        categoryButton.snp.makeConstraints {
            $0.top.equalTo(categoryTitleLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(-20)
            $0.height.equalTo(70)
        }
        
        photoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryButton.snp.bottom).offset(30)
            $0.left.equalTo(20)
            $0.height.equalTo(28)
        }

        addPhotoButton.snp.makeConstraints {
            $0.top.equalTo(categoryButton.snp.bottom).offset(32)
            $0.left.equalTo(photoTitleLabel.snp.right).offset(10)
            $0.width.height.equalTo(24)
        }

        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(photoTitleLabel.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(70)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(photoCollectionView.snp.bottom).offset(50)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        }
    }
}

// Photo delegate
extension MakeOrderViewController: PhotoDelegate {
    func deletePhoto(at index: Int) {
        photoArray.remove(at: index)
    }
}

// Category delegate
extension MakeOrderViewController: CategoryDelegate {
    func setCategory(at index: Int) {
        selectedCategory = CategoryManager.shared.models[index]
    }
}

// Month delegate
extension MakeOrderViewController: MonthDelegate {
    func setMonth(month: String) {
        retentionPeriodTextField.text = month
    }
}
