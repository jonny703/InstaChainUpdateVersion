//
//  HomeController.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SideMenuController
import DZNEmptyDataSet
import SVProgressHUD
import CLImageEditor
import ImagePicker
import KRPullLoader

class HomeController: UIViewController {
    
    let cellId = "cellId"
    
    var discussions = [DiscussionsData]()
    let data = CurrentSession.getI().localData.userBaseInfo
    
    //MARK set backgroud Ui when postImageView shows
    
    var startingFrame: CGRect?
    
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    let segmentControl: UISegmentedControl = {
        
        let segement = UISegmentedControl(items: ["New", "Trend", "Hot"])
        segement.tintColor = StyleGuideManager.realyfeDefaultGreenColor
        segement.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        segement.selectedSegmentIndex = 0
        segement.addTarget(self, action: #selector(handleSegmentControl), for: .valueChanged)
        return segement
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.emptyDataSetSource = self
        cv.emptyDataSetDelegate = self
        return cv
        
    }()
    
    lazy var shottingButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.shottingIcon.rawValue)
        button.tintColor = .white
        button.backgroundColor = StyleGuideManager.realyfeDefaultGreenColor
        button.layer.cornerRadius = 50 / 2
        button.layer.masksToBounds = true
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleShotting), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupViews()
        
        if isLoggedIn() {
            if CurrentSession.getI().localData.userBaseInfo?.name != "" {
                print("logged in")
            }
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
            
            return
        }
        
        
        fetchHomeFeed()
        
        let title = "test test"
        let randomTitle = title.split(separator: " ").joined(separator: "-").lowercased()
        print("randomTitle", randomTitle)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    fileprivate func isLoggedIn() -> Bool {
        
        return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showLoginController() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: {
        })
        
        
    }
}

extension HomeController {
    
    func fetchFeed(withTag tag: String) {
        
    }
}

extension HomeController {
    
    func handleGoingProfileController(discussion: DiscussionsData) {
        
        let profileController = ProfileController()
        profileController.profileName = discussion.author
        if CurrentSession.getI().localData.userBaseInfo?.name != discussion.author {
            profileController.isLookOtherProfile = true
        } else {
            return
        }
        profileController.navigationItem.title = "Profile"
        navigationController?.pushViewController(profileController, animated: true)
    }
}

//MARK: handle comment
extension HomeController {
    
    func handleGoingCommentController(discussion: DiscussionsData) {
        
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.author = discussion.author
        commentsController.permlink = discussion.permlink
        navigationController?.pushViewController(commentsController, animated: true)
    }
}

//MARK: handleShotting
extension HomeController {
    
    fileprivate func checkPrivateKeyType() -> Bool {
        
        guard let privateKeyType = UserDefaults.standard.getPrivateKeyType() else { return false }
        
        if privateKeyType == PrivateKeyType.memo.rawValue {
            return false
        } else {
            return true
        }
    }
    
    @objc fileprivate func handleShotting() {
        
        guard checkPrivateKeyType() else {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.invalidPermission.rawValue)
            return
        }
        
        
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageLimit = 1
        present(imagePicker, animated: true, completion: nil)
    }
    
}

//MARK: handle krpullloader delegate
extension HomeController: KRPullLoadViewDelegate {
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        
        if type == .loadMore {
            switch state {
                
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                    
                }
                
            default:
                break
            }
            
            return
        }
        
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case let .pulling(offset, threshould):
            if offset.y > threshould {
                pullLoadView.messageLabel.text = ""
            } else {
                pullLoadView.messageLabel.text = ""
            }
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = "Updating..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
                self.fetchHomeFeed()
            }
        }
        
    }
}

extension HomeController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        var selectImage: UIImage = UIImage()
        for image in images{
            selectImage = image
            //print(self.uploadImageToServer(data: self.convertImageToBase64(image: image)))
        }
        dismiss(animated: true, completion: nil)
        self.presentImageEditor(with: selectImage)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // Edit the selected image
    func presentImageEditor(with image: UIImage) {
        let editor = CLImageEditor(image: image)
        editor?.delegate = self
        present(editor! , animated: false) {() -> Void in }
    }
    
    
}

extension HomeController: CLImageEditorDelegate{
    
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        
        dismiss(animated: true) {
            let newDiscussionConroller = NewDiscussionController()
            newDiscussionConroller.postImage = image
            newDiscussionConroller.homeController = self
            let navConroller = UINavigationController(rootViewController: newDiscussionConroller)
            self.present(navConroller, animated: true, completion: nil)
        }
    }
    
}

extension HomeController {
    
    @objc func fetchHomeFeed() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        self.getFeeds(following: data?.name ?? "" , limit: "99" , imageOnly: true, includeBody: true, postType: PostType.new)
    }
}

extension HomeController {
    @objc fileprivate func handleSegmentControl(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        
        if index == 0 {
            self.getFeeds(following: data?.name ?? "" , limit: "99" , imageOnly: true, includeBody: true, postType: PostType.new)
        } else if index == 1 {
            self.getFeeds(following: data?.name ?? "" , limit: "99" , imageOnly: true, includeBody: true, postType: PostType.trend)
        } else {
            self.getFeeds(following: data?.name ?? "" , limit: "99" , imageOnly: true, includeBody: true, postType: PostType.hot)
        }
        
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.discussions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.discussionData = discussions[indexPath.item]
        cell.homeController = self
        cell.index = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: GAP50 * 9)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// fetch feed
extension HomeController {
    
    
    func getFeeds(following: String, limit: String, imageOnly: Bool, includeBody: Bool,postType: PostType) {
        
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        
        AppServerRequests.getDiscussionByHot( limit: limit, imageOnly: imageOnly, includeBody: includeBody, postType: postType){
            [weak self] (r) in
            
            
            
            guard let strongSelf = self else {
                SVProgressHUD.dismiss()
                return }
            switch r {
            case .success (let d):
                if let data = d as? [DiscussionsData] {
                    strongSelf.discussions.removeAll()
                    strongSelf.discussions.append(contentsOf: data)
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        strongSelf.collectionView.reloadData()
                    }
                }
                break
            default:
                SVProgressHUD.dismiss()
                break
                
            }
        }
    }
}

//MARK: -- DZNEmpty delegate Methods
extension HomeController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let img = DarkModeManager.getEmptyPostImage()
        
        return img
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let txt = "No posts right now."
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor : DarkModeManager.getDefaultTextColor()]
        let str_attr = NSAttributedString(string: txt, attributes: attributes)
        return str_attr
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let txt = "Follow users and you can see their posts here"
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor : DarkModeManager.getDefaultTextColor()]
        let str_attr = NSAttributedString(string: txt, attributes: attributes)
        return str_attr
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

//MARK: - handle postImage
extension HomeController {
    
    
    
    //my custom zooming logic
    
    func performZoomingForStartingImageView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        let imageSize = startingImageView.image?.size
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                //math?
                //h2 / w2 = h1 / w1
                // h2 = h1 / w1 * w2
                self.blackBackgroundView?.alpha = 1
                let height = (imageSize?.height)! / (imageSize?.width)! * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                
                //                zoomOutImageView.removeFromSuperview()
                
            })
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        
        if let zoomOutImageView = tapGesture.view {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                
            }, completion: { (completed) in
                
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                
            })
        }
    }
}


extension HomeController {
    
    @objc fileprivate func handleSearch() {
        
        let userSearchController = UserSearchController()
        navigationController?.pushViewController(userSearchController, animated: true)
    }
}

extension HomeController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupSegmentControl()
        setupCollectionView()
        setupShottingButton()
    }
    
    private func setupNavBar() {
        
        let searchImage = UIImage(named: AssetName.searhcIcon.rawValue)
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    private func setupShottingButton() {
        
        view.addSubview(shottingButton)
        
        _ = shottingButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 30, widthConstant: 50, heightConstant: 50)
    }
    
    private func setupCollectionView() {
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(collectionView)
        _ = collectionView.anchor(segmentControl.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let refreshView = KRPullLoadView()
        refreshView.delegate = self
        collectionView.addPullLoadableView(refreshView)
    }
    
    private func setupSegmentControl() {
        
        view.addSubview(segmentControl)
        _ = segmentControl.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 3, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }
    
    fileprivate func setupStatusBar() {
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = StyleGuideManager.realyfeDefaultGreenColor
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(statusBarBackgroundView)
            window.addConnstraintsWith(Format: "H:|[v0]|", views: statusBarBackgroundView)
            window.addConnstraintsWith(Format: "V:|[v0(20)]", views: statusBarBackgroundView)
        }
    }
    
    private func setupBackground() {
        view.backgroundColor = DarkModeManager.getViewBackgroundColor()
        
        navigationItem.title = "Home"
    }
    
}

