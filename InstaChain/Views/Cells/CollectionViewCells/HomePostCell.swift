//
//  HomePostCell.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SDWebImage
import ActiveLabel
import ObjectMapper

class HomePostCell: BaseCollectionViewCell {
    
    let labelTag = 1
    
    var index : Int?
    var permlink: String?
    var isUserLikePost: Bool?
    var votesCount: Int = 0
    
    var homeController: HomeController?
    
    
    var discussionData: DiscussionsData? {
        
        didSet {
            guard let discussionData = discussionData else { return }
            
            if let userImageUrlStr = discussionData.authorImage, let userImageUrl = URL(string: userImageUrlStr) {
                userImageView.sd_addActivityIndicator()
                userImageView.sd_setImage(with: userImageUrl, completed: nil)
            }
            
            userNameLabel.text = discussionData.author
            postTimeLabel.text = TimeDateUtils.timeAgoSinceDate(TimeDateUtils.convertStringToDate(date: discussionData.created, with: TimeDateUtils.DATE_TIME_FORMAT_1), numericDates: false)
            
            self.textView.viewWithTag(1)?.removeFromSuperview()
            let title = discussionData.title.uppercased()
            let activateLabel = self.getPostTitle(withTag: discussionData.tags, title: title, height: textView.frame.height - 2)
            self.textView.addSubview(activateLabel)
            
            userTagLabel.text = "@" + discussionData.author
            
            self.votesCount = discussionData.netVotes
            totalVotesLabel.text = "\(self.votesCount)" + " Interests"
            
            self.permlink = discussionData.permlink
            balancesLabel.text = discussionData.totalPayoutValue
            
            for i in 0..<discussionData.voters.count {
                if discussionData.voters[i].voter == CurrentSession.getI().localData.userBaseInfo?.name{
                    if discussionData.voters[i].weight != 0 {
                        self.isUserLikePost = true
                        self.likesButton.tintColor = StyleGuideManager.realyfeDefaultGreenColor
                    }else {
                        self.isUserLikePost = false
                        self.likesButton.tintColor = UIColor.darkGray
                        
                    }
                    
                }
            }
            
            if let postImageUrl = discussionData.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                ServerImageFetcher.i.loadImageIn(postImageView, url: postImageUrl)
            }
            
            if let postImageUrl = URL(string: discussionData.image) {
                postImageView.sd_addActivityIndicator()
                postImageView.sd_setImage(with: postImageUrl, completed: nil)
            }
        }
        
    }
    
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
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = DarkModeManager.getDefaultTextColor()
        label.font = UIFont.systemFont(ofSize: FONTSIZE17)
        return label
    }()
    
    let totalVotesLabel: UILabel = {
        let label = UILabel()
        label.textColor = DarkModeManager.getDefaultTextColor()
        label.font = UIFont.systemFont(ofSize: FONTSIZE20)
        return label
    }()
    
    let balancesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FONTSIZE20)
        label.textColor = StyleGuideManager.realyfeDefaultGreenColor
        return label
    }()
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = GAP50 / 2
        imageView.layer.borderColor = DarkModeManager.getProfileImageBorderColor().cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapUserProfileImageView))
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap(tapGesture:)))
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    
    let userInfoView: UIView = {
        let view = UIView()
        return view
    }()
    
    let textView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var likesButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.likeIcon.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.tintColor = .lightGray
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.commentIcon.rawValue)?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    // label for use multiple tags is add as subview as this view
    override func setupViews() {
        super.setupViews()
        
        setupUserInfoView()
        setupPostImageView()
        setupOtherStuffView()
    }
    
     @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        
        if let imageView = tapGesture.view as? UIImageView {
            
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            
            self.homeController?.performZoomingForStartingImageView(startingImageView: imageView)
        }
        
        
    }
    
    @objc func handleTapUserProfileImageView() {
        
        guard let discussion = discussionData else { return }
        
        homeController?.handleGoingProfileController(discussion: discussion)
    }
    
    //MARK: handle comment
    @objc func handleComment() {
        
        guard let discussion = discussionData else { return }
        homeController?.handleGoingCommentController(discussion: discussion)
    }
    
    @objc func handleLike() {
        self.likesButton.isUserInteractionEnabled = false
        guard let discussion = discussionData else { return }
        
        let author = discussion.author
        let permlink = discussion.permlink
        
        var weight = 10000
        if let isUserLikePost = self.isUserLikePost {
            weight = isUserLikePost ? 0 : 10000
        }
        
        
        guard let wif = CurrentSession.getI().localData.privWif?.active else { return }
        
        self.giveVoteToPost(author: author, permlink: permlink, weight: weight, wif: wif)
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
                        
                        if let homeController = self.homeController {
                            homeController.showJHTAlerttOkayWithIcon(message: "You have reached your limit")
                        }
                    }
                }
            }
        })
        
    }
    
    func resetLikeStatus() {
        
        if self.votesCount >= 0 {
            totalVotesLabel.text = "\(self.votesCount)" + " Interests"
        }
        if let isUserLikePost = self.isUserLikePost {
            likesButton.tintColor =  isUserLikePost ? StyleGuideManager.realyfeDefaultGreenColor : UIColor.darkGray
            
        }
        likesButton.isUserInteractionEnabled = true
    }
}

//delegate for Active Label
extension HomePostCell: ActiveLabelDelegate{
    
    func getPostTitle(withTag: [String], title: String, height: CGFloat) -> UILabel{
        let label = ActiveLabel()
        label.tag = self.labelTag
        let tagString = withTag.map { "#\($0) " }
        
        label.enabledTypes = [.hashtag]
        label.delegate = self
        label.font = UIFont.systemFont(ofSize: FONTSIZE16)
        label.textColor = DarkModeManager.getDefaultTextColor()
        label.hashtagColor = UIColor.appPrimary()
        label.numberOfLines = 0
        
        label.frame = CGRect(x: 20, y: 0, width: frame.width - 40, height: height)
        
        label.text = title + " " + tagString.joined(separator: " ")
        label.sizeToFit()
        return label
    }
    
    func didSelect(_ text: String, type: ActiveType) {
        self.homeController?.showJHTAlerttOkayWithIcon(message: text)
    }
}

extension HomePostCell {
    
    fileprivate func setupUserInfoView() {
        addSubview(userInfoView)
        _ = userInfoView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: GAP10 * 7)
        
        userInfoView.addSubview(userImageView)
        userInfoView.addSubview(postTimeLabel)
        userInfoView.addSubview(userNameLabel)
        userInfoView.addSubview(userTagLabel)
        
        
        _ = userImageView.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: GAP50, heightConstant: GAP50)
        userImageView.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor).isActive = true
        
        _ = postTimeLabel.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: GAP100 + GAP10, heightConstant: GAP20)
        postTimeLabel.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor).isActive = true

        _ = userNameLabel.anchor(userImageView.topAnchor, left: userImageView.rightAnchor, bottom: nil, right: postTimeLabel.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: GAP20)

        _ = userTagLabel.anchor(nil, left: userNameLabel.leftAnchor, bottom: userImageView.bottomAnchor, right: postTimeLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: GAP20)
        
    }
    
    fileprivate func setupPostImageView() {
        
        addSubview(postImageView)
        _ = postImageView.anchor(userInfoView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: GAP50 * 5 )
        
    }
    
    fileprivate func setupOtherStuffView() {
        
        addSubview(totalVotesLabel)
        _ = totalVotesLabel.anchor(postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: GAP100, heightConstant: GAP40)
        
        addSubview(likesButton)
        _ = likesButton.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: GAP30, widthConstant: GAP50 / 2, heightConstant: GAP50 / 2)
        likesButton.centerYAnchor.constraint(equalTo: totalVotesLabel.centerYAnchor).isActive = true
        
        addSubview(commentButton)
        _ = commentButton.anchor(nil, left: nil, bottom: nil, right: likesButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: GAP20, widthConstant: GAP50 / 2, heightConstant: GAP50 / 2)
        likesButton.centerYAnchor.constraint(equalTo: commentButton.centerYAnchor).isActive = true
        
        addSubview(balancesLabel)
        _ = balancesLabel.anchor(totalVotesLabel.topAnchor, left: totalVotesLabel.rightAnchor, bottom: totalVotesLabel.bottomAnchor, right: commentButton.leftAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        addSubview(textView)
        _ = textView.anchor(totalVotesLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
}




























