//
//  FollowerUserCell.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

class FollowerUserCell: BaseTableViewCell {
    
    var follower: FollowersData? {
        
        didSet {
            
            guard let follower = follower else { return }
            
            if let followerName = follower.follower {
                userNameLabel.text = followerName
                userTagLabel.text = "@" + followerName
            }
            
            guard let imageUrl = follower.authorProfileImage else { return }
            ServerImageFetcher.i.loadProfileImageIn(userImageView, url: imageUrl)
        }
    }
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = GAP50 / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FONTSIZE20)
        return label
    }()
    
    let userTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FONTSIZE17)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupStuff()
    }
    
}

extension FollowerUserCell {
    
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















