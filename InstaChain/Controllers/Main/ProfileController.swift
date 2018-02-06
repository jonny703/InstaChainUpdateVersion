//
//  ProfileController.swift
//  InstaChain
//
//  Created by John Nik on 2/4/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import ObjectMapper

class ProfileController: UIViewController {
    
    let userFollowersCellId = "userFollowersCellId"
    let userFollowingsCellId = "userFollowingsCellId"
    let postCellId = "postCellId"
    
    let profileViewHeight = 20 + 80 + 10 + 5 + 5 + GAP20 * 2 + GAP50 + 10
    
    var data = CurrentSession.getI().localData.userBaseInfo
    var visitorData: [UserInfoData?] = [UserInfoData()]
    
    var followers = [FollowersData]()
    var following = [FollowersData]()
    
    var selectedMenuBarIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    var isLookOtherProfile = false
    var profileName: String?
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.textColor = DarkModeManager.getDefaultTextColor()
        label.font = UIFont.systemFont(ofSize: FONTSIZE20)
        return label
    }()
    
    let userTagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.textColor = DarkModeManager.getDefaultTextColor()
        label.font = UIFont.systemFont(ofSize: FONTSIZE18)
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.font = UIFont.systemFont(ofSize: FONTSIZE18)
        label.textColor = DarkModeManager.getDefaultTextColor()
        label.numberOfLines = 2
        return label
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AssetName.myProfile.rawValue)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = DarkModeManager.getImageViewTintColor()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 80 / 2
        imageView.layer.borderColor = DarkModeManager.getProfileImageBorderColor().cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var followButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.followIcon.rawValue)
        button.setImage(image, for: .normal)
        button.backgroundColor = StyleGuideManager.realyfeDefaultGreenColor
        button.tintColor = .white
        button.layer.cornerRadius = 30 / 2
        button.layer.masksToBounds = true
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        return button
    }()
    
    let profileView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.profileController = self
        return mb
    }()
    
    let segmentControl: UISegmentedControl = {
        
        let segement = UISegmentedControl(items: ["Posts 0", "Followers 0", "Following 0"])
        segement.tintColor = StyleGuideManager.realyfeDefaultGreenColor
        segement.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        segement.selectedSegmentIndex = 0
        segement.addTarget(self, action: #selector(handleSegmentControl), for: .valueChanged)
        return segement
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        return cv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        fetchUsers()
        
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getfolloweingsCount), name: .resetFollowersFollowingsCountWhenFollow, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .resetFollowersFollowingsCountWhenFollow, object: nil)
    }
    
}

extension ProfileController {
    
    @objc fileprivate func handleSegmentControl() {
        
    }
}

//MARK: handle follow
extension ProfileController {
    
    @objc fileprivate func handleFollow() {
        
        var imageName = AssetName.unfollowIcon.rawValue
        var what = ["blog"]
        
        if followButton.currentImage == UIImage(named: AssetName.followIcon.rawValue) {
            
            self.setFollowStatusWith(imageName, what: what)
        } else {
            
            self.showJHTAlertDefaultWithIcon(message: "Unfollow\nAre you sure?", firstActionTitle: "No", secondActionTitle: "Yes", action: { (action) in
                
                imageName = AssetName.followIcon.rawValue
                what = []
                
                self.setFollowStatusWith(imageName, what: what)
            })
        }
        
        
    }
    
    private func setFollowStatusWith(_ followButtonImageName: String, what: [String]) {
        
        guard let followedName = profileName, let userName = self.data?.name else { return }
        self.startAndStopFollowing(follower: userName, following: followedName, what: what, wif: CurrentSession.getI().localData.privWif?.active ?? "", followButtonImageName: followButtonImageName)
        
    }
    
    private func resetFollowButtonFollowerUsers(_ imageName: String) {
        let image = UIImage(named: imageName)
        followButton.setImage(image, for: .normal)
        resetFollowerAndFollowings()
    }
    
    func resetFollowerAndFollowings() {
        
        NotificationCenter.default.post(name: .resetFollowersFollowingsCountWhenFollow, object: nil)
        NotificationCenter.default.post(name: .refetchFollowersWhenFollow, object: nil)
    }
    
    func resetFollowingCountInMenuBar() {
        guard let profileData = visitorData[0] else { return }
        
        let postCount = "Posts \(profileData.postCount)"
        let followers = "Followers \(profileData.followerCount)"
        let followings = "Following \(profileData.followingCount)"
        
        self.menuBar.titleNames = [postCount, followers, followings]
        self.menuBar.collectionView.reloadData()
        menuBar.collectionView.selectItem(at: selectedMenuBarIndexPath, animated: false, scrollPosition: [])
    }
    
    @objc func getfolloweingsCount() {
        let userName = isLookOtherProfile ? self.profileName ?? "" : self.data?.name ?? ""
        AppServerRequests.getFollowersCount(account: userName) {
            [weak self] (r) in
            
            guard let strongSelf = self else {
                return }
            switch r {
            case .success (let d):
                if let data = d as? FollowersFollowingData {
                    strongSelf.visitorData[0]?.followerCount = data.followerCount
                    strongSelf.visitorData[0]?.followingCount = data.followingCount
                    DispatchQueue.main.async {
                        strongSelf.resetFollowingCountInMenuBar()
                    }
                }
                break
            default:
                break
            }
        }
    }
    
    // startFollowingUSer
    
    func startAndStopFollowing (follower: String, following: String, what: [String], wif: String, followButtonImageName: String) {
        
        SVProgressHUD.show()
        
        let headers = ["content-type": "application/json",]
        let parameters = [ "follower": follower,
                           "following": following,
                           "what": what,
                           "wif": wif
            ] as [String : Any]
        
        do {
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: ServerUrls.startAndStopFollow)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                SVProgressHUD.dismiss()
                
                if (error != nil) {
                    print(error ?? "")
                } else {
                    _ = response as? HTTPURLResponse
                    let responseString = String(data: data!, encoding: .utf8)
                    print(responseString ?? "")
                    let key = Mapper<BaseResponseData>().map(JSONString: responseString!)
                    if key != nil {}
                    
                    DispatchQueue.main.async {
                        self.resetFollowButtonFollowerUsers(followButtonImageName)
                    }
                    
                }
            })
            
            dataTask.resume()
        }
        catch {
            
        }
    }
    
}

//MARK: handle profile data
extension ProfileController {
    
    fileprivate func handleProfileData() {
        
        guard let profileData = visitorData[0] else { return }
        
        usernameLabel.text = profileData.jsonMetadata?.profile?.name
        userTagLabel.text = "@" + profileData.name
        bioLabel.text = profileData.jsonMetadata?.profile?.about
        
        let postCount = "Posts \(profileData.postCount)"
        let followers = "Followers \(profileData.followerCount)"
        let followings = "Following \(profileData.followingCount)"
        self.menuBar.titleNames = [postCount, followers, followings]
        self.menuBar.collectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        //check follow status
        
        if let followerName = self.data?.name {
            let followStatus = self.followers.filter({(follower: FollowersData) -> Bool in
                guard let name = follower.follower else { return false }
                if followerName == name {
                    return true
                } else {
                    return false
                }
            })
            
            if followStatus.count > 0 {
                let image = UIImage(named: AssetName.unfollowIcon.rawValue)
                followButton.setImage(image, for: .normal)
            }
        }
        
        
        
        guard let profileImageUrlString = profileData.jsonMetadata?.profile?.profileImage, let profileImageUrl = URL(string: profileImageUrlString) else { return }
        
        userImageView.sd_setIndicatorStyle(.gray)
        userImageView.sd_addActivityIndicator()
        userImageView.sd_setImage(with: profileImageUrl, completed: nil)
        
    }
}

//MARK: handle discussion detail
extension ProfileController {
    
    func handleGoingDiscussionDetailController(postedImageData: PostedImageData) {
        
        guard let author = postedImageData.author, let permlink = postedImageData.permlink else { return }
        
        let discussiion = DiscussionsData()
        discussiion.author = author
        discussiion.permlink = permlink
        
        let discussionDetailController = DiscussionDetailController()
        discussionDetailController.discussion = discussiion
        navigationController?.pushViewController(discussionDetailController, animated: true)
    }
    
}

//MARK: fetch data
extension ProfileController {
    
    fileprivate func fetchUsers() {
        guard ReachabilityManager.shared.internetIsUp else {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        self.getUserInfo(name: isLookOtherProfile ? self.profileName ?? "" : self.data?.name ?? "")
    }
    
    fileprivate func getUserInfo(name: String) {
        
        SVProgressHUD.show()
        
        AppServerRequests.fetchUserBaseInformation(username: name){
            [weak self] (r) in
            
            guard let strongSelf = self else {
                SVProgressHUD.dismiss()
                return }
            switch r {
            case .success (let d):
                if let data = d as? Array<UserInfoData> {
                    strongSelf.visitorData.removeAll()
                    strongSelf.visitorData = data
                    self?.getFollowfollowersCount(account: name)
                    
                }
                break
            default:
                break
                
            }
        }
    }
    
    func getFollowfollowersCount(account: String) {
        AppServerRequests.getFollowersCount(account: account) {
            [weak self] (r) in
            
            guard let strongSelf = self else {
                SVProgressHUD.dismiss()
                return }
            switch r {
            case .success (let d):
                if let data = d as? FollowersFollowingData {
                    strongSelf.visitorData[0]?.followerCount = data.followerCount
                    strongSelf.visitorData[0]?.followingCount = data.followingCount
                    
                    self?.fetchUserFollowers(follower: account, limit: "\(data.followerCount)", followType: "blog", url: ServerUrls.followers)
                    self?.fetchUserFollowers(follower: account, limit: "\(data.followingCount)", followType: "blog", url: ServerUrls.following)
                }
                break
            default:
                break
                
            }
        }
    }
    
    //to get users followers
    func fetchUserFollowers(follower: String, limit: String, followType: String, url: String) {
        
        AppServerRequests.getFollowers(follower: follower, followType: followType, limit: limit, url: url){
            [weak self] (r) in
            
            guard let strongSelf = self else {
                SVProgressHUD.dismiss()
                return }
            SVProgressHUD.dismiss()
            switch r {
            case .success (let d):
                if let data = d as? [FollowersData] {
                    if url == ServerUrls.followers{
                        strongSelf.followers.removeAll()
                        strongSelf.followers.append(contentsOf: data)
                    }else{
                        strongSelf.following.removeAll()
                        strongSelf.following.append(contentsOf: data)
                    }
                    
                    strongSelf.handleProfileData()
                }
                break
            default:
                break
                
            }
        }
    }
    
    
}

//MARK: handle scroll
extension ProfileController {
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        selectedMenuBarIndexPath = indexPath
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBArLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        selectedMenuBarIndexPath = indexPath
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
    }
}

//MARK: handle collectionview
extension ProfileController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let userName = isLookOtherProfile ? self.profileName ?? "" : self.data?.name ?? ""
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellId, for: indexPath) as! ProfilePostCell
            cell.userName = isLookOtherProfile ? self.profileName ?? "" : self.data?.name ?? ""
            cell.profileController = self
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userFollowersCellId, for: indexPath) as! ProfileFollowerCell
            cell.userName = userName
            cell.profileController = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userFollowingsCellId, for: indexPath) as! ProfileFollowingCell
            cell.userName = userName
            cell.profileController = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let menuBarHeight: CGFloat = 50
        let height = view.frame.height - profileViewHeight - menuBarHeight - NAVI_HEIGHT
        return CGSize(width: view.frame.width, height:  height)
    }
    
    
}

extension ProfileController {
    
    @objc func dismissController() {
        
        navigationController?.popViewController(animated: true)
    }
    
    func handleGoingOtherProfileController(withUsername username: String) {
        let profileController = ProfileController()
        profileController.profileName = username
        if CurrentSession.getI().localData.userBaseInfo?.name != username {
            profileController.isLookOtherProfile = true
        } else {
            return
        }
        
        let image = UIImage(named: AssetName.leftArrow.rawValue)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(profileController.dismissController))
        profileController.navigationItem.leftBarButtonItem = backButton
        profileController.navigationItem.title = "Profile"
        navigationController?.pushViewController(profileController, animated: true)
    }
}

extension ProfileController {
    
    @objc fileprivate func handleMore() {
        
        self.showActionSheetWith("", message: "", galleryAction: { (action) in
            self.showJHTAlertDefaultWithIcon(message: "Are you sure you want to block this member?", firstActionTitle: "Cancel", secondActionTitle: "Yes", action: { (action) in
                self.showJHTAlerttOkayWithIcon(message: "Thank you for taking a moment to block a user on InstaChain. It is a great help us to have our own members assist us in keeping the InstaChain teams as informative and constructive as possible. We are presently processing your report. InstaChain.")
            })
        }, cameraAction: { (action) in
            self.showJHTAlertDefaultWithIcon(message: "Are you sure you want to report this member?", firstActionTitle: "Cancel", secondActionTitle: "Yes", action: { (action) in
                
                self.showJHTAlerttOkayWithIcon(message: "Thank you for taking a moment to report a user on InstaChain. It is a great help us to have our own members assist us in keeping the InstaChain teams as informative and constructive as possible. We are presently processing your report. InstaChain.")
            })
            
        }, completion: nil)
    }
}

extension ProfileController {
    
    fileprivate func setupViews() {
        
        view.backgroundColor = DarkModeManager.getViewBackgroundColor()
        
        
        setupProfileView()
        setupNavBar()
        setupMenuBar()
        setupCollectionView()
    }
    
    private func setupNavBar() {
        
        if isLookOtherProfile {
            
            let image = UIImage(named: AssetName.moreIcon.rawValue)
            let moreButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleMore))
            navigationItem.rightBarButtonItem = moreButton
            
            setupFollowButton()
        }
        
    }
    
    private func setupFollowButton() {
        
        profileView.addSubview(followButton)
        
        _ = followButton.anchor(nil, left: nil, bottom: userImageView.bottomAnchor, right: userImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
    }
    
    private func setupProfileView() {
        
        view.addSubview(profileView)
        _ = profileView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: profileViewHeight)
        
        profileView.addSubview(userImageView)
        
        _ = userImageView.anchor(profileView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        profileView.addSubview(usernameLabel)
        _ = usernameLabel.anchor(userImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: GAP20)
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        profileView.addSubview(userTagLabel)
        _ = userTagLabel.anchor(usernameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: GAP20)
        userTagLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        profileView.addSubview(bioLabel)
        _ = bioLabel.anchor(userTagLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: GAP50)
        bioLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        _ = menuBar.anchor(profileView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
//        view.addSubview(segmentControl)
//        _ = segmentControl.anchor(profileView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        _ = collectionView.anchor(menuBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: postCellId)
        collectionView.register(ProfileFollowerCell.self, forCellWithReuseIdentifier: userFollowersCellId)
        collectionView.register(ProfileFollowingCell.self, forCellWithReuseIdentifier: userFollowingsCellId)
    }
}





















