//
//  ProfileFollowerCell.swift
//  InstaChain
//
//  Created by John Nik on 2/2/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProfileFollowerCell: BaseCollectionViewCell {
    
    var profileController: ProfileController?
    
    let cellId = "cellId"
    
    var userName: String? {
        
        didSet {
            self.fetchUsers()
        }
    }
    
    var followers = [FollowersData]()
    var following = [FollowersData]()
    
    let data = CurrentSession.getI().localData.userBaseInfo
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = DarkModeManager.getCollectionViewBackgroundColor()
        cv.dataSource = self
        cv.delegate = self
        cv.emptyDataSetSource = self
        cv.emptyDataSetDelegate = self
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(collectionView)
        _ = collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(FollowersUserCell.self, forCellWithReuseIdentifier: cellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUsers), name: .refetchFollowersWhenFollow, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .refetchFollowersWhenFollow, object: nil)
    }
    
    @objc func fetchUsers() {
        
        guard let userName = userName else { return }
        
        self.fetchUserFollowers(follower: userName, limit: "30", followType: "blog", url: ServerUrls.followers)
        
    }
}

extension ProfileFollowerCell {
    
    
    //to get users followers
    func fetchUserFollowers(follower: String, limit: String, followType: String, url: String) {
        
        AppServerRequests.getFollowers(follower: follower, followType: followType, limit: limit, url: url){
            [weak self] (r) in
            
            guard let strongSelf = self else { return }
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

extension ProfileFollowerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FollowersUserCell
        cell.followType = .follower
        cell.follower = followers[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width, height: GAP90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let username = followers[indexPath.row].follower else { return }
        
        profileController?.handleGoingOtherProfileController(withUsername: username)
    }
    
}

//MARK: -- DZNEmpty delegate Methods
extension ProfileFollowerCell: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let img = DarkModeManager.getEmptyUsersImage()
        
        return img
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let txt = "No followers right now."
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor : DarkModeManager.getDefaultTextColor()]
        let str_attr = NSAttributedString(string: txt, attributes: attributes)
        return str_attr
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let txt = "Follow users and you can see their posts on dashboard"
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
