//
//  PhotoCollectionView.swift
//  SafeStorage
//
//  Created by Akan Akysh on 4/25/20.
//  Copyright © 2020 AkyshAkan. All rights reserved.
//

import UIKit

class PhotoCollectionView: UICollectionView {
    
    enum Constants {
        static let cellIdentifier = "photoCollectioncell"
    }
    
    var photoDelegate: PhotoDelegate?
    
    var images: [UIImage] = [] {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        delegate = self
        dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImages(images: [UIImage]) {
        self.images = images
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        images.remove(at: sender.tag)
        photoDelegate?.deletePhoto(at: sender.tag)
    }
}


// Colection view delegate
extension PhotoCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        cell.configure(with: images[indexPath.row])
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
}
