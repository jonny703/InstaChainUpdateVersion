//
//  EditProfileController.swift
//  InstaChain
//
//  Created by John Nik on 2/4/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import SVProgressHUD
import ImagePicker
import Cloudinary
import ObjectMapper

class EditProfileController: UIViewController {
    
    var isSelectNewImage: Bool = false
    var image: UIImage?
    
    var data = CurrentSession.getI().localData.userBaseInfo
    var userData: [UserInfoData?] = [UserInfoData()]
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AssetName.myProfile.rawValue)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = DarkModeManager.getProfileImageBorderColor().cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let usernameTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Username"
        textField.textColor = DarkModeManager.getDefaultTextColor()
        textField.borderColor = DarkModeManager.getTextFieldBorderColor()
        textField.keyboardAppearance = DarkModeManager.getKeyboardApperance()
        return textField
        
    }()
    
    let locationTextField: ToplessTextField = {
        
        let textField = ToplessTextField()
        textField.placeholder = "Location"
        textField.textColor = DarkModeManager.getDefaultTextColor()
        textField.borderColor = DarkModeManager.getTextFieldBorderColor()
        textField.keyboardAppearance = DarkModeManager.getKeyboardApperance()
        return textField
        
    }()
    
    let aboutMeTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.textColor = DarkModeManager.getTextFieldBorderColor()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = DarkModeManager.getTextFieldBorderColor().cgColor
        textView.layer.borderWidth = 2
        textView.layer.masksToBounds = true
        textView.backgroundColor = DarkModeManager.getTextViewBackgroundColor()
        textView.keyboardAppearance = DarkModeManager.getKeyboardApperance()
        return textView
    }()
    
    lazy var photoCameraButton: UIButton = {
        
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.shottingIcon.rawValue)
        button.setImage(image, for: .normal)
        button.tintColor = DarkModeManager.getPhotoCameraTintColor()
        button.addTarget(self, action: #selector(handleProfileImageView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        fetchUsers()
    }
}

extension EditProfileController {
    
    fileprivate func handleProfileData() {
        
        guard let profileData = userData[0] else { return }
        
        usernameTextField.text = profileData.jsonMetadata?.profile?.name
        locationTextField.text = profileData.jsonMetadata?.profile?.location
        
        if let aboutMe = profileData.jsonMetadata?.profile?.about {
            aboutMeTextView.hidePlaceholderLabel()
            aboutMeTextView.text = aboutMe
        }
        
        guard let profileImageUrlString = profileData.jsonMetadata?.profile?.profileImage, let profileImageUrl = URL(string: profileImageUrlString) else { return }
        
        userImageView.sd_setIndicatorStyle(.gray)
        userImageView.sd_addActivityIndicator()
        userImageView.sd_setImage(with: profileImageUrl, completed: nil)
        
    }
    
    fileprivate func fetchUsers() {
        guard ReachabilityManager.shared.internetIsUp else {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        self.getUserInfo(name:self.data?.name ?? "")
    }
    
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
                    strongSelf.userData.removeAll()
                    strongSelf.userData = data
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self?.handleProfileData()
                    }
                    
                }
                break
            default:
                break
                
            }
        }
    }
}

extension EditProfileController {
    
    @objc fileprivate func handleProfileImageView() {
        let imagePicker = ImagePickerController()
        imagePicker.imageLimit = 1
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //upload image to server
    
    func uploadImageToServer(data: Data, name: String) {
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        SVProgressHUD.show()
        
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
            if let userInfoMetaData = self.userData[0]?.jsonMetadata, let memoKey = CurrentSession.getI().localData.pubWif?.memo, let name = self.data?.name {
                self.editImage(name: name, wif: CurrentSession.getI().localData.privWif?.active ?? "", memoKey: memoKey, jsonMetaData: userInfoMetaData)
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
                
                SVProgressHUD.dismiss()
                
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
                    
                    DispatchQueue.main.async {
                        self.handleProfileData()
                        NotificationCenter.default.post(name: .reloadSideMenu, object: nil)
                        self.handleDismissController()
                    }
                    
                }
            })
            
            dataTask.resume()
        }
        catch {
            
        }
    }
}

extension EditProfileController: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        
        for image in images{
            self.image = image
            self.isSelectNewImage = true
        }
        dismiss(animated: false, completion: nil)
        
        self.uploadImageToServer(data: UIImageJPEGRepresentation(self.image!, 0.2)!, name: (self.data?.name)!)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    
}

extension EditProfileController {
    
    @objc fileprivate func handleDismissController() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleSave() {
        
        if (self.usernameTextField.text?.isEmpty)! {
            self.showJHTAlerttOkayWithIcon(message: "Please enter your username")
            return
        }
        
        guard let username = usernameTextField.text else { return }
        let location = locationTextField.text
        let aboutMe = aboutMeTextView.text
        
        self.userData[0]?.jsonMetadata?.profile?.name = username
        self.userData[0]?.jsonMetadata?.profile?.location = location
        self.userData[0]?.jsonMetadata?.profile?.about = aboutMe
        if let userInfoMetaData = self.userData[0]?.jsonMetadata, let memoKey = CurrentSession.getI().localData.pubWif?.memo, let name = self.data?.name {
            SVProgressHUD.show()
            self.editImage(name: name, wif: CurrentSession.getI().localData.privWif?.active ?? "", memoKey: memoKey, jsonMetaData: userInfoMetaData)
        }
        
    }
}

extension EditProfileController {
    
    fileprivate func setupViews() {
        
        view.backgroundColor = DarkModeManager.getViewBackgroundColor()
        
        setupNavBar()
        setupProfileView()
    }
    
    private func setupProfileView() {
        
        view.addSubview(userImageView)
        _ = userImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        
        view.addSubview(usernameTextField)
        _ = usernameTextField.anchor(userImageView.topAnchor, left: userImageView.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 40)
        
        view.addSubview(locationTextField)
        _ = locationTextField.anchor(usernameTextField.bottomAnchor, left: usernameTextField.leftAnchor, bottom: nil, right: usernameTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        view.addSubview(aboutMeTextView)
        _ = aboutMeTextView.anchor(userImageView.bottomAnchor, left: userImageView.leftAnchor, bottom: nil, right: usernameTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 120)
        
        view.addSubview(photoCameraButton)
        
        _ = photoCameraButton.anchor(nil, left: nil, bottom: userImageView.bottomAnchor, right: userImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "Edit Profile"
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelImage = UIImage(named: AssetName.cancel.rawValue)
        let backButton = UIBarButtonItem(image: cancelImage, style: .plain, target: self, action: #selector(handleDismissController))
        navigationItem.leftBarButtonItem = backButton
    }
}
















