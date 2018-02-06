//
//  FollowersUserCell.swift
//  InstaChain
//
//  Created by John Nik on 2/2/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

enum FollowType {
    case follower
    case following
}

class FollowersUserCell: BaseCollectionViewCell {
    
    var followType: FollowType?
    
    var follower: FollowersData? {
        
        didSet {
            
            guard let follower = follower else { return }
            guard let type = followType else { return }
            
            if type == .follower {
                if let followerName = follower.follower {
                    userNameLabel.text = followerName
                    userTagLabel.text = "@" + followerName
                }
            } else {
                if let followerName = follower.following {
                    userNameLabel.text = followerName
                    userTagLabel.text = "@" + followerName
                }
            }
            
            
            guard let imageUrlString = follower.authorProfileImage, let imageUrl = URL(string: imageUrlString) else { return }
            userImageView.sd_addActivityIndicator()
            userImageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = GAP50 / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = DarkModeManager.getProfileImageBorderColor().cgColor
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
        
        backgroundColor = DarkModeManager.getViewBackgroundColor()
        
        setupStuff()
    }
    
}

extension FollowersUserCell {
    
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
