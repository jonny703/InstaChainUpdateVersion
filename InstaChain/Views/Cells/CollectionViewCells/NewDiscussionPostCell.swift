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
            
            if let count = discussionDetailData.netVotes {
                self.votesCount = count
                totalVotesLabel.text = String(self.votesCount) + " Likes"
            }
            
            
            self.permlink = discussionDetailData.permlink
            balancesLabel.text = discussionDetailData.totalPayoutValue
            
            self.resetLikeButtonTintColor(isLike: checkUserLikeStatus(data: discussionDetailData.activeVotes))
            
            
            if let postImageUrlStr = discussionDetailData.jsonMetadata?.image, let postImageUrl = URL(string: postImageUrlStr) {
                postImageView.sd_addActivityIndicator()
                postImageView.sd_setImage(with: postImageUrl, completed: nil)
            }
            
        }
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
        
        guard let discussion = discussionDetailData else { return }
        
        guard let author = discussion.author else { return }
        guard let permlink = discussion.permlink else { return }
        let weight = isUserLikePost ? 0 : 10000
        
        guard let wif = CurrentSession.getI().localData.privWif?.active else { return }
        
        self.giveVoteToPost(author: author, permlink: permlink, weight: weight, wif: wif)
    }
    
}
