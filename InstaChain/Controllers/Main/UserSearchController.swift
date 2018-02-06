//
//  UserSearchController.swift
//  InstaChain
//
//  Created by John Nik on 2/3/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SVProgressHUD
import DZNEmptyDataSet

class UserSearchController: UIViewController {
    
    let cellId = "cellId"
    
    var filteredUsers = [UserInfoData]()
    var users = [UserInfoData]()

    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter a username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        sb.keyboardAppearance = DarkModeManager.getKeyboardApperance()
        return sb
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.emptyDataSetSource = self
        cv.emptyDataSetDelegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
}

//MARK: -- DZNEmpty delegate Methods
extension UserSearchController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let img = DarkModeManager.getEmptyUsersImage()
        
        return img
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let txt = "No searched users right now."
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor : DarkModeManager.getDefaultTextColor()]
        let str_attr = NSAttributedString(string: txt, attributes: attributes)
        return str_attr
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let txt = ""
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

extension UserSearchController {
    
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
                    strongSelf.users.removeAll()
                    strongSelf.users = data
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        if strongSelf.users.count > 0 {
                            strongSelf.collectionView.reloadData()
                        } else {
                            strongSelf.showJHTAlerttOkayWithIcon(message: "No users\nTry to search other name")
                        }
                    }
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
            
            SVProgressHUD.dismiss()
            
            guard let strongSelf = self else { return }
            switch r {
            case .success (let d):
                if let data = d as? FollowersFollowingData {
                    strongSelf.users[0].followerCount = data.followerCount
                    strongSelf.users[0].followingCount = data.followingCount
                    
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

extension UserSearchController: UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchUserCell
        
        cell.user = users[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let user = users[indexPath.item]
        
        let profileController = ProfileController()
        profileController.profileName = user.name
        if CurrentSession.getI().localData.userBaseInfo?.name != user.name {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: GAP90)
    }
}

extension UserSearchController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        if searchText.isEmpty {
//            filteredUsers = users
//        } else {
//            filteredUsers = users.filter { (user) -> Bool in
//                return user.username.lowercased().contains(searchText.lowercased())
//            }
//        }
        
//        collectionView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if (searchBar.text?.isEmpty)! { return }
        
        searchBar.resignFirstResponder()
        
        guard let searchName = searchBar.text else { return }
        
        self.getUserInfo(name: searchName)
        
    }
}

extension UserSearchController {
    
    @objc fileprivate func dismissController() {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
}


extension UserSearchController {
    
    fileprivate func setupViews() {
        
        view.backgroundColor = DarkModeManager.getViewBackgroundColor()
        
        setupCollectionView()
        setupNavBar()
    }
    
    private func setupCollectionView() {
        collectionView.register(SearchUserCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        view.addSubview(collectionView)
        
        _ = collectionView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    private func setupNavBar() {
        
        navigationController?.navigationBar.addSubview(searchBar)
        
        let navBar = navigationController?.navigationBar
        
        _ = searchBar.anchor(navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, topConstant: 0, leftConstant: 50, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
        
        let image = UIImage(named: AssetName.leftArrow.rawValue)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(dismissController))
        navigationItem.leftBarButtonItem = backButton
    }
}
