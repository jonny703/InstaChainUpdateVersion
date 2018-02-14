//
//  SideController.swift
//  InstaChain
//
//  Created by John Nik on 2/4/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SideMenuController
import CLImageEditor
import ImagePicker
import SVProgressHUD
import ObjectMapper
import Cloudinary

class SideController: UIViewController {
    
    let cellId = "cellId"
    var image: UIImage?
    
    var user = CurrentSession.getI().localData.userBaseInfo
    var userData: [UserInfoData?] = [UserInfoData()]
    
    let titles = [[AssetName.nearMe.rawValue, "Home"],
                  [AssetName.myProfile.rawValue, "Profile"],
                  [AssetName.profileSettings.rawValue, "Setting"],
                  ["", ""],
                  [AssetName.plusPro.rawValue, "Privacy Policy"],
                  [AssetName.about.rawValue, "Terms of Service"],
                  ["", ""],
                  [AssetName.logout.rawValue, "Logout"]]
    
    lazy var photoCameraButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.shottingIcon.rawValue)
        button.setImage(image, for: .normal)
        button.tintColor = DarkModeManager.getPhotoCameraTintColor()
        button.addTarget(self, action: #selector(handleProfileImageView), for: .touchUpInside)
        return button
    }()
    
    let backgroundImageView: UIImageView = {
        let backgroundImage = UIImage(named: AssetName.sideBackground.rawValue)?.withRenderingMode(.alwaysOriginal)
        let backgooundImageView = UIImageView(image: backgroundImage)
        backgooundImageView.contentMode = .scaleAspectFill
        backgooundImageView.alpha = DarkModeManager.getSideMenuBackgroundAlpha()
        return backgooundImageView
    }()
    
    let profileImageView: UIImageView = {
        let profileImageView = UIImageView(frame: CGRect(x: 55, y: 25, width: 80, height: 80))
        profileImageView.image = UIImage(named: AssetName.profilePlaceHoder.rawValue)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = DarkModeManager.getProfileImageBorderColor().cgColor
        return profileImageView
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .reloadSideMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetBackground), name: .resetSideMenuBackground, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .reloadSideMenu, object: nil)
        NotificationCenter.default.removeObserver(self, name: .resetSideMenuBackground, object: nil)
    }
    
    @objc func reloadTableView() {
        user = CurrentSession.getI().localData.userBaseInfo
        tableView.reloadData()
    }
    
    
}

extension SideController: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        
        for image in images{
            self.image = image
            
        }
        dismiss(animated: false, completion: nil)
        self.profileImageView.image = self.image
        
        guard let name = self.user?.name else { return }
        self.getUserInfo(name: name)
        
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}

extension SideController {
    
    @objc fileprivate func handleProfileImageView() {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        
        
        let imagePicker = ImagePickerController()
        imagePicker.imageLimit = 1
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func checkPrivateKeyType() -> Bool {
        
        guard let privateKeyType = UserDefaults.standard.getPrivateKeyType() else { return false }
        
        if privateKeyType == PrivateKeyType.owner.rawValue || privateKeyType == PrivateKeyType.active.rawValue {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func getPrivateKey() -> String? {
        guard let privateKeyType = UserDefaults.standard.getPrivateKeyType() else { return nil }
        if privateKeyType == PrivateKeyType.owner.rawValue {
            guard let key = CurrentSession.getI().localData.privWif?.owner else { return nil }
            return key
        } else {
            guard let key = CurrentSession.getI().localData.privWif?.active else { return nil }
            return key
        }
        
    }
    
    fileprivate func getUserInfo(name: String) {
        
        AppServerRequests.fetchUserBaseInformation(username: name){
            [weak self] (r) in
            
            guard let strongSelf = self else {
                return }
            switch r {
            case .success (let d):
                if let data = d as? Array<UserInfoData> {
                    strongSelf.userData.removeAll()
                    strongSelf.userData = data
                    
                    guard let image = self?.image else { return }
                    strongSelf.uploadImageToServer(data: UIImageJPEGRepresentation(image, 0.2)!, name: name)
                    
                }
                break
            default:
                break
                
            }
        }
    }
    
    //upload image to server
    
    func uploadImageToServer(data: Data, name: String) {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        guard checkPrivateKeyType() else {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.invalidPermission.rawValue)
            return
        }
        
        guard let privateKey = self.getPrivateKey() else {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.invalidPermission.rawValue)
            return
        }
        
        let cloudinary = Constants.cloudinary
        cloudinary.cachePolicy = .none
        let param = CLDUploadRequestParams().setPublicId(String.random()).setTags("This is tag").setInvalidate(true)
        
        
        // cloudinary.createUploader().upload(data: data, uploadPreset: "String", params: param)
        cloudinary.createUploader().signedUpload(data: data, params: param, progress: {(progress) in
            print(progress.fractionCompleted)
        }, completionHandler: {(result, error) in
            print(result?.url)
            print(CurrentSession.getI().localData.pubWif?.memo)
            self.userData[0]?.jsonMetadata?.profile?.profileImage = result?.url
            if let userInfoMetaData = self.userData[0]?.jsonMetadata, let memoKey = CurrentSession.getI().localData.pubWif?.memo, let name = self.user?.name {
                self.editImage(name: name, wif: privateKey, memoKey: memoKey, jsonMetaData: userInfoMetaData)
            }
            
            
        })
        
    }
    
    //upload image url
    
    func editImage (name: String, wif: String, memoKey: String, jsonMetaData: UserInfoJsonMetaData) {
        
        
        let headers = ["content-type": "application/json",]
        let parameters = [
            "account": name,
            "owner": nil,
            "active": nil,
            "posting": nil,
            "memo_key": memoKey,
            "json_metadata": jsonMetaData.toJSON(),
            "wif": wif] as [String : Any?]
        print(parameters)
        print(jsonMetaData.toJSON())
        
        do {
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: ServerUrls.editProfile)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if (error != nil) {
                    print(error!)
                } else {
                    
                    _ = response as? HTTPURLResponse
                    let responseString = String(data: data!, encoding: .utf8)
                    let key = Mapper<ProfileUpdateResponseData>().map(JSONString: responseString!)
                    CurrentSession.getI().localData.userBaseInfo?.jsonMetadata?.profile?.profileImage = jsonMetaData.profile?.profileImage
                    CurrentSession.getI().localData.userBaseInfo?.jsonMetadata?.profile?.name = jsonMetaData.profile?.name
                    CurrentSession.getI().localData.userBaseInfo?.jsonMetadata?.profile?.location = jsonMetaData.profile?.location
                    CurrentSession.getI().localData.userBaseInfo?.jsonMetadata?.profile?.about = jsonMetaData.profile?.about
                    CurrentSession.getI().saveData()
                    
                }
            })
            
            dataTask.resume()
        }
        catch {
            
        }
    }
}

extension SideController {
    
    @objc fileprivate func resetBackground() {
        backgroundImageView.alpha = DarkModeManager.getSideMenuBackgroundAlpha()
        profileImageView.layer.borderColor = DarkModeManager.getProfileImageBorderColor().cgColor
    }
}

extension SideController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        
        let title = titles[indexPath.row][1]
        cell.imageView?.image = UIImage(named: titles[indexPath.row][0])
        cell.textLabel?.text = title
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var navController: UINavigationController?
        
        if indexPath.row == 0 {
            let homeController = HomeController()
            navController = UINavigationController(rootViewController: homeController)
        } else if indexPath.row == 1 {
            let profileController = ProfileController()
            profileController.navigationItem.title = titles[indexPath.row][1]
            navController = UINavigationController(rootViewController: profileController)
            
        } else if indexPath.row == 2 {
            let settingController = SettingController()
            settingController.navigationItem.title = titles[indexPath.row][1]
            navController = UINavigationController(rootViewController: settingController)
        } else if indexPath.row == 7 {
            
            self.handleLogOff()
            return
        } else if indexPath.row == 6 {
            return
        } else if indexPath.row == 4 {
            
            let privacyController = AgreementController()
            privacyController.urlString = PRIVACY_URL_STRING
            privacyController.navigationItem.title = titles[indexPath.row][1]
            navController = UINavigationController(rootViewController: privacyController)
        } else if indexPath.row == 5 {
            let tosController = AgreementController()
            tosController.urlString = TOS_URL_STRING
            tosController.navigationItem.title = titles[indexPath.row][1]
            navController = UINavigationController(rootViewController: tosController)
        } else {
            let randomController = UIViewController()
            randomController.view.backgroundColor = DarkModeManager.getViewBackgroundColor()
            randomController.navigationItem.title = titles[indexPath.row][1]
            navController = UINavigationController(rootViewController: randomController)
            //            navController?.navigationBar.barTintColor = StyleGuideManager.realyfeDefaultGreenColor
        }
        
        guard let embedController = navController else { return }
        
        sideMenuController?.embed(centerViewController: embedController)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: SIDE_MENU_WIDTH, height: 170))
        containerView.backgroundColor = .clear
        
        
        
        if let imageUrlString = user?.jsonMetadata?.profile?.profileImage, let imageUrl = URL(string: imageUrlString) {
            profileImageView.sd_setIndicatorStyle(.gray)
            profileImageView.sd_addActivityIndicator()
            profileImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        
        
        containerView.addSubview(profileImageView)
        
        containerView.addSubview(photoCameraButton)
        
        _ = photoCameraButton.anchor(nil, left: nil, bottom: profileImageView.bottomAnchor, right: profileImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        let usernamelabel = UILabel(frame: CGRect(x: 0, y: 115, width: 190, height: 20))
        usernamelabel.font = UIFont.systemFont(ofSize: 20)
        usernamelabel.textColor = .white
        usernamelabel.textAlignment = .center
        
        containerView.addSubview(usernamelabel)
        usernamelabel.text = user?.jsonMetadata?.profile?.name
        
        
        
        let usertaglabel = UILabel(frame: CGRect(x: 0, y: 145, width: 190, height: 20))
        usertaglabel.font = UIFont.systemFont(ofSize: 20)
        usertaglabel.textColor = .white
        usertaglabel.textAlignment = .center
        
        containerView.addSubview(usertaglabel)
        usertaglabel.text = "@" + (user?.name ?? "")
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3 || indexPath.row == 6 {
            return 20
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
}

//MARK: fetch user profile

//MARK: handle logout
extension SideController {
    @objc fileprivate func handleLogOff() {
        self.showJHTAlertDefaultWithIcon(message: "Are you sure you want to Log out?", firstActionTitle: "No", secondActionTitle: "Yes") { (action) in
            
            UserDefaults.standard.setIsLoggedIn(value: false)
            
            let homeController = HomeController()
            let navController = UINavigationController(rootViewController: homeController)
            self.sideMenuController?.embed(centerViewController: navController)
        }
    }
}

//MARK: setup Views
extension SideController {
    
    fileprivate func setupViews() {
        setupBackground()
        setupTableView()
    }
    
    private func setupBackground() {
        
        
        view.addSubview(backgroundImageView)
        _ = backgroundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    
    
    private func setupTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        _ = tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}

