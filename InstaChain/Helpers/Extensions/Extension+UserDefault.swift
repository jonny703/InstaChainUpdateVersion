//
//  Extension+UserDefault.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation


enum PrivateKeyType: String {
    case owner = "owner"
    case active = "active"
    case posting = "posting"
    case memo = "memo"
    case master = "master"
}

extension UserDefaults {
    
    
    enum UserDefaultsKeys: String {
        
        case isRemember
        
        case isLoggedIn
        case fullname
        case username
        case firstname
        case lastname
        case email
        case password
        case security
        case securityCode
        case darkMode
        case keyType
    }
    
    func setPrivateKeyType(_ code: String) {
        set(code, forKey: UserDefaultsKeys.keyType.rawValue)
        synchronize()
    }
    
    func getPrivateKeyType() -> String? {
        if let code = string(forKey: UserDefaultsKeys.keyType.rawValue) {
            return code
        }
        return nil
    }
    
    //MARK: remember
    func setIsRemembered(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isRemember.rawValue)
        synchronize()
    }
    
    func isRemembered() -> Bool {
        return bool(forKey: UserDefaultsKeys.isRemember.rawValue)
    }
    
    //MARK: check login
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    // set security
    
    func setSecuirty(value: Bool) {
        set(value, forKey: UserDefaultsKeys.security.rawValue)
        synchronize()
    }
    
    func isSecuirty() -> Bool {
        return bool(forKey: UserDefaultsKeys.security.rawValue)
    }
    
    func setSecurityCode(_ code: String) {
        set(code, forKey: UserDefaultsKeys.securityCode.rawValue)
        synchronize()
    }
    
    func getSecurityCode() -> String? {
        if let code = string(forKey: UserDefaultsKeys.securityCode.rawValue) {
            return code
        }
        return nil
    }
    
    // set dark mode
    
    func setDarkMode(_ value: Bool) {
        set(value, forKey: UserDefaultsKeys.darkMode.rawValue)
        synchronize()
    }
    
    func getDarkMode() -> Bool {
        return bool(forKey: UserDefaultsKeys.darkMode.rawValue)
    }
    
    //MARK: save user full name
    func setUserFullName(_ fullname: String) {
        set(fullname, forKey: UserDefaultsKeys.fullname.rawValue)
        synchronize()
    }
    
    func getFullname() -> String? {
        if let fullname = string(forKey: UserDefaultsKeys.fullname.rawValue) {
            return fullname
        }
        return nil
    }
    
    //MARK: save username
    func setUsername(_ username: String) {
        set(username, forKey: UserDefaultsKeys.username.rawValue)
        synchronize()
    }
    
    func getUsername() -> String? {
        if let username = string(forKey: UserDefaultsKeys.username.rawValue) {
            return username
        }
        return nil
    }
    
    //MARK: save firstname
    func setFirstname(_ firstname: String) {
        set(firstname, forKey: UserDefaultsKeys.firstname.rawValue)
        synchronize()
    }
    
    func getFirstname() -> String? {
        if let firstname = string(forKey: UserDefaultsKeys.firstname.rawValue) {
            return firstname
        }
        return nil
    }
    
    //MARK: save lastname
    func setLastname(_ lastname: String) {
        set(lastname, forKey: UserDefaultsKeys.lastname.rawValue)
        synchronize()
    }
    
    func getLastname() -> String? {
        if let lastname = string(forKey: UserDefaultsKeys.lastname.rawValue) {
            return lastname
        }
        return nil
    }
    
    //MARK: save email
    func setEmail(_ email: String) {
        set(email, forKey: UserDefaultsKeys.email.rawValue)
        synchronize()
    }
    
    func getEmail() -> String? {
        if let email = string(forKey: UserDefaultsKeys.email.rawValue) {
            return email
        }
        return nil
    }
    
    //MARK: save user password
    func setPassword(_ password: String) {
        set(password, forKey: UserDefaultsKeys.password.rawValue)
        synchronize()
    }
    
    func getPassword() -> String? {
        if let password = string(forKey: UserDefaultsKeys.password.rawValue) {
            return password
        }
        return nil
    }
    
}
