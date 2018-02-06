//
//  NewDiscussionController.swift
//  InstaChain
//
//  Created by John Nik on 2/2/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import ImagePicker
import Cloudinary
import SVProgressHUD
import CloudTagView
import ObjectMapper

class NewDiscussionController: UIViewController {
    
    var homeController: HomeController?
    
    let cloudinary = Constants.cloudinary
    
    var data = CurrentSession.getI().localData.userBaseInfo
    var tagStrings = [String]()
    
    var postImage: UIImage? {
        
        didSet {
            guard let image = postImage else { return }
            postImageView.image = image
        }
    }
    
    let postImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = DarkModeManager.getProfileImageBorderColor().cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter title"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: FONTSIZE20)
        textField.textColor = DarkModeManager.getDefaultTextColor()
        textField.backgroundColor = DarkModeManager.getTextViewBackgroundColor()
        textField.keyboardAppearance = DarkModeManager.getKeyboardApperance()
        return textField
    }()
    
    lazy var tagsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Tag"
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.textColor = DarkModeManager.getDefaultTextColor()
        textField.backgroundColor = DarkModeManager.getTextViewBackgroundColor()
        textField.keyboardAppearance = DarkModeManager.getKeyboardApperance()
        return textField
    }()
    
    lazy var postTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.placeholderLabel.text = "Write caption"
        textView.placeholderLabel.textColor = DarkModeManager.getTextViewTextColor()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = DarkModeManager.getTextViewBorderColor().cgColor
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        textView.delegate = self
        textView.textColor = DarkModeManager.getDefaultTextColor()
        textView.backgroundColor = DarkModeManager.getTextViewBackgroundColor()
        textView.keyboardAppearance = DarkModeManager.getKeyboardApperance()
        return textView
        
    }()
    
    let permlink = UITextField()
    
    lazy var addTagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Tag", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleAddTag), for: .touchUpInside)
        return button
    }()
    
    lazy var postButton: UIBarButtonItem = {
        let postButton = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePost))
        return postButton
    }()
    
    let tagView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }()
    
    lazy var cloudView: CloudTagView = {
        let view = CloudTagView()
        view.delegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

extension NewDiscussionController {
    
    @objc fileprivate func handleAddTag() {
        
        guard let tagText = tagsTextField.text, !tagText.isEmpty else { return }
        
        let tagView = TagView(text: tagsTextField.text!)
        tagView.font = UIFont.systemFont(ofSize: 18)
        tagView.backgroundColor = DarkModeManager.getTagViewBackgroundColor()
        tagView.tintColor = DarkModeManager.getTagViewTintColor()
        
        cloudView.tags.append(tagView)
        self.tagStrings.append(tagText.lowercased())
        if cloudView.tags.count > 29 {
            addTagButton.isEnabled = false
        }
        tagsTextField.text = ""
    }
 
    fileprivate func checkInvalid() -> Bool {
        
        if (titleTextField.text?.isEmptyStr)! {
            self.showJHTAlerttOkayWithIcon(message: "Invalid Title!\nPlease enter valid title")
            return false
        }
        
        if (postTextView.text?.isEmptyStr)! {
            self.showJHTAlerttOkayWithIcon(message: "Invalid Caption!\nPlease enter valid caption")
            return false
        }
        
        if tagStrings.count == 0 {
            self.showJHTAlerttOkayWithIcon(message: "Invalid Tag!\nPlease enter valid tag")
            return false
        }
        return true
    }
}

extension NewDiscussionController {
    
    @objc fileprivate func handleDismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handlePost() {
        
        if !(checkInvalid()) {
            return
        }
        
        guard ReachabilityManager.shared.internetIsUp else {
            self.showJHTAlerttOkayWithIcon(message: AlertMessages.failedInternetTitle.rawValue)
            return
        }
        
        guard let postImage = postImage else { return }
        self.uploadImageToServer(data: self.convertImageToBase64(image: postImage))
        
        postButton.isEnabled = false
        
    }
}



extension NewDiscussionController {
    
    //Convert a image to base64
    func convertImageToBase64(image: UIImage) -> Data {
        
        return UIImageJPEGRepresentation(image, 0.2)!
        
    }
    
    func uploadImageToServer(data: Data) {
        
        SVProgressHUD.show()
        
        let param = CLDUploadRequestParams().setUploadPreset("This is").setPublicId(String.random()).setTags("This is tag")
        
        // cloudinary.createUploader().upload(data: data, uploadPreset: "String", params: param)
        cloudinary.createUploader().upload(data: data, uploadPreset: "yg0w8y1g", params: param, progress: { (progress) in
            print(progress.fractionCompleted)
            SVProgressHUD.dismiss()
        }) { (result, error) in
            if let url = result?.url{
//                self.tagStrings.append(self.permlink.text!)
                self.commnentOnPost(title: self.titleTextField.text!, body: (self.postTextView.text)!, url: [url], author: (self.data?.name)!, tag: self.tagStrings, wif: (CurrentSession.getI().localData.privWif?.active)!, parentPermlink: self.tagStrings[0])
            } else {
                SVProgressHUD.dismiss()
            }
        }
        
    }
    
    //MARK:- For comment on Post
    func commnentOnPost(title: String, body: String, url: [String], author: String, tag: [String], wif: String, parentPermlink: String) {
        
        let headers = [
            "content-type": "application/json",
            ]
        let parameters = [
            "parent_author": "",
            "parent_permlink": parentPermlink,
            "author": author,
            "permlink": title.split(separator: " ").joined(separator: "-").lowercased(),
            "title": title,
            "body": body,
            "json_metadata": [
                "tags": tag,
                "users": ["amin"],
                "links": [""],
                "image": url,
                "format": "html",
                "app": "instachain_mobile/0.1"
            ],
            "wif": wif
            ] as [String : Any]
        
        do {
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: ServerUrls.postComment)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                
                
                if (error != nil) {
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.showJHTAlerttOkayWithIcon(message: "Something went wrong!\nTry again later")
                        self.postButton.isEnabled = true
                    }
                    print(error)
                } else {
                    _ = response as? HTTPURLResponse
                    let responseString = String(data: data!, encoding: .utf8)
                    
                    let responseStr = String(describing: responseString?.filter { !"\\".contains($0) })
                    print("responseString = \(String(describing: responseString))")
                    print("responseStr = \(String(describing: responseStr))")
                    
                    let commentsData = Mapper<CommentResponseData>().map(JSONString: responseString!)
                    
                    print(commentsData?.blockNum)
                    
                    print(commentsData?.blockNum)
                    print(commentsData?.operationData)
                    
                    if let operations = commentsData?.operationData as? Array<Any> {
                        for items in operations {
                            if let operation = items as? Array<Any> {
                                for items in operation {
                                    if let item = items as? String{
                                        print(item)
                                    }else {
                                        if let item = items as? CommentResponseData {
                                            print(item.id)
                                        }
                                    }
                                    
                                }
                            }
                        }
                        SVProgressHUD.dismiss()
                        self.handleDismissController()
                        self.homeController?.fetchHomeFeed()
                        
                    } else {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.showJHTAlerttOkayWithIcon(message: "Something went wrong!\nTry again later")
                            self.postButton.isEnabled = true
                        }
                    }
                }
                
            })
            
            dataTask.resume()
        }
        catch {
            
        }
        
    }
    
    //set up tags
    func setupTags(item: String) {
        self.tagStrings.append(item)
        
        for tag in tagStrings {
            let tagView = TagView(text: tag)
            tagView.backgroundColor = UIColor.appPrimary()
            
            cloudView.tags.append(TagView(text: tag))
        }
        self.tagView.addSubview(cloudView)
    }
}

extension NewDiscussionController: TagViewDelegate {
    func tagDismissed(_ tag: TagView) {
        self.tagStrings = tagStrings.filter{$0 != tag.text}
        addTagButton.isEnabled = true
    }
}

extension NewDiscussionController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        for image in images{
            self.postImageView.image = image
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
}

extension NewDiscussionController: UITextFieldDelegate, UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 2200
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.titleTextField {
            let currentText = titleTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 150
        }else{
            
            let whitespaceSet = NSCharacterSet.whitespaces
            if let _ = string.rangeOfCharacter(from: whitespaceSet){
                cloudView.tags.append(TagView(text: tagsTextField.text!))
                self.tagsTextField.text = ""
                
            }
            return true
            
        }
    }
    
}


extension NewDiscussionController {
    
    fileprivate func setupViews() {
        
        view.backgroundColor = DarkModeManager.getViewBackgroundColor()
        
        setupNavBar()
        setupPostViews()
    }
    
    private func setupNavBar() {
        
        navigationItem.title = "New Post"
        
        
        navigationItem.rightBarButtonItem = postButton
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleDismissController))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupPostViews() {
        
        view.addSubview(titleTextField)
        _ = titleTextField.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        
        view.addSubview(postImageView)
        _ = postImageView.anchor(titleTextField.bottomAnchor, left: titleTextField.leftAnchor, bottom: nil, right: nil, topConstant: GAP20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: GAP100, heightConstant: GAP100)
        
        view.addSubview(postTextView)
        _ = postTextView.anchor(postImageView.topAnchor, left: postImageView.rightAnchor, bottom: postImageView.bottomAnchor, right: titleTextField.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let lineView = UIView()
        lineView.backgroundColor = .darkGray
        
        view.addSubview(lineView)
        _ = lineView.anchor(postImageView.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: titleTextField.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 2)
        
        let tagsLabel = UILabel()
        tagsLabel.text = "Tags #"
        tagsLabel.font = UIFont.systemFont(ofSize: 20)
        tagsLabel.textColor = DarkModeManager.getDefaultTextColor()
        
        view.addSubview(tagsLabel)
        _ = tagsLabel.anchor(lineView.bottomAnchor, left: titleTextField.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 40)
        
        view.addSubview(addTagButton)
        _ = addTagButton.anchor(tagsLabel.topAnchor, left: nil, bottom: tagsLabel.bottomAnchor, right: titleTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 75, heightConstant: 0)
        
        view.addSubview(tagsTextField)
        _ = tagsTextField.anchor(tagsLabel.topAnchor, left: tagsLabel.rightAnchor, bottom: tagsLabel.bottomAnchor, right: addTagButton.leftAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        view.addSubview(cloudView)
        _ = cloudView.anchor(tagsTextField.bottomAnchor, left: titleTextField.leftAnchor, bottom: nil, right: titleTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 130)
        
//        tagView.addSubview(cloudView)
    }
}

















