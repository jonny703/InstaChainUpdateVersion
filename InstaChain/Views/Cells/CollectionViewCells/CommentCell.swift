//
//  CommentCell.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import ObjectMapper

class CommentCell: BaseCollectionViewCell {
    
    var commentController: CommentsController?
    var isUserLikePost: Bool?
    var votesCount: Int = 0
    
    var comment: PostData? {
        didSet {
            guard let comment = comment else { return }

            let time = TimeDateUtils.timeAgoSinceDate(TimeDateUtils.convertStringToDate(date: comment.created, with: TimeDateUtils.DATE_TIME_FORMAT_1));
            
            let attributedText = NSMutableAttributedString(string: comment.author, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: DarkModeManager.getDefaultTextColor()])
            attributedText.append(NSAttributedString(string: "          " + time + "\n\n" + comment.body, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: DarkModeManager.getDefaultTextColor()]))

            textView.attributedText = attributedText
            
            votesCount = comment.netVotes
            if votesCount > 0 {
                let likeTitle = "\(votesCount) Interests"
                likesLabel.text = likeTitle
            }
            if let like = checkUserLikeStatus(data: comment.activeVotes) {
                likesButton.tintColor = like ? StyleGuideManager.realyfeDefaultGreenColor : UIColor.darkGray
            }
            
            guard let imageUrlStr = comment.authorProfileImage, let imageUrl = URL(string: imageUrlStr) else { return }
            profileImageView.sd_addActivityIndicator()
            profileImageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = DarkModeManager.getDefaultTextColor()
        textView.backgroundColor = DarkModeManager.getCommentTextViewBackgroundColor()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        return textView
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: AssetName.myProfile.rawValue)?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(white: 0, alpha: 0.1)
        iv.layer.cornerRadius = 20
        iv.layer.borderColor = DarkModeManager.getProfileImageBorderColor().cgColor
        iv.layer.borderWidth = 1
        iv.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        iv.addGestureRecognizer(gesture)
        return iv
    }()
    
    let likesLabel:UILabel = {
        
        let label = UILabel()
        label.text = "0 Interests"
        label.textColor = DarkModeManager.getDefaultTextColor()
        return label
    }()
    
    lazy var likesButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.commentLike.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.tintColor = .lightGray
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    lazy var replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reply", for: .normal)
        button.tintColor = DarkModeManager.getDefaultTextColor()
        button.addTarget(self, action: #selector(handleReply), for: .touchUpInside)
        return button
    }()
    
    override func setupViews() {
        
        super.setupViews()
        
        addSubview(profileImageView)
        _ = profileImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        
        let stackView = UIStackView(arrangedSubviews: [likesLabel, likesButton, replyButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.anchor(top: nil, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 4, paddingRight: 4, width: 0, height: 30)
        
        addSubview(textView)
        _ = textView.anchor(topAnchor, left: profileImageView.rightAnchor, bottom: stackView.topAnchor, right: rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }
    
    @objc private func handleReply() {
        
        guard let comment = comment else { return }
        let commentAuthor = comment.author
        let commentPermlink = comment.permlink
        
        commentController?.commentAuthor = commentAuthor
        commentController?.commentPermlink = commentPermlink
        commentController?.writingStatus = .reply
        commentController?.containerView.commentTextView.placeholderLabel.text = "Write a reply"
        commentController?.containerView.commentTextView.becomeFirstResponder()
        commentController?.cancelReplyButton.isEnabled = true
        
    }
    
    @objc private func handleLike() {
        self.likesButton.isUserInteractionEnabled = false
        guard let discussion = comment else { return }
        
        let author = discussion.author
        let permlink = discussion.permlink
        var weight = 10000
        if let isUserLikePost = self.isUserLikePost {
            weight = isUserLikePost ? 0 : 10000
        }
        guard let wif = CurrentSession.getI().localData.privWif?.active else { return }
        
        self.giveVoteToPost(author: author, permlink: permlink, weight: weight, wif: wif)
    }
    
    @objc private func handleProfileImageTap() {
        guard let username = comment?.author else { return }
        commentController?.handleGoingProfileController(username: username)
    }
    
    func giveVoteToPost(author: String, permlink: String, weight: Int, wif: String) {
        
        
        let data = CurrentSession.getI().localData.userBaseInfo
        
        AppServerRequests.voteToDiscussion(voter: data!.name, author: author, permlink: permlink, weight: weight, wif: wif, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                _ = response as? HTTPURLResponse
                let responseString = String(data: data!, encoding: .utf8)
                print(responseString)
                let key = Mapper<VoteResponseData>().map(JSONString: responseString!)
                
                
                print(key?.refBlockNum)
                if key != nil {
                    
                    if let isUserLikePost = self.isUserLikePost {
                        self.isUserLikePost = !isUserLikePost
                    } else {
                        self.isUserLikePost = true
                        self.votesCount = self.votesCount + 1
                    }
                    DispatchQueue.main.async {
                        
                        self.resetLikeStatus()
                    }
                    
                }else{
                    
                    DispatchQueue.main.async {
                        
                        if let commentController = self.commentController {
                            commentController.showJHTAlerttOkayWithIcon(message: "You have reached your limit")
                        }
                    }
                }
            }
        })
        
    }
    
    func resetLikeStatus() {
        
        if self.votesCount >= 0 {
            likesLabel.text = "\(self.votesCount)" + " Interests"
        }
        
        if let isUserLikePost = self.isUserLikePost {
            likesButton.tintColor =  isUserLikePost ? StyleGuideManager.realyfeDefaultGreenColor : UIColor.darkGray
            
        }
        likesButton.isUserInteractionEnabled = true
    }
    
    func checkUserLikeStatus(data: [ActiveVoterData]) -> Bool? {
        for i in 0..<data.count{
            if data[i].voter == CurrentSession.getI().localData.userBaseInfo?.name {
                if data[i].weight != 0 {
                    isUserLikePost = true
                    
                    return true
                }else {
                    isUserLikePost = false
                    
                    return false
                    
                }
            }
        }
        return nil
    }
}
