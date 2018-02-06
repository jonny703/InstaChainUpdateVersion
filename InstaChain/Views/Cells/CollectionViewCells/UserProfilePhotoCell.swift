//
//  UserProfilePhotoCell.swift
//  InstaChain
//
//  Created by John Nik on 2/2/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: BaseCollectionViewCell {
    
    var imageUrlString: String? {
        didSet {
            
            guard let imageUrlString = imageUrlString, let imageUrl = URL(string: imageUrlString) else { return }
            
            photoImageView.sd_addActivityIndicator()
            photoImageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0, alpha: 0.2)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(photoImageView)
        _ = photoImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
