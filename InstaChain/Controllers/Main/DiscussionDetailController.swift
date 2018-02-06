//
//  DiscussionDetailController.swift
//  InstaChain
//
//  Created by John Nik on 2/4/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class DiscussionDetailController: UIViewController {
    
    let cellId = "cellId"
    
    //MARK set backgroud Ui when postImageView shows
    
    var startingFrame: CGRect?
    
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    var discussion: DiscussionsData? {
        
        didSet {
            
            guard let discussion = discussion else { return }
            self.discussionDetail(author: discussion.author, permalink: discussion.permlink)
        }
        
    }
    var discussions = [DetailDiscussionData]()
    let data = CurrentSession.getI().localData.userBaseInfo
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        return cv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
}

extension DiscussionDetailController {
    
    //server call to get discussion
    func discussionDetail(author: String, permalink: String) {
        
        SVProgressHUD.show()
        
        AppServerRequests.getDetailDiscussion(author: author, permlink: permalink, authorImage: true){
            [weak self] (r) in
            
            SVProgressHUD.dismiss()
            
            guard let strongSelf = self else { return }
            switch r {
            case .success (let d):
                if let data = d as? DetailDiscussionData {
                    strongSelf.discussions = [data]
                    
                    DispatchQueue.main.async {
                        strongSelf.collectionView.reloadData()
                    }
                    
                }
                break
            default:
                break
                
            }
        }
    }
}

extension DiscussionDetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.discussions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewDiscussionPostCell
        cell.discussionDetailData = discussions[indexPath.item]
        cell.discussionDetailController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: GAP50 * 9)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

//MARK: handle comment
extension DiscussionDetailController {
    
    func handleGoingCommentController(discussion: DetailDiscussionData) {
        
        guard let author = discussion.author, let permlink = discussion.permlink else { return }
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.author = author
        commentsController.permlink = permlink
        navigationController?.pushViewController(commentsController, animated: true)
    }
}

//MARK: - handle postImage
extension DiscussionDetailController {
    
    
    
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


extension DiscussionDetailController {
    
    @objc fileprivate func dismissController() {
        navigationController?.popViewController(animated: true)
    }
}

extension DiscussionDetailController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        setupNavBar()
        setupCollectionView()
    }
    
    private func setupNavBar() {
        let image = UIImage(named: AssetName.leftArrow.rawValue)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(dismissController))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupCollectionView() {
        
        collectionView.register(NewDiscussionPostCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(collectionView)
        _ = collectionView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
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
        
        navigationItem.title = ""
    }
    
}

