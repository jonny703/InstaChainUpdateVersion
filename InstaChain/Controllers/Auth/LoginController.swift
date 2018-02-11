//
//  LoginController.swift
//  Shades
//
//  Created by John Nik on 11/17/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import JHTAlertController
import SVProgressHUD
import SkyFloatingLabelTextField
import ObjectMapper
import SideMenuController

enum AuthPublicKeyType {
    
    case activeKey
    case ownerKey
    case postingKey
}


class LoginController: UIViewController {
    
    var authPublicKeyType: AuthPublicKeyType = .activeKey
    
    var userInfo: [UserInfoData] = [UserInfoData()]
    var keyData : WifData? = WifData()
    var password: String?
    
    
    var isRemember = false
    
    lazy var usernameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Username"
        textField.keyboardType = .emailAddress
        textField.keyboardAppearance = DarkModeManager.getKeyboardApperance()
        textField.borderColor = DarkModeManager.getLoginPageTintColor()
        textField.textColor = DarkModeManager.getLoginPageTintColor()
        return textField
    }()
    
    lazy var passwordTextField: ToplessTextField = {
        let textField = ToplessTextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.keyboardAppearance = DarkModeManager.getKeyboardApperance()
        textField.borderColor = DarkModeManager.getLoginPageTintColor()
        textField.textColor = DarkModeManager.getLoginPageTintColor()
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(DarkModeManager.getLoginPageTintColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor(white: 0.05, alpha: DarkModeManager.getLoginButtonTitleAlpha())
        button.layer.cornerRadius = 25
        button.layer.borderColor = DarkModeManager.getLoginPageTintColor().cgColor
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var checkBox: VKCheckbox = {
        let box = VKCheckbox()
        box.line = .normal
        box.color = DarkModeManager.getLoginPageTintColor()
        box.borderColor = DarkModeManager.getLoginPageTintColor()
        box.borderWidth = 2
        box.cornerRadius = 0
        box.bgColor = .clear
        box.checkboxValueChangedBlock = {
            isOn in
            self.handleCheckBox(isOn: isOn)
        }
        return box
    }()
    
    let rememberMeLabel: UILabel = {
        let label = UILabel()
        label.text = "Remember Me"
        label.textColor = DarkModeManager.getLoginPageTintColor()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    lazy var qrScanButton: UIButton = {
       
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.qrCode.rawValue)
        button.setImage(image, for: .normal)
        button.tintColor = DarkModeManager.getLoginPageTintColor()
        button.addTarget(self, action: #selector(handleQRScan), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        handleRemembered()
    }
}

extension LoginController {
    
    @objc fileprivate func handleQR() {
        
        print("aaaaaa")
    }
    
    @objc fileprivate func handleQRScan() {
        
        let qrScanController = QRScanController()
        qrScanController.loginController = self
        let navConroller = UINavigationController(rootViewController: qrScanController)
        self.present(navConroller, animated: true, completion: nil)
        
        
    }
    
    func setPasswordByQRScan(password: String) {
        self.passwordTextField.text = password
    }
    
}

extension LoginController {
    
    fileprivate func handleRemembered() {
        
        self.isRemember = isRemembered()
        self.checkBox.setOn(isRemember)
        
        if isRemember {
            
            guard let username = UserDefaults.standard.getUsername() else { return }
            guard let password = UserDefaults.standard.getPassword() else { return }
            
            self.usernameTextField.text = username
            self.passwordTextField.text = password
        }
        
    }
    
}

extension LoginController {
    
    
    fileprivate func getPrivateKey() -> String? {
        
        guard let privateKey = self.password, privateKey.count > 0 else {
            return nil
        }
        
        
        return privateKey
    }
    
    @objc fileprivate func handleShowSignUp() {
    }
    
    @objc fileprivate func handleLogin() {
        
        if !(checkInvalid()) {
            return
        }
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        self.password = password
        self.getUserBaseInfomation(username: username.doTrimming(), password: password.doTrimming())
    }
    
    // 2. > Then get the Basic Information of user < throws error
    @objc func getUserBaseInfomation(username: String, password: String) {
        
        SVProgressHUD.show()
        
        AppServerRequests.fetchUserBaseInformation(username: username.doTrimming()) {
            [weak self] (r) in
            guard let strongSelf = self else {
                SVProgressHUD.dismiss()
                return }
            switch r {
            case .success (let d):
                if let data = d as? [UserInfoData] {
                    strongSelf.userInfo.removeAll()
                    strongSelf.userInfo.append(contentsOf: data)
                    print(strongSelf.userInfo.count)
                }
                if strongSelf.userInfo.count != 0{
                    let localData = CurrentSession.getI().localData
                    localData.userBaseInfo = strongSelf.userInfo[0]
                    localData.pubWif?.active = strongSelf.userInfo[0].active.key[0]
                    localData.pubWif?.owner = strongSelf.userInfo[0].owner.key[0]
                    localData.pubWif?.posting = strongSelf.userInfo[0].posting.key[0]
                    localData.pubWif?.memo = strongSelf.userInfo[0].memoKey
                    CurrentSession.getI().saveData()
                    
//                    let activeKey = strongSelf.userInfo[0].active.key[0]
//                    guard let privateKey = strongSelf.getPrivateKey() else { return }
//                    strongSelf.authenticateUser(pubWif: activeKey, privWif: privateKey, count: 0)
                    strongSelf.handleLoginWith(username: username, password: password)
                    
                }else{
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        strongSelf.showJHTAlerttOkayWithIcon(message: "Enter Correct Username")
                    }
                }
                break
            default:
                SVProgressHUD.dismiss()
                break
                
            }
        }
    }
    
    //3. >get the priv_wif
    
    @objc func getPrivWif(username: String, password: String, count: Int) {
        let role = self.getRoleType(count)
        
        //let data = CurrentSession.getI().localData.userBaseInfo
        
        AppServerRequests.login(userName: username, password: password, role: role, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                SVProgressHUD.dismiss()
                self.showJHTAlerttOkayWithIcon(message: AlertMessages.somethingWrong.rawValue)
                print(error ?? "")
            } else {
                _ = response as? HTTPURLResponse
                let responseString = String(data: data!, encoding: .utf8)
                print(responseString ?? "")
                let key = Mapper<WifKeyData>().map(JSONString: responseString!)
                if let item = key?.result as? Bool{
                    print(item)
                }
                
                if let item = key?.result as? String {
                    print(item)
                    print (self.userInfo[0].active.key[0])
                    print(role.rawValue)
                    self.authenticateUser(pubWif: self.userInfo[0].active.key[0], privWif: item, count: count)
                    
                }
            }
        })
        
    }
    // To get priv wif for role
    func getRoleType(_ fromCount : Int) -> RoleType {
        var role: RoleType!
        switch fromCount {
        case 0:
            role = RoleType.active
            break
        case 1:
            role = RoleType.owner
            break
        default:
            role = RoleType.posting
            break
        }
        return role!
    }
    
    func handleLoginWith(username: String, password: String) {
        let headers = [
            "content-type": "application/json",
            ]
        let parameters = [
            "name": username,
            "password":password,
            ] as [String : Any]
        guard let urlStr = ServerUrls.newLoginUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return
        }
        var request = URLRequest(url: url)
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        SVProgressHUD.show()
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.showErrorMessage(message: AlertMessages.somethingWrong.rawValue)
                print("Error for publish: ", error.localizedDescription)
                return
            }
            guard let data = data else {
                self.showErrorMessage(message: AlertMessages.somethingWrong.rawValue)
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            do {
                
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                print(loginResponse.result ?? "empty")
                print(loginResponse.key_type ?? "empty")
                print(loginResponse.priv_wif ?? "empty")
                
                guard let result = loginResponse.result else {
                    self.showErrorMessage(message: AlertMessages.somethingWrong.rawValue)
                    return }
                
                if result {
                    
                    guard let keyType = loginResponse.key_type else { return }
                    guard let privKey = loginResponse.priv_wif else { return }
                    UserDefaults.standard.setPrivateKeyType(keyType)
                    
                    if keyType == PrivateKeyType.owner.rawValue {
                        CurrentSession.getI().localData.privWif?.owner = privKey
                    } else if keyType == PrivateKeyType.active.rawValue {
                        CurrentSession.getI().localData.privWif?.active = privKey
                    } else if keyType == PrivateKeyType.posting.rawValue {
                        CurrentSession.getI().localData.privWif?.posting = privKey
                    } else if keyType == PrivateKeyType.memo.rawValue {
                        CurrentSession.getI().localData.privWif?.memo = privKey
                    } else {
                        self.showErrorMessage(message: AlertMessages.somethingWrong.rawValue)
                        return
                    }
                    
                    CurrentSession.getI().saveData()
                    
                    self.getFollowfollowersCount(account: username)
                } else {
                    self.showErrorMessage(message: AlertMessages.somethingWrong.rawValue)
                }
                
            } catch let jsonErr {
                print("Error serializing error: ", jsonErr)
                self.showErrorMessage(message: AlertMessages.somethingWrong.rawValue)
                return
            }
        }
        
        dataTask.resume()
        
        
    }
    
    private func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showJHTAlerttOkayWithIcon(message: message)
        }
    }
    
    //4 > authenticate user by
    func authenticateUser(pubWif: String, privWif: String, count: Int) {
        
        
        let headers = [
            "content-type": "application/json",
            ]
        let parameters = [
            "pubWif": pubWif,
            "privWif":privWif,
            ] as [String : Any]
        
        do {
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: ServerUrls.wifValid)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error ?? "")
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.showJHTAlerttOkayWithIcon(message: AlertMessages.somethingWrong.rawValue)
                    }
                } else {
                    _ = response as? HTTPURLResponse
                    let responseString = String(data: data!, encoding: .utf8)
                    print("test login with ", responseString ?? "")
                    let key = Mapper<WifKeyData>().map(JSONString: responseString!)
                    print(key?.result ?? "")
                    if let item = key?.result as? Bool {
                        print(item)
                        if item {
                            
//                            CurrentSession.getI().localData.privWif?.active = privWif
//                            CurrentSession.getI().saveData()
                            
                            DispatchQueue.main.async {
                                self.getFollowfollowersCount(account: self.usernameTextField.text!)
                            }
                            
                            
                        } else {
                            
                            if self.authPublicKeyType == .activeKey {
                                self.authPublicKeyType = .postingKey
                                let postingKey = self.userInfo[0].posting.key[0]
                                guard let privateKey = self.getPrivateKey() else { return }
                                self.authenticateUser(pubWif: postingKey, privWif: privateKey, count: 0)
                                return
                            } else if self.authPublicKeyType == .postingKey {
                                self.authPublicKeyType = .activeKey
                                let ownerKey = self.userInfo[0].active.key[0]
                                guard let privateKey = self.getPrivateKey() else { return }
                                self.authenticateUser(pubWif: ownerKey, privWif: privateKey, count: 0)
                                return
                            }
                            
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                self.showJHTAlerttOkayWithIcon(message: Constants.wrongPassword)
                            }
                            
                        }
                    } else {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            
                            if responseString?.range(of: "Expected version") != nil {
                                self.showJHTAlerttOkayWithIcon(message: AlertMessages.oldVersion.rawValue)
                            } else {
                                self.showJHTAlerttOkayWithIcon(message: AlertMessages.somethingWrong.rawValue)
                            }
                        }
                    }
                }
            })
            
            dataTask.resume()
        }
        catch {
            
        }
    }
    
    @objc func getFollowfollowersCount(account: String) {
        AppServerRequests.getFollowersCount(account: account) {
            [weak self] (r) in
            
            SVProgressHUD.dismiss()
            
            guard let strongSelf = self else { return }
            switch r {
            case .success (let d):
                if let data = d as? FollowersFollowingData {
                    strongSelf.userInfo[0].followerCount = data.followerCount
                    strongSelf.userInfo[0].followingCount = data.followingCount
                    CurrentSession.getI().saveData()
                    
                    guard let mainController = UIApplication.shared.keyWindow?.rootViewController as? SideMenuController else { return }
                    strongSelf.handleUserdefaultWhenLogin()
                    let homeController = mainController.centerViewController.childViewControllers.first as! HomeController
                    homeController.fetchHomeFeed()
                    
                    self?.dismiss(animated: true, completion: nil)
                }
                break
            default:
                break
                
            }
        }
    }
    
    private func handleUserdefaultWhenLogin() {
        UserDefaults.standard.setIsLoggedIn(value: true)
        UserDefaults.standard.setIsRemembered(value: isRemember)
        
        if isRemember {
            guard let username = self.usernameTextField.text else { return }
            guard let password = self.passwordTextField.text else { return }
            
            UserDefaults.standard.setUsername(username)
            UserDefaults.standard.setPassword(password)
        }
    }
    
    fileprivate func handleCheckBox(isOn: Bool) {
        
        isRemember = isOn
    }
    
    fileprivate func isRemembered() -> Bool {
        
        return UserDefaults.standard.isRemembered()
    }
}

//MARK: check valid
extension LoginController {
    
    fileprivate func checkInvalid() -> Bool {
        
        if (usernameTextField.text?.isEmptyStr)! || !self.isValidUsername(usernameTextField.text!) {
            self.showJHTAlerttOkayWithIcon(message: "Invalid Email!\nPlease type valid Email")
            return false
        }
        
        if (passwordTextField.text?.isEmptyStr)! || !self.isValidPassword(passwordTextField.text!) {
            self.showJHTAlerttOkayWithIcon(message: "Invalid Password!\nPlease type valid Password")
            return false
        }
        return true
    }
    
    fileprivate func isValidUsername(_ username: String) -> Bool {
        // print("validate calendar: \(testStr)")
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: email)
        
        if username.count >= 1 {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func isValidPassword(_ password: String) -> Bool {
        if password.count >= 5 {
            return true
        } else {
            return false
        }
    }
}

//MARK: handle textfield invalid
extension LoginController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return false
        }
        
        if textField == usernameTextField {
            if let emailField = textField as? SkyFloatingLabelTextFieldWithIcon {
                
                if self.isValidUsername(text) {
                    emailField.errorMessage = ""
                } else {
                    emailField.errorMessage = "Invalid Email"
                }
                
            }
            return true
        } else {
            if let passwordField = textField as? SkyFloatingLabelTextFieldWithIcon {
                if self.isValidPassword(text) {
                    passwordField.errorMessage = ""
                } else {
                    passwordField.errorMessage = "Weak Password"
                }
            }
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
}


//MARK: setup views
extension LoginController {
    
    fileprivate func setupViews() {
        
        setupBackground()
        signinStuff()
    }
    
    
    private func setupBackground() {
        view.backgroundColor = .white
        
        let backgoundImage = UIImage(named: AssetName.background.rawValue)
        let backgoundImageView = UIImageView(image: backgoundImage)
        
        view.addSubview(backgoundImageView)
        _ = backgoundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let logoImage = UIImage(named: AssetName.logo.rawValue)?.withRenderingMode(.alwaysTemplate)
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.tintColor = DarkModeManager.getLoginPageTintColor()
        
        view.addSubview(logoImageView)
        
        //logo image size = 578*288
        
        var topConstant: CGFloat = 80.0
        var widthConstant: CGFloat = 200
        if UI_USER_INTERFACE_IDIOM() == .pad {
            topConstant = 150
            widthConstant = 350
        }
        
        _ = logoImageView.anchor(view.topAnchor, left: nil, bottom: nil, right: nil, topConstant: topConstant, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: widthConstant, heightConstant: widthConstant * 288 / 578)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func signinStuff() {
        
        var widthConstant = DEVICE_WIDTH * 0.7
        if UI_USER_INTERFACE_IDIOM() == .pad {
            widthConstant = DEVICE_WIDTH * 0.6
        }
        
        view.addSubview(passwordTextField)
        _ = passwordTextField.anchor(view.centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: widthConstant, heightConstant: 50)
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(usernameTextField)
        _ = usernameTextField.anchor(nil, left: nil, bottom: passwordTextField.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: widthConstant, heightConstant: 50)
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(qrScanButton)
        _ = qrScanButton.anchor(nil, left: nil, bottom: nil, right: passwordTextField.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 30, heightConstant: 30)
        qrScanButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        qrScanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(loginButton)
        _ = loginButton.anchor(passwordTextField.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: widthConstant, heightConstant: 50)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(rememberMeLabel)
        _ = rememberMeLabel.anchor(loginButton.bottomAnchor, left: view.centerXAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: -35, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        view.addSubview(checkBox)
        _ = checkBox.anchor(nil, left: nil, bottom: nil, right: rememberMeLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 25, heightConstant: 25)
        checkBox.centerYAnchor.constraint(equalTo: rememberMeLabel.centerYAnchor).isActive = true
        
//        view.addSubview(dontHaveAccountButton)
//        _ = dontHaveAccountButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 0, heightConstant: 30)
    }
    
    fileprivate func setupStatusBar() {
        
    }
}



extension SkyFloatingLabelTextFieldWithIcon {
    
    func setPropertiesForLoginPage() {
        self.placeholderColor = DarkModeManager.getLoginPageTintColor()
        self.lineColor = DarkModeManager.getLoginPageTintColor()
        self.iconColor = DarkModeManager.getLoginPageTintColor()
        
        self.tintColor = StyleGuideManager.currentPageIndicatorGreenTintColor
        self.selectedTitleColor = StyleGuideManager.currentPageIndicatorGreenTintColor
        self.selectedLineColor = StyleGuideManager.currentPageIndicatorGreenTintColor
        self.selectedIconColor = StyleGuideManager.currentPageIndicatorGreenTintColor
        self.textColor = DarkModeManager.getLoginPageTintColor()
    }
    
}





























