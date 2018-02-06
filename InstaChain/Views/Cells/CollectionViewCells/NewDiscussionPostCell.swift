//
//  NewDiscussionPostCell.swift
//  InstaChain
//
//  Created by John Nik on 2/4/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import ObjectMapper

class NewDiscussionPostCell: HomePostCell {
    
    var discussionDetailController: DiscussionDetailController?
    
    var discussionDetailData: DetailDiscussionData? {
        
        didSet {
            
            guard let discussionDetailData = discussionDetailData else { return }
            
            if let userImageUrlStr = discussionDetailData.authorImageUrl, let userImageUrl = URL(string: userImageUrlStr) {
                userImageView.sd_addActivityIndicator()
                userImageView.sd_setImage(with: userImageUrl, completed: nil)
            }
            
            userNameLabel.text = discussionDetailData.author
            postTimeLabel.text = TimeDateUtils.timeAgoSinceDate(TimeDateUtils.convertStringToDate(date: discussionDetailData.created!, with: TimeDateUtils.DATE_TIME_FORMAT_1), numericDates: false)
            
            self.textView.viewWithTag(1)?.removeFromSuperview()
            let title = discussionDetailData.title?.uppercased()
            let activateLabel = self.getPostTitle(withTag: discussionDetailData.jsonMetadata?.tags ?? [""], title: title ?? "", height: textView.frame.height - 2)
            self.textView.addSubview(activateLabel)
            
            if let userTag = discussionDetailData.author {
                userTagLabel.text = "@" + userTag
            }
            
            self.votesCount = discussionDetailData.activeVotes.count
            totalVotesLabel.text = String(self.votesCount) + " Interests"
            
            
            
            self.permlink = discussionDetailData.permlink
            balancesLabel.text = discussionDetailData.totalPayoutValue
            if let like = checkUserLikeStatus(data: discussionDetailData.activeVotes) {
                likesButton.tintColor = like ? StyleGuideManager.realyfeDefaultGreenColor : UIColor.darkGray
            }
            
            
            if let postImageUrlStr = discussionDetailData.jsonMetadata?.image, let postImageUrl = URL(string: postImageUrlStr) {
                postImageView.sd_addActivityIndicator()
                postImageView.sd_setImage(with: postImageUrl, completed: nil)
            }
            
        }
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
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            
            self.discussionDetailController?.performZoomingForStartingImageView(startingImageView: imageView)
        }
    }
    
    override func handleComment() {
        
        guard let dicussion = discussionDetailData else { return }
        discussionDetailController?.handleGoingCommentController(discussion: dicussion)
    }
    
    override func handleLike() {
        
        self.likesButton.isUserInteractionEnabled = false
        guard let discussion = discussionDetailData else { return }
        
        guard let author = discussion.author else { return }
        guard let permlink = discussion.permlink else { return }
        var weight = 10000
        if let isUserLikePost = self.isUserLikePost {
            weight = isUserLikePost ? 0 : 10000
        }
        guard let wif = CurrentSession.getI().localData.privWif?.active else { return }
        
        self.giveVoteToPost(author: author, permlink: permlink, weight: weight, wif: wif)
    }
    
    override func giveVoteToPost(author: String, permlink: String, weight: Int, wif: String) {
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
                        
                        if let discussionDetailController = self.discussionDetailController {
                            discussionDetailController.showJHTAlerttOkayWithIcon(message: "You have reached your limit")
                        }
                    }
                }
            }
        })
    }
    
    override func resetLikeStatus() {
        
        if self.votesCount >= 0 {
            totalVotesLabel.text = String(self.votesCount) + " Interests"
        }
        
        if let isUserLikePost = self.isUserLikePost {
            likesButton.tintColor =  isUserLikePost ? StyleGuideManager.realyfeDefaultGreenColor : UIColor.darkGray
            
        }
        likesButton.isUserInteractionEnabled = true
    }
    
}
