//
//  CurrentSession.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation

class CurrentSession {
    let Authorization = ""
    let KEY_LOCAL_DATA = "local"
    let KEY_PROFILE = "profile"
    let KEY_SESSION = "session"
    let KEY_USER_BASE_INFO = "userBaseInfo"
    let KEY_PRIV_KEY = "privWif"
    let KEY_PUB_KEY = "pubWif"

    

    private static var i : CurrentSession!


    
    let dobFormatter = DateFormatter()
    var sessionId = "$2y$10$pt7cH/DseV9o5Nw/m3t8c.OWJ1Td2yoNFE1SwOlYOlE5ZCOiZTp3G"
    //{
//        didSet{
//            let ud = UserDefaults.standard
//            ud.set(sessionId, forKey: KEY_SESSION)
//        }
//    }

    var profile : ProfileData!
    var userData: UserData!
    //var propertyData: PropertyData!
    var localData = LocalData()
   

    
    static func getI() -> CurrentSession {
        
        if i == nil {
            i = CurrentSession()
        }
        
        return i
    }
    
    init() {

        if let data = UserDefaults.standard.object(forKey: KEY_PROFILE) as? Data {
            let unarc = NSKeyedUnarchiver(forReadingWith: data)
            profile = unarc.decodeObject(forKey: "root") as! ProfileData
        }

        if let data = UserDefaults.standard.string(forKey: KEY_LOCAL_DATA){
            localData = LocalData(JSONString: data) ?? LocalData()
        }
     
        
        if profile == nil {
            profile = ProfileData()
        }
        
        sessionId = UserDefaults.standard.string(forKey: KEY_SESSION) ?? ""
        dobFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func saveData() {
        let ud = UserDefaults.standard
        ud.set(NSKeyedArchiver.archivedData(withRootObject: profile), forKey: KEY_PROFILE)
        ud.set(sessionId, forKey: KEY_SESSION)
        print(localData.toJSONString(prettyPrint: true) ?? "")
        ud.set(localData.toJSONString() ?? "", forKey: KEY_LOCAL_DATA)
       

        ud.synchronize()

    }

    func isUserLoginIn() -> Bool {
        return !sessionId.isEmpty
    }
    
    
    func onLogout() {
        sessionId = ""
        profile = ProfileData()
        saveData()
    }
    
}
