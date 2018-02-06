//
//  ProfileFollowingCell.swift
//  InstaChain
//
//  Created by John Nik on 2/2/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

class ProfileFollowingCell: ProfileFollowerCell {
    
    override func fetchUsers() {
        guard let userName = userName else { return }
        self.fetchUserFollowers(follower: userName, limit: "30", followType: "blog", url: ServerUrls.following)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return following.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FollowersUserCell
        cell.followType = .following
        cell.follower = following[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let username = following[indexPath.row].following else { return }
        
        profileController?.handleGoingOtherProfileController(withUsername: username)
    }
    
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let txt = "No followings right now."
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor : UIColor.black]
        let str_attr = NSAttributedString(string: txt, attributes: attributes)
        return str_attr
    }
    
    override func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let txt = "If someone follows you, he appears here"
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor : UIColor.black]
        let str_attr = NSAttributedString(string: txt, attributes: attributes)
        return str_attr
    }
}
