//
//  SideController.swift
//  InstaChain
//
//  Created by John Nik on 2/4/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SideMenuController

class SideController: UIViewController {
    
    let cellId = "cellId"
    
    var user = CurrentSession.getI().localData.userBaseInfo
    
    let titles = [[AssetName.nearMe.rawValue, "Home"],
                  [AssetName.myProfile.rawValue, "Profile"],
                  [AssetName.profileSettings.rawValue, "Setting"],
                  ["", ""],
                  [AssetName.plusPro.rawValue, "Privacy Policy"],
                  [AssetName.about.rawValue, "Terms of Service"],
                  ["", ""],
                  [AssetName.logout.rawValue, "Logout"]]
    
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
        tableView.reloadData()
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
