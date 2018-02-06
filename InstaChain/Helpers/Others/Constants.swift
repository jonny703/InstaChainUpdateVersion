//  Constants.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//


import Foundation
import UIKit
import Cloudinary

class Constants {


    static let appRed = UIColor(red:0.96, green:0.46, blue:0.62, alpha:1)
    static let pinkMarathon = UIColor(red:0.18, green:0.52, blue:0.97, alpha:1)
    //static let primaryColor = UIColor(red:0.25, green:0.55, blue:0.9, alpha:1)
    static let cornerRadius: CGFloat = 5.0
    
    static let primaryColor = UIColor(red: 71/255.0, green: 198/255.0, blue: 206/255.0,alpha: 1)
    //static let accentColor = UIColor(red: 38/255.0, green: 160/255.0, blue: 255/255.0, alpha: 1)
    // static let primaryColor = UIColor(red: 33/255.0, green: 149/255.0, blue: 236/255.0,alpha: 1)
    // Hex Code = 2195EC
    static let accentColor = UIColor(red: 255/255.0, green: 64/255.0, blue: 129/255.0, alpha: 1)
    static let secondryColor = UIColor(red: 72/255.0, green: 61/255.0, blue: 139/255.0,alpha: 1)
    
    //Hex Code = 87COEC
    static let deviceTypeIos = "4"
    static let registerTypeFacebook = "1"
    static let registerTypeGoogle = "2"
    static let registerTypeApp = "3"
    // static let device_type
    static let passbookTypes = ["all", "add", "pay", "transfer", "received"]
    // Update Request Type
    
    static let updateTypeEmail = "0"
    static let updateTypePhone = "1"
    
    //Set Corner Dimenions
    
    //Login Type
    static let fb = "1"
    static let google = "2"
    
    static let height = 4
    static let width = 4
    // static let cornerRadius = 4
    
    static let prod = "1"
    
    //App error Messages
    
    static let emptyUsernameField = "Username is Empty"
    static let emptyPasswordField = "Password is Empty"
    static let wrongPassword = "Username or password is not correct"
    static let wentWrong = "Something went wrong"
    static let emptyFollowers = "No followers"
    static let emptyComments = "No Comments Be first for it"
    
    
    // Image Cloud Credentials
    let CLOUDINARY_URL = "cloudinary://924387254624291:sqzhXuQgQY9k0-YVpG2NiD7GVbk@anshulmahipal"
    
    static let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudinaryUrl: "cloudinary://924387254624291:sqzhXuQgQY9k0-YVpG2NiD7GVbk@anshulmahipal")!)
    
    
}


enum ControllerType : String {
    case home = "home"
    case followers = "follower"
    case following = "following"
}

enum PostType: String {
    case hot = "http://api.instachain.io:3000/get_discussions_by_hot"
    case trend = "http://api.instachain.io:3000/get_discussions_by_trending"
    case new = "http://api.instachain.io:3000/get_discussions_by_created"
}

enum RoleType: String {
    case active = "active"
    case memo = "memo"
    case posting = "posting"
    case owner = "owner"
}
