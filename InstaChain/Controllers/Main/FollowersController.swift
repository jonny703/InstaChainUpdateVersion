//
//  FollowersController.swift
//  InstaChain
//
//  Created by John Nik on 2/4/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SVProgressHUD
import DZNEmptyDataSet

class FollowersController: UITableViewController {
    
    let cellId = "cellId"
    
    var followers = [FollowersData]()
    var following = [FollowersData]()
    
    let data = CurrentSession.getI().localData.userBaseInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchUsers()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FollowerUserCell
        
        cell.follower = followers[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GAP90
    }
}

//MARK: -- DZNEmpty delegate Methods
extension FollowersController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let img = UIImage(named: AssetName.emptyPost.rawValue)
        
        return img
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let txt = "No posts right now."
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor : UIColor.black]
        let str_attr = NSAttributedString(string: txt, attributes: attributes)
        return str_attr
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let txt = "Follow users and you can see their posts here"
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor : UIColor.black]
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

//Mark: fetch users
extension FollowersController {
    
    func fetchUsers() {
        self.fetchUserFollowers(follower: data?.name ?? "", limit: "30", followType: "blog", url: ServerUrls.followers)
        self.fetchUserFollowers(follower: data?.name ?? "", limit: "30", followType: "blog", url: ServerUrls.following)
    }
    
    //to get users followers
    func fetchUserFollowers(follower: String, limit: String, followType: String, url: String) {
        
        SVProgressHUD.show()
        
        AppServerRequests.getFollowers(follower: follower, followType: followType, limit: limit, url: url){
            [weak self] (r) in
            
            SVProgressHUD.dismiss()
            
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
                        strongSelf.tableView.reloadData()
                    }
                    
                }
                break
            default:
                break
                
            }
        }
    }
}

extension FollowersController {
    
    fileprivate func setupViews() {
    
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(FollowerUserCell.self, forCellReuseIdentifier: cellId)
    }
    
}
