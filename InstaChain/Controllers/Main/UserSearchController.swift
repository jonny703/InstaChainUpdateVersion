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
import ObjectMapper

class UserSearchController: UIViewController {
    
    let cellId = "cellId"
    
    var sendRepliesCount = 0
    var recievedRepliesCount = 0
    
    var lookupUsers = [LookupUser]()
    
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
    
    private func dismissHud() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    fileprivate func getLookupAccounts(name: String) {
        
        guard ReachabilityManager.shared.internetIsUp else { return }
        
        SVProgressHUD.show()
        
        guard let urlString = String(format: ServerUrls.getLookupAccounts, name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                
                self.dismissHud()
                
                print("fetchAircraftError: ", error.localizedDescription)
                return
            }
            self.dismissHud()
            guard let data = data else { return }
            
            guard var nameArray = self.getArrayFrom(data: data) else { return }
            
            nameArray = nameArray.filter { $0.contains(name)}
            
            self.lookupUsers.removeAll()
            
            for name in nameArray {
                
                self.sendRepliesCount += 1
                self.getUserInfo(name: name)
                
            }
            
            }.resume()
    }
    
    private func getArrayFrom(data: Data) -> [String]? {
        guard let dataString = String(data: data, encoding: .utf8) else { return nil }
        
        let responseStr = String(describing: dataString.filter { !"[]\"".contains($0) })
        let array = responseStr.components(separatedBy: ",")
        return array
    }
    
    fileprivate func getUserInfo(name: String) {
        self.recievedRepliesCount += 1
        AppServerRequests.fetchUserBaseInformation(username: name){
            [weak self] (r) in
            guard let strongSelf = self else {
                SVProgressHUD.dismiss()
                return }
            
            switch r {
            case .success (let d):
                if let data = d as? Array<UserInfoData> {
                    
                    if data.count > 0 {
                        let user = LookupUser(name: name, userInfoData: data[0])
                        strongSelf.lookupUsers.append(user)
                    }
                    
                    if strongSelf.sendRepliesCount == strongSelf.recievedRepliesCount {
                        strongSelf.sendRepliesCount = 0
                        strongSelf.recievedRepliesCount = 0
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            strongSelf.collectionView.reloadData()
                        }
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
        return lookupUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchUserCell
        
        cell.user = lookupUsers[indexPath.item].userInfoData
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let user = lookupUsers[indexPath.item].userInfoData
        
        let profileController = ProfileController()
        profileController.profileName = user.name
        if CurrentSession.getI().localData.userBaseInfo?.name != user.name {
            profileController.isLookOtherProfile = true
        } else {
            return
        }
        
        self.handleSendPrivateMessage(toName: user.name)
        
//        let image = UIImage(named: AssetName.leftArrow.rawValue)
//        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(profileController.dismissController))
//        profileController.navigationItem.leftBarButtonItem = backButton
//        profileController.navigationItem.title = "Profile"
//        navigationController?.pushViewController(profileController, animated: true)
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

extension UserSearchController {
    
    fileprivate func handleGetPrivateMessageHistory() {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.getPrivateKeyType() != PrivateKeyType.owner.rawValue {
            self.showJHTAlerttOkayWithIcon(message: "Sorry, you have no permission to send a private message")
            return
        }
        
        guard let memoKey = userDefaults.getPrivateMemoKey() else { return }
        
        //get privte message histroy
    }
    
    fileprivate func handleSendPrivateMessage(toName: String) {
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.getPrivateKeyType() != PrivateKeyType.owner.rawValue {
            self.showJHTAlerttOkayWithIcon(message: "Sorry, you have no permission to send a private message")
            return
        }
        
        guard let memoKey = userDefaults.getPrivateMemoKey() else { return }
        guard let mainKey = userDefaults.getPrivateMainKey() else { return }
        guard let fromName = CurrentSession.getI().localData.userBaseInfo?.name else { return }
        
        let privateMessage = PrivateMessage(from: fromName, to: toName, amount: PRIVATE_MESSAGE_AMOUNT, memo: "hello", priv_memo_wif: memoKey, wif: mainKey)
        
        guard let urlStr = ServerUrls.sendPrivateMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(privateMessage)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.showJHTAlerttOkayWithIcon(message: "Success!")
                    }
                }
            } else {
                
            }
            
            if let error = error {
                print("Error for update profile: ", error.localizedDescription)
                return
            }
            
        }
        task.resume()
    }
    
}

extension UserSearchController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if (searchBar.text?.isEmpty)! { return }
        
        searchBar.resignFirstResponder()
        
        guard let searchName = searchBar.text else { return }
        
        //        self.getUserInfo(name: searchName)
        self.getLookupAccounts(name: searchName)
        
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
