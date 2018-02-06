//
//  FollowerPostCell.swift
//  InstaChain
//
//  Created by John Nik on 1/31/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ProfilePostCell: BaseCollectionViewCell {
    
    let cellId = "cellId"
    var profileController: ProfileController?
    
    var userName: String? {
        didSet {
            guard let userName = userName else { return }
            self.getImages(tag: userName, limit: "99", imageOnly: "true")
        }
    }
    
    var postedImagesArray = [PostedImageData]()
    
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
        
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        
    }
}

extension ProfilePostCell {
    
    func getImages(tag: String, limit: String, imageOnly: String) {
        
        AppServerRequests.fetchPostedImage(tag: tag, limit: limit, imageOnly: imageOnly){
            [weak self] (r) in
            
            guard let strongSelf = self else { return }
            switch r {
            case .success (let d):
                if let data = d as? Array<PostedImageData> {
                    strongSelf.postedImagesArray = data
                    
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

extension ProfilePostCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postedImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
        
        cell.imageUrlString = postedImagesArray[indexPath.item].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return 0
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let width = frame.width / 3
            return CGSize(width: width, height: width)
        }
        let width = (frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let postedImageData = postedImagesArray[indexPath.item]
        profileController?.handleGoingDiscussionDetailController(postedImageData: postedImageData)
    }
    
}

extension ProfilePostCell: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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
