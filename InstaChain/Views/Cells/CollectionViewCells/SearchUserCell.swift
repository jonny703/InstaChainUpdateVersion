//
//  SearchUserCell.swift
//  InstaChain
//
//  Created by John Nik on 2/3/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

class SearchUserCell: BaseCollectionViewCell {
    
    var user: UserInfoData? {
        
        didSet {
            
            guard let profileData = user else { return }
            
            userNameLabel.text = profileData.jsonMetadata?.profile?.name
            userTagLabel.text = "@" + profileData.name
            
            guard let profileImageUrlString = profileData.jsonMetadata?.profile?.profileImage, let profileImageUrl = URL(string: profileImageUrlString) else { return }
            
            userImageView.sd_setIndicatorStyle(.gray)
            userImageView.sd_addActivityIndicator()
            userImageView.sd_setImage(with: profileImageUrl, completed: nil)
            
        }
    }
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = GAP50 / 2
        imageView.layer.borderColor = DarkModeManager.getProfileImageBorderColor().cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = DarkModeManager.getDefaultTextColor()
        label.font = UIFont.systemFont(ofSize: FONTSIZE20)
        return label
    }()
    
    let userTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = DarkModeManager.getDefaultTextColor()
        label.font = UIFont.systemFont(ofSize: FONTSIZE17)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .clear
        
        setupStuff()
    }
    
}

extension SearchUserCell {
    
    fileprivate func setupStuff() {
        
        addSubview(userImageView)
        _ = userImageView.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: GAP50, heightConstant: GAP50)
        userImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(userNameLabel)
        _ = userNameLabel.anchor(userImageView.topAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: GAP20)
        
        addSubview(userTagLabel)
        _ = userTagLabel.anchor(nil, left: userNameLabel.leftAnchor, bottom: userImageView.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: GAP20)
        
    }
}

