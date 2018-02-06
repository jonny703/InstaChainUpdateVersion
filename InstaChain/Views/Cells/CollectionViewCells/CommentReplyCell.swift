//
//  CommentReplyCell.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

class CommentReplyCell: CommentCell {
    
    var commentReply: PostData? {
        didSet {
            guard let comment = commentReply else { return }
            
            let time = TimeDateUtils.timeAgoSinceDate(TimeDateUtils.convertStringToDate(date: comment.created, with: TimeDateUtils.DATE_TIME_FORMAT_1));
            
            let attributedText = NSMutableAttributedString(string: comment.author, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: DarkModeManager.getDefaultTextColor()])
            attributedText.append(NSAttributedString(string: "          " + time + "\n\n" + comment.body, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: DarkModeManager.getDefaultTextColor()]))
            
            textView.attributedText = attributedText
            
            guard let imageUrlStr = comment.authorProfileImage, let imageUrl = URL(string: imageUrlStr) else { return }
            profileImageView.sd_addActivityIndicator()
            profileImageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    override func setupViews() {
        
        addSubview(profileImageView)
        _ = profileImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 56, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        
        addSubview(textView)
        _ = textView.anchor(topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 10, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }
}
